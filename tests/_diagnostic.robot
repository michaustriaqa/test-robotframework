*** Settings ***
Documentation       Temporary diagnostic, round 7: Overlapped Element's field returns empty
...                 even immediately after a synchronous JS value-set + input-event
...                 dispatch, suggesting a listener resets it. Tests plain native input,
...                 JS set without dispatch, JS set with dispatch, and the React "native
...                 setter" trick, all at the same 1920x1080 window size the real suite
...                 uses. Not part of the portfolio.
Resource            ../resources/pages/playground_page.resource
Suite Setup         Open Browser    about:blank    ${BROWSER}
Suite Teardown      Close All Browsers
Test Tags           smoke


*** Test Cases ***
Dump Overlapped Field Interaction Approaches
    Set Window Size    1920    1080
    Go To Playground Page    overlapped
    ${listeners}=    Execute Javascript
    ...    var el = document.querySelector('#name');
    ...    return 'outerHTML=' + el.outerHTML + ' oninput=' + el.oninput + ' onchange=' + el.onchange;
    Log    FIELD ATTRIBUTES: ${listeners}    console=True

    ${set_only}=    Execute Javascript
    ...    var el = document.querySelector('#name');
    ...    el.value = 'SetOnly';
    ...    return 'value right after plain set, no dispatch: ' + el.value;
    Log    ${set_only}    console=True
    ${value_after_set_only}=    Get Element Attribute    css:#name    value
    Log    VALUE VIA SELENIUM AFTER PLAIN SET (NO DISPATCH): ${value_after_set_only}    console=True

    Go To Playground Page    overlapped
    ${native_setter_result}=    Execute Javascript
    ...    var el = document.querySelector('#name');
    ...    var setter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set;
    ...    setter.call(el, 'NativeSetter');
    ...    el.dispatchEvent(new Event('input', {bubbles: true}));
    ...    return 'value right after native setter + dispatch: ' + el.value;
    Log    ${native_setter_result}    console=True
    ${value_after_native_setter}=    Get Element Attribute    css:#name    value
    Log    VALUE VIA SELENIUM AFTER NATIVE SETTER: ${value_after_native_setter}    console=True

    Go To Playground Page    overlapped
    ${click_result}=    Run Keyword And Ignore Error    Click Element    css:#name
    Log    CLICK RESULT: ${click_result}    console=True
    ${input_result}=    Run Keyword And Ignore Error    Input Text    css:#name    PlainInput
    Log    PLAIN INPUT TEXT RESULT: ${input_result}    console=True
    ${value_after_plain_input}=    Get Element Attribute    css:#name    value
    Log    VALUE AFTER PLAIN INPUT TEXT: ${value_after_plain_input}    console=True

    ${overlap_check}=    Execute Javascript
    ...    var el = document.querySelector('#name');
    ...    var rect = el.getBoundingClientRect();
    ...    var top = document.elementFromPoint(rect.left + rect.width / 2, rect.top + rect.height / 2);
    ...    return 'isTop=' + (top === el) + ' topTag=' + (top ? top.outerHTML.substring(0, 80) : 'none');
    Log    OVERLAP CHECK AT 1920x1080: ${overlap_check}    console=True
