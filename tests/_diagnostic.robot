*** Settings ***
Documentation       Temporary diagnostic: dumps real DOM structure for every failing
...                 playground page in one CI run. Not part of the portfolio.
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
Dump Class Attribute
    Go To Playground Page    classattr
    Dump Page Elements

Dump Hidden Layers
    Go To Playground Page    hiddenlayers
    Dump Page Elements

Dump Dynamic Table
    Go To Playground Page    dynamictable
    Dump Page Elements

Dump Verify Text
    Go To Playground Page    verifytext
    Dump Page Elements

Dump Progress Bar
    Go To Playground Page    progressbar
    Click Button    ${PROGRESS_BAR_START_BUTTON}
    Sleep    20s
    ${value}=    Get Element Attribute    ${PROGRESS_BAR}    aria-valuenow
    Log    PROGRESS AFTER 20s: ${value}    console=True

Dump Sample App
    Go To Playground Page    sampleapp
    Dump Page Elements

Dump Mouse Over
    Go To Playground Page    mouseover
    Dump Page Elements

Dump Overlapped
    Go To Playground Page    overlapped
    Dump Page Elements
    Input Text    css:#name    Michelle
    ${value}=    Get Element Attribute    css:#name    value
    Log    NAME VALUE AFTER INPUT: ${value}    console=True

Dump Shadow Dom
    Go To Playground Page    shadowdom
    ${dump}=    Execute Javascript
    ...    var host = document.querySelector('guid-generator');
    ...    if (!host) { return 'NO guid-generator HOST FOUND. Custom tags: ' + Array.from(document.querySelectorAll('*')).filter(function(e) { return e.tagName.includes('-'); }).map(function(e) { return e.tagName; }).join(','); }
    ...    var root = host.shadowRoot;
    ...    if (!root) { return 'HOST FOUND BUT NO shadowRoot'; }
    ...    return Array.from(root.querySelectorAll('*')).map(function(e) { return e.tagName + '#' + (e.id || '') + '.' + (e.className || ''); }).join(' | ');
    Log    SHADOW DUMP: ${dump}    console=True

Dump Alerts
    Go To Playground Page    alerts
    Dump Page Elements

Dump File Upload
    Go To Playground Page    upload
    Dump Page Elements

Dump Animated Button
    Go To Playground Page    animatedbutton
    Dump Page Elements

Dump Disabled Input
    Go To Playground Page    disabledinput
    Dump Page Elements

Dump Auto Wait
    Go To Playground Page    auto_wait
    Dump Page Elements

Dump Auto Complete
    Go To Playground Page    auto_complete
    Dump Page Elements
