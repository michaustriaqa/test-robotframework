*** Settings ***
Documentation       Temporary diagnostic, round 4: dumps the remaining playground pages
...                 whose locators were never verified against the real site (they were
...                 guessed from memory and might be wrong, the same way classattr,
...                 hiddenlayers, sampleapp, and others turned out to be). Not part of
...                 the portfolio.
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
    ...    var all = withId.concat(interactive);
    ...    return Array.from(new Set(all)).join(' | ');
    Log    DUMP: ${dump}    console=True


*** Test Cases ***
Dump Dynamic Id
    Go To Playground Page    dynamicid
    Dump Page Elements

Dump Load Delay
    Go To Playground Page    loaddelay
    Sleep    16s
    Dump Page Elements

Dump Ajax Data
    Go To Playground Page    ajax
    Click Button    css:#ajaxButton
    Sleep    16s
    Dump Page Elements

Dump Client Side Delay
    Go To Playground Page    clientdelay
    Dump Page Elements
    Click Button    css:#ajaxButton
    Sleep    16s
    Dump Page Elements

Dump Click
    Go To Playground Page    click
    Dump Page Elements

Dump Text Input
    Go To Playground Page    textinput
    Dump Page Elements

Dump Scrollbars
    Go To Playground Page    scrollbars
    Dump Page Elements

Dump Non Breaking Space
    Go To Playground Page    nbsp
    Dump Page Elements

Dump Visibility
    Go To Playground Page    visibility
    Dump Page Elements
