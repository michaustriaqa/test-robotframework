*** Settings ***
Documentation       Temporary diagnostic, round 5: verifies interactive behavior (not just
...                 static structure) for the highest-risk pages before committing to test
...                 logic, after PR #2 shipped a test built on an unverified AJAX assumption
...                 that never held up in CI. Not part of the portfolio.
Resource            ../resources/pages/playground_page.resource
Suite Setup         Open Browser    about:blank    ${BROWSER}
Suite Teardown      Close All Browsers
Test Tags           smoke
Test Timeout        45s


*** Test Cases ***
Dump Visibility Initial States
    Go To Playground Page    visibility
    ${state}=    Execute Javascript
    ...    function state(id) {
    ...    var e = document.getElementById(id);
    ...    if (!e) { return id + '=MISSING'; }
    ...    var style = getComputedStyle(e);
    ...    return id + ':display=' + style.display + ',visibility=' + style.visibility + ',opacity=' + style.opacity + ',offsetParent=' + (e.offsetParent !== null);
    ...    }
    ...    return ['hideButton','removedButton','zeroWidthButton','overlappedButton','transparentButton','invisibleButton','notdisplayedButton','offscreenButton'].map(state).join(' | ');
    Log    VISIBILITY BEFORE CLICK: ${state}    console=True
    Click Button    ${VISIBILITY_HIDE_BUTTON}
    ${state_after}=    Execute Javascript
    ...    function state(id) {
    ...    var e = document.getElementById(id);
    ...    if (!e) { return id + '=MISSING'; }
    ...    var style = getComputedStyle(e);
    ...    return id + ':display=' + style.display + ',visibility=' + style.visibility + ',opacity=' + style.opacity + ',offsetParent=' + (e.offsetParent !== null);
    ...    }
    ...    return ['hideButton','removedButton','zeroWidthButton','overlappedButton','transparentButton','invisibleButton','notdisplayedButton','offscreenButton'].map(state).join(' | ');
    Log    VISIBILITY AFTER CLICK: ${state_after}    console=True

Dump Geolocation Behavior
    Go To Playground Page    geolocation
    Click Button    ${GEOLOCATION_REQUEST_BUTTON}
    Sleep    5s
    ${text}=    Get Text    ${GEOLOCATION_RESULT}
    Log    GEOLOCATION AFTER 5S: ${text}    console=True

Dump Auto Wait Behavior
    Go To Playground Page    autowait
    ${before}=    Execute Javascript    return document.getElementById('target').disabled;
    Log    AUTO WAIT TARGET DISABLED BEFORE: ${before}    console=True
    Click Button    ${AUTO_WAIT_APPLY_3S_BUTTON}
    ${during}=    Execute Javascript    return document.getElementById('target').disabled;
    Log    AUTO WAIT TARGET DISABLED IMMEDIATELY AFTER APPLY: ${during}    console=True
    Sleep    4s
    ${after}=    Execute Javascript    return document.getElementById('target').disabled;
    ${status}=    Get Text    ${AUTO_WAIT_STATUS}
    Log    AUTO WAIT TARGET DISABLED AFTER 4S: ${after} STATUS: ${status}    console=True

Dump Clear Input Behavior
    Go To Playground Page    clearinput
    ${before}=    Get Text    ${CLEAR_INPUT_STATUS}
    Log    CLEAR INPUT STATUS BEFORE: ${before}    console=True
    Clear Element Text    css:#clearInput
    Sleep    300ms
    ${after_one}=    Get Text    ${CLEAR_INPUT_STATUS}
    Log    CLEAR INPUT STATUS AFTER CLEARING ONE FIELD: ${after_one}    console=True
    Execute Javascript
    ...    var el = document.querySelector('#clearContentEditable');
    ...    el.textContent = '';
    ...    el.dispatchEvent(new Event('input', {bubbles: true}));
    Sleep    300ms
    ${after_editable}=    Get Text    ${CLEAR_INPUT_STATUS}
    Log    CLEAR INPUT STATUS AFTER CLEARING CONTENTEDITABLE DIV: ${after_editable}    console=True

Dump Scroll To Click Behavior
    Go To Playground Page    scrolltoclick
    Scroll Element Into View    ${SCROLL_TARGET_1}
    Click Button    ${SCROLL_TARGET_1}
    ${text}=    Get Text    ${SCROLL_PROGRESS_TEXT}
    Log    SCROLL PROGRESS AFTER ONE CLICK: ${text}    console=True

Dump Select Behavior
    Go To Playground Page    select
    Select From List By Label    ${SELECT_LANGUAGE}    Python
    ${status}=    Get Text    ${SELECT_STATUS_LANGUAGE}
    Log    SELECT LANGUAGE STATUS: ${status}    console=True

Dump Animation Behavior
    Go To Playground Page    animation
    ${before}=    Get Text    ${ANIMATION_STATUS}
    Click Button    ${ANIMATION_START_BUTTON}
    Wait Until Animation Stops    ${ANIMATION_MOVING_TARGET}
    Click Button    ${ANIMATION_MOVING_TARGET}
    Sleep    500ms
    ${after}=    Get Text    ${ANIMATION_STATUS}
    Log    ANIMATION STATUS BEFORE: ${before} AFTER: ${after}    console=True

Dump Css Selectors Hidden States
    Go To Playground Page    cssselectors
    ${state}=    Execute Javascript
    ...    function state(id) {
    ...    var e = document.getElementById(id);
    ...    if (!e) { return id + '=MISSING'; }
    ...    var style = getComputedStyle(e);
    ...    return id + ':display=' + style.display + ',visibility=' + style.visibility + ',opacity=' + style.opacity + ',offsetParent=' + (e.offsetParent !== null);
    ...    }
    ...    return ['hidden-display','hidden-visibility','hidden-overflow','hidden-opacity','hidden-offscreen'].map(state).join(' | ');
    Log    CSS SELECTORS HIDDEN STATES: ${state}    console=True
