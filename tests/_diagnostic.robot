*** Settings ***
Documentation       Temporary diagnostic, round 6: four assertions have now failed twice on
...                 guessed fixes (Hidden Layers' id-swap, Sample App's valid password,
...                 Mouse Over's link replacement, Overlapped's JS value-setting) -- this
...                 gets real evidence instead of guessing a third time. Not part of the
...                 portfolio.
Resource            ../resources/pages/playground_page.resource
Suite Setup         Open Browser    about:blank    ${BROWSER}
Suite Teardown      Close All Browsers
Test Tags           smoke


*** Test Cases ***
Dump Hidden Layers After Click
    Go To Playground Page    hiddenlayers
    ${before}=    Execute Javascript    return document.querySelector('#spa').outerHTML;
    Log    SPA BEFORE CLICK: ${before}    console=True
    Click Element    ${HIDING_BUTTON}
    ${after}=    Execute Javascript    return document.querySelector('#spa').outerHTML;
    Log    SPA AFTER CLICK: ${after}    console=True

Dump Sample App Login Attempt
    Go To Playground Page    sampleapp
    Input Text    ${SAMPLE_APP_USERNAME_FIELD}    Michelle
    Input Text    ${SAMPLE_APP_PASSWORD_FIELD}    pwd
    ${username_value}=    Get Element Attribute    ${SAMPLE_APP_USERNAME_FIELD}    value
    ${password_value}=    Get Element Attribute    ${SAMPLE_APP_PASSWORD_FIELD}    value
    Log    FIELD VALUES BEFORE SUBMIT: username=${username_value} password=${password_value}    console=True
    Click Button    ${SAMPLE_APP_LOGIN_BUTTON}
    ${status}=    Get Text    ${SAMPLE_APP_STATUS_MESSAGE}
    Log    STATUS AFTER SUBMIT: ${status}    console=True

Dump Mouse Over Link Structure
    Go To Playground Page    mouseover
    ${before}=    Execute Javascript
    ...    return Array.from(document.querySelectorAll('a')).map(function(a) {
    ...    return 'outerHTML=' + a.outerHTML;
    ...    }).join(' || ');
    Log    LINKS BEFORE HOVER: ${before}    console=True
    Mouse Over    css:a.text-primary
    Sleep    300ms
    ${after}=    Execute Javascript
    ...    return Array.from(document.querySelectorAll('a')).map(function(a) {
    ...    return 'outerHTML=' + a.outerHTML;
    ...    }).join(' || ');
    Log    LINKS AFTER HOVER: ${after}    console=True

Dump Overlapped Field Framework And Direct Js Set
    Go To Playground Page    overlapped
    ${framework}=    Execute Javascript
    ...    var root = document.getElementById('root') || document.getElementById('app') || document.body.firstElementChild;
    ...    return 'reactroot=' + (root && !!Object.keys(root).find(function(k) { return k.startsWith('__reactContainer') || k.startsWith('_reactRootContainer'); })) + ' outerHTML=' + document.querySelector('#name').outerHTML;
    Log    OVERLAPPED FIELD INFO: ${framework}    console=True
    ${direct_result}=    Execute Javascript
    ...    var el = document.querySelector('#name');
    ...    el.value = 'Michelle Austria';
    ...    el.dispatchEvent(new Event('input', {bubbles: true}));
    ...    return 'immediately after set: ' + el.value;
    Log    DIRECT SET RESULT: ${direct_result}    console=True
    Sleep    300ms
    ${value_after_wait}=    Get Element Attribute    css:#name    value
    Log    VALUE AFTER 300MS WAIT: ${value_after_wait}    console=True
