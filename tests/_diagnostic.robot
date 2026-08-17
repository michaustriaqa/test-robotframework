*** Settings ***
Documentation       Temporary diagnostic, round 3: the Dynamic Table page uses no <table>
...                 element (round 2's table/tr query came back empty), so it must use an
...                 ARIA row/cell pattern instead; and the File Upload widget lives inside
...                 an iframe with no top-level <input>. Both need direct inspection before
...                 real locators can be written. Not part of the portfolio.
Resource            ../resources/pages/playground_page.resource
Suite Setup         Open Browser    about:blank    ${BROWSER}
Suite Teardown      Close All Browsers
Test Tags           smoke


*** Test Cases ***
Dump Dynamic Table ARIA
    Go To Playground Page    dynamictable
    ${dump}=    Execute Javascript
    ...    return Array.from(document.querySelectorAll('[role]')).map(function(e) {
    ...    return e.getAttribute('role') + ':' + e.className + '="' + e.textContent.trim().substring(0, 30) + '"';
    ...    }).join(' | ');
    Log    ARIA DUMP: ${dump}    console=True

Dump File Upload Iframe
    Go To Playground Page    upload
    ${frame_info}=    Execute Javascript
    ...    var f = document.querySelector('iframe');
    ...    return 'name=' + f.name + ' id=' + f.id + ' src=' + f.src + ' className=' + f.className;
    Log    FRAME INFO: ${frame_info}    console=True
    Select Frame    css:iframe
    ${dump}=    Execute Javascript
    ...    function describe(e) {
    ...    var text = (e.innerText || e.value || '').trim().substring(0, 40);
    ...    return e.tagName + '#' + (e.id || '') + '.' + (e.className || '') + '="' + text + '"';
    ...    }
    ...    return Array.from(document.querySelectorAll('[id], button, input, a, p, label')).map(describe).join(' | ');
    Log    IFRAME CONTENT DUMP: ${dump}    console=True
