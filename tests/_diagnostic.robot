*** Settings ***
Documentation       Temporary diagnostic, round 2: dumps real DOM structure for the
...                 playground pages discovered via the real site's homepage link list
...                 (Frames, Geo Location, Clear Input, Scroll to Click, CSS Selectors,
...                 Select) plus remaining unknowns (dynamic table rows, sample app field
...                 types, file upload structure, alert text). Not part of the portfolio.
Resource            ../resources/pages/playground_page.resource
Suite Setup         Open Browser    about:blank    ${BROWSER}
Suite Teardown      Close All Browsers
Test Tags           smoke


*** Keywords ***
Dump Page Elements
    [Documentation]    Logs every element with an id, plus every button/input/a/p tag,
    ...                and any custom (hyphenated) element tags on the current page.
    ${dump}=    Execute Javascript
    ...    function describe(e) {
    ...    var text = (e.innerText || e.value || '').trim().substring(0, 40);
    ...    return e.tagName + '#' + (e.id || '') + '.' + (e.className || '') + '="' + text + '"';
    ...    }
    ...    var withId = Array.from(document.querySelectorAll('[id]')).map(describe);
    ...    var interactive = Array.from(document.querySelectorAll('button, input, a, p')).map(describe);
    ...    var customTags = Array.from(document.querySelectorAll('*')).filter(function(e) { return e.tagName.includes('-'); }).map(describe);
    ...    var all = withId.concat(interactive).concat(customTags);
    ...    return Array.from(new Set(all)).join(' | ');
    Log    DUMP: ${dump}    console=True


*** Test Cases ***
Dump Animation
    Go To Playground Page    animation
    Dump Page Elements

Dump Auto Wait
    Go To Playground Page    autowait
    Dump Page Elements

Dump Frames
    Go To Playground Page    frames
    ${dump}=    Execute Javascript
    ...    return Array.from(document.querySelectorAll('iframe')).map(function(f) {
    ...    return 'IFRAME#' + (f.id || '') + ' src=' + f.getAttribute('src');
    ...    }).join(' | ');
    Log    FRAMES DUMP: ${dump}    console=True
    Dump Page Elements

Dump Geolocation
    Go To Playground Page    geolocation
    Dump Page Elements

Dump Clear Input
    Go To Playground Page    clearinput
    Dump Page Elements

Dump Scroll To Click
    Go To Playground Page    scrolltoclick
    Dump Page Elements

Dump CSS Selectors
    Go To Playground Page    cssselectors
    Dump Page Elements

Dump Select
    Go To Playground Page    select
    Dump Page Elements

Dump Dynamic Table Full
    Go To Playground Page    dynamictable
    ${dump}=    Execute Javascript
    ...    return Array.from(document.querySelectorAll('table tr')).map(function(tr) {
    ...    return Array.from(tr.children).map(function(td) { return td.textContent.trim(); }).join(',');
    ...    }).join(' || ');
    Log    TABLE DUMP: ${dump}    console=True

Dump Sample App Fields
    Go To Playground Page    sampleapp
    ${dump}=    Execute Javascript
    ...    return Array.from(document.querySelectorAll('input')).map(function(i) {
    ...    return i.id + ':type=' + i.type + ':placeholder=' + (i.placeholder || '');
    ...    }).join(' | ');
    Log    FIELDS DUMP: ${dump}    console=True

Dump File Upload Full
    Go To Playground Page    upload
    ${dump}=    Execute Javascript
    ...    var iframes = document.querySelectorAll('iframe').length;
    ...    var inputs = Array.from(document.querySelectorAll('input')).map(function(i) {
    ...    return i.type + '#' + i.id;
    ...    });
    ...    return 'iframes=' + iframes + ' inputs=' + inputs.join(',');
    Log    UPLOAD DUMP: ${dump}    console=True

Dump Alerts Interaction
    Go To Playground Page    alerts
    Click Button    ${ALERT_BUTTON}
    ${msg}=    Handle Alert    action=ACCEPT
    Log    ALERT MESSAGE: ${msg}    console=True
