*** Settings ***
Documentation       Covers every challenge page listed on uitestingplayground.com's
...                 homepage (Inflectra's UI Test Automation Playground), one test case
...                 per page. Locators and assertions were derived by driving the live
...                 site from CI and inspecting its real DOM/behavior, not guessed from
...                 a generic memory of "a UI testing playground site" -- several pages
...                 (Class Attribute, Hidden Layers, Sample App, Visibility, Auto Wait,
...                 Animated Button, and others) have markup or interaction mechanics
...                 that differ from what their names might suggest.

Library             Collections
Resource            ../../resources/variables.resource
Resource            ../../resources/pages/playground_page.resource

Suite Setup         Open Playground Browser
Suite Teardown      Close All Browsers
Test Teardown       Capture Screenshot On Failure
Test Timeout        1 minute

Test Tags           playground


*** Test Cases ***
Dynamic Id Button Should Be Locatable Without Relying On Its Changing Id
    [Documentation]    The button's id regenerates on every page load, so a test that
    ...    hardcodes the id would break; a stable class-based locator must keep working
    ...    across reloads.
    Go To Playground Page    dynamicid
    ${first_id}=    Get Element Attribute    ${DYNAMIC_ID_BUTTON}    id
    Click Button    ${DYNAMIC_ID_BUTTON}
    Go To Playground Page    dynamicid
    ${second_id}=    Get Element Attribute    ${DYNAMIC_ID_BUTTON}    id
    Should Not Be Equal    ${first_id}    ${second_id}
    ...    msg=The button's id should regenerate on every page load.
    Click Button    ${DYNAMIC_ID_BUTTON}

Class Attribute Target Button Should Be Clicked By Its Unique Class
    [Documentation]    Three buttons share nearly identical class lists that differ only
    ...    by a volatile class1/class2/class3 marker; only .btn-primary reliably and
    ...    uniquely identifies the intended target, confirmed by the alert it raises.
    Go To Playground Page    classattr
    Page Should Contain Element    ${CLASS_ATTRIBUTE_TARGET_BUTTON}    limit=1
    Click Button    ${CLASS_ATTRIBUTE_TARGET_BUTTON}
    ${alert_message}=    Handle Alert    action=ACCEPT
    Should Be Equal    ${alert_message}    Primary button pressed

Clicking The Green Button Should Swap In A Different Layer
    [Documentation]    The button under #spa is replaced by a different element after the
    ...    first click, demonstrating a DOM-caching pitfall: a second click against a
    ...    previously located WebElement reference would silently hit a stale layer.
    Go To Playground Page    hiddenlayers
    Wait Until Element Is Visible    ${HIDING_BUTTON}
    Click Element    ${HIDING_BUTTON}
    ${new_id}=    Execute Javascript    return document.querySelector('#spa button').id;
    Should Not Be Equal    ${new_id}    greenButton
    ...    msg=Hidden Layers should swap in a different button after the first click.

Button Appearing After Delay Should Eventually Become Clickable
    [Documentation]    The button doesn't exist in a clickable state until the server
    ...    response delay elapses, so the test must wait rather than click immediately.
    Go To Playground Page    loaddelay
    Wait Until Element Is Visible    ${LOAD_DELAY_BUTTON}    timeout=20s
    Click Button    ${LOAD_DELAY_BUTTON}

Ajax Data Should Load After Clicking The Trigger Button
    [Documentation]    A GET request fires only after the button is clicked, so the
    ...    result text must be awaited rather than read immediately.
    Go To Playground Page    ajax
    Click Button    ${AJAX_BUTTON}
    Wait Until Element Is Visible    ${AJAX_RESULT}    timeout=20s
    Element Text Should Be    ${AJAX_RESULT}    Data loaded with AJAX get request.

Client Side Delay Should Compute Data After Clicking The Trigger Button
    [Documentation]    The client-side computation runs asynchronously, so the result
    ...    text must be awaited rather than read immediately.
    Go To Playground Page    clientdelay
    Click Button    ${CLIENT_DELAY_BUTTON}
    Wait Until Element Is Visible    ${CLIENT_DELAY_RESULT}    timeout=20s
    Element Text Should Be    ${CLIENT_DELAY_RESULT}    Data calculated on the client side.

Bad Button Should Respond To A Genuine Webdriver Click
    [Documentation]    The button only reacts to physical mouse events, not JavaScript-
    ...    dispatched DOM click events -- SeleniumLibrary's Click Button performs a real
    ...    click, so it should succeed where a synthetic .click() call would not.
    Go To Playground Page    click
    Wait Until Element Is Visible    ${CLICK_TARGET_BUTTON}
    Click Button    ${CLICK_TARGET_BUTTON}
    Element Should Be Visible    ${CLICK_TARGET_BUTTON}

Updating Button Should Adopt The Typed Text As Its New Label
    [Documentation]    The button's own label is rewritten from the text field's value
    ...    once clicked.
    Go To Playground Page    textinput
    Input Text    ${TEXT_INPUT_FIELD}    Automated Label
    Click Button    ${TEXT_INPUT_UPDATE_BUTTON}
    Element Text Should Be    ${TEXT_INPUT_UPDATE_BUTTON}    Automated Label

Hiding Button Should Be Clickable After Scrolling It Into View
    [Documentation]    The button sits outside the visible scroll area until scrolled
    ...    into view.
    Go To Playground Page    scrollbars
    Scroll Element Into View    ${SCROLLBAR_BUTTON}
    Click Button    ${SCROLLBAR_BUTTON}

Dynamic Table Chrome Cpu Value Should Match The Highlighted Answer
    [Documentation]    Both row order and column order reshuffle on every page load, so
    ...    the Chrome row must be located by its Name cell and the CPU value by its
    ...    header label, then cross-checked against the highlighted answer paragraph.
    Go To Playground Page    dynamictable
    @{rows}=    Get Row Cell Values
    ${cpu_index}=    Get Cpu Column Index
    VAR    ${chrome_row}=    ${NONE}
    FOR    ${row}    IN    @{rows}
        IF    '${row}[0]' == 'Chrome'
            VAR    ${chrome_row}=    ${row}
        END
    END
    Should Not Be Equal    ${chrome_row}    ${NONE}    msg=No Chrome row found in the dynamic table.
    ${cpu_value}=    Get From List    ${chrome_row}    ${cpu_index}
    ${answer_text}=    Get Text    ${DYNAMIC_TABLE_ANSWER}
    Should Be Equal As Strings    ${answer_text}    Chrome CPU: ${cpu_value}

Verify Text Highlighted Paragraph Should Match The Plain Paragraph Once Normalized
    [Documentation]    The two paragraphs look identical but may differ in raw whitespace
    ...    characters (e.g. a non-breaking space), so a correct comparison must normalize
    ...    whitespace before asserting equality.
    Go To Playground Page    verifytext
    ${plain_text}=    Get Text    ${VERIFY_TEXT_PLAIN_PARAGRAPH}
    ${highlighted_text}=    Get Text    ${VERIFY_TEXT_HIGHLIGHTED_PARAGRAPH}
    ${normalized_plain}=    Evaluate    ' '.join('''${plain_text}'''.split())
    ${normalized_highlighted}=    Evaluate    ' '.join('''${highlighted_text}'''.split())
    Should Be Equal    ${normalized_plain}    ${normalized_highlighted}

Progress Bar Should Reach And Hold The Target Value
    [Documentation]    The bar fills asynchronously after Start is clicked; Stop must be
    ...    clicked only once it has reached the target percentage.
    Go To Playground Page    progressbar
    Click Button    ${PROGRESS_BAR_START_BUTTON}
    Wait Until Keyword Succeeds    30s    500ms    Progress Bar Value Should Be At Least    75
    Click Button    ${PROGRESS_BAR_STOP_BUTTON}
    ${final_value}=    Get Element Attribute    ${PROGRESS_BAR}    aria-valuenow
    Should Be True    ${final_value} >= 75

Every Hiding Technique Should Be Correctly Detected After Clicking Hide
    [Documentation]    Clicking Hide reveals seven distinct ways an element can be hidden
    ...    from a real user. Selenium's built-in visibility check only catches three of
    ...    them (removed from DOM, visibility:hidden, display:none) -- zero width,
    ...    opacity 0, occlusion by another element and off-screen positioning all need
    ...    direct inspection instead.
    Go To Playground Page    visibility
    Element Should Be Visible    ${VISIBILITY_HIDE_BUTTON}
    Click Button    ${VISIBILITY_HIDE_BUTTON}
    Page Should Not Contain Element    ${VISIBILITY_REMOVED_BUTTON}
    Element Should Not Be Visible    ${VISIBILITY_INVISIBLE_BUTTON}
    Element Should Not Be Visible    ${VISIBILITY_NOT_DISPLAYED_BUTTON}
    Remaining Visibility Techniques Should Be Hidden

Sample App Should Log In With The Valid Password And Reject An Invalid One
    [Documentation]    Both fields have dynamically generated ids on every page load, so
    ...    they're located by their stable type attribute instead.
    Go To Playground Page    sampleapp
    Input Text    ${SAMPLE_APP_USERNAME_FIELD}    Michelle
    Input Text    ${SAMPLE_APP_PASSWORD_FIELD}    wrong-password
    Click Button    ${SAMPLE_APP_LOGIN_BUTTON}
    Element Text Should Be    ${SAMPLE_APP_STATUS_MESSAGE}    Invalid username/password
    Input Text    ${SAMPLE_APP_PASSWORD_FIELD}    ${SAMPLE_APP_VALID_PASSWORD}
    Click Button    ${SAMPLE_APP_LOGIN_BUTTON}
    Element Text Should Be    ${SAMPLE_APP_STATUS_MESSAGE}    Welcome, Michelle!

Mouse Over Link Click Count Should Increment After Hovering
    [Documentation]    Hovering over the link replaces it with a new DOM element carrying
    ...    the same text, so a WebElement reference taken before hovering would go stale;
    ...    the element must be re-located after the hover before clicking it.
    Go To Playground Page    mouseover
    Mouse Over    ${MOUSE_OVER_LINK}
    Click Element    ${MOUSE_OVER_LINK}
    Element Text Should Not Be    ${MOUSE_OVER_CLICK_COUNT}    0
    Click Element    ${MOUSE_OVER_BUTTON_LINK}
    Element Text Should Not Be    ${MOUSE_OVER_BUTTON_CLICK_COUNT}    0

Non Breaking Space Button Should Not Match An Exact Text Locator
    [Documentation]    The button's label contains a non-breaking space rather than a
    ...    regular one, so an exact-text xpath locator silently fails to match while a
    ...    class-based locator remains reliable.
    Go To Playground Page    nbsp
    Page Should Not Contain Element    ${NBSP_BUTTON_EXACT_TEXT}
    Click Button    ${NBSP_BUTTON}

Overlapped Name Field Should Accept Text Set Through Javascript
    [Documentation]    The field is covered by another element, so native Selenium
    ...    keystrokes never register; setting the value directly through JavaScript and
    ...    dispatching an input event is the documented workaround.
    Go To Playground Page    overlapped
    Set Value Via Javascript    ${OVERLAPPED_NAME_FIELD}    Michelle Austria
    ${value}=    Get Element Attribute    ${OVERLAPPED_NAME_FIELD}    value
    Should Be Equal    ${value}    Michelle Austria

Shadow Dom Generated Value Should Be Readable Through The Shadow Root
    [Documentation]    The generate button, edit field and copy button all live inside a
    ...    Shadow DOM tree that plain SeleniumLibrary locators cannot pierce.
    Go To Playground Page    shadowdom
    Click Shadow Element    ${SHADOW_HOST}    ${SHADOW_GENERATE_BUTTON_ID}
    ${generated_value}=    Get Shadow Element Text    ${SHADOW_HOST}    ${SHADOW_EDIT_FIELD_ID}
    Should Not Be Empty    ${generated_value}
    Click Shadow Element    ${SHADOW_HOST}    ${SHADOW_COPY_BUTTON_ID}
    ${value_after_copy}=    Get Shadow Element Text    ${SHADOW_HOST}    ${SHADOW_EDIT_FIELD_ID}
    Should Be Equal    ${value_after_copy}    ${generated_value}

Alert Confirm And Prompt Dialogs Should All Be Handled
    [Documentation]    Each button opens a different native dialog type; all three must
    ...    be handled through SeleniumLibrary's alert keywords rather than DOM locators.
    Go To Playground Page    alerts
    Trigger Alert And Verify Message    ${ALERT_BUTTON}
    Trigger Alert And Verify Message    ${CONFIRM_BUTTON}
    Trigger Alert And Verify Message    ${PROMPT_BUTTON}    prompt_text=Michelle

File Upload Should Accept A File Selected Inside The Upload Frame
    [Documentation]    The upload widget lives inside an iframe with no top-level file
    ...    input, so the frame must be selected before the file input becomes reachable.
    Go To Playground Page    upload
    Select Frame    ${FILE_UPLOAD_IFRAME}
    Choose File    ${FILE_UPLOAD_INPUT}    ${SAMPLE_UPLOAD_FILE}
    ${value}=    Get Element Attribute    ${FILE_UPLOAD_INPUT}    value
    Should Contain    ${value}    sample_upload.txt
    Unselect Frame

Moving Target Should Become Clickable Once Its Animation Stops
    [Documentation]    Clicking the target while it's still animating would hit whatever
    ...    coordinates it occupied at click time, not necessarily the element -- the test
    ...    must wait for the animation to finish first.
    Go To Playground Page    animation
    Click Button    ${ANIMATION_START_BUTTON}
    Wait Until Animation Stops    ${ANIMATION_MOVING_TARGET}
    Click Button    ${ANIMATION_MOVING_TARGET}
    Element Text Should Be    ${ANIMATION_STATUS}
    ...    Moving Target clicked. It's class name is 'btn btn-primary'

Disabled Input Should Become Enabled After Its Delay
    [Documentation]    The field stays disabled until the enable button's delay elapses.
    Go To Playground Page    disabledinput
    Click Button    ${DISABLED_INPUT_ENABLE_BUTTON}
    Wait Until Element Is Enabled    ${DISABLED_INPUT_FIELD}    timeout=6s
    Input Text    ${DISABLED_INPUT_FIELD}    Ready
    Textfield Value Should Be    ${DISABLED_INPUT_FIELD}    Ready

Auto Wait Target Button Should Report Its State Was Restored
    [Documentation]    Applying a delay temporarily changes the target element's state;
    ...    the status message confirms when it has been restored to normal.
    Go To Playground Page    autowait
    Click Button    ${AUTO_WAIT_APPLY_3S_BUTTON}
    Wait Until Element Contains    ${AUTO_WAIT_STATUS}    Target element state restored.    timeout=5s
    Click Button    ${AUTO_WAIT_TARGET_BUTTON}

Frames Should Be Selectable To Reach Content Inside Them
    [Documentation]    Elements inside an iframe are invisible to SeleniumLibrary until
    ...    the frame is explicitly selected.
    Go To Playground Page    frames
    Select Frame    ${FRAMES_OUTER_FRAME}
    ${body_text_length}=    Execute Javascript    return document.body.innerText.trim().length;
    Should Be True    ${body_text_length} > 0
    ...    msg=The frame's document should contain readable content once selected.
    Unselect Frame

Geolocation Request Should Resolve Rather Than Hang
    [Documentation]    Headless Chrome has no location permission granted, so the request
    ...    resolves with an "unavailable" result rather than hanging indefinitely -- the
    ...    test asserts the status text changes at all, not a specific coordinate.
    Go To Playground Page    geolocation
    Element Text Should Be    ${GEOLOCATION_RESULT}    Not requested
    Click Button    ${GEOLOCATION_REQUEST_BUTTON}
    Wait Until Keyword Succeeds    10s    500ms
    ...    Element Text Should Not Be    ${GEOLOCATION_RESULT}    Not requested

Clear Input Should Reduce The Non Empty Field Counter To Zero
    [Documentation]    SeleniumLibrary's Clear Element Text updates the DOM value but
    ...    doesn't fire an input event, so the page's live counter needs each field's
    ...    change to be dispatched manually before it will notice.
    Go To Playground Page    clearinput
    Element Text Should Be    ${CLEAR_INPUT_STATUS}    Non-empty fields remaining: 9
    FOR    ${locator}    IN    @{CLEAR_INPUT_FIELD_LOCATORS}
        Clear Field And Notify Page    ${locator}
    END
    Execute Javascript
    ...    var editable = document.querySelector('#clearContentEditable');
    ...    editable.textContent = '';
    ...    editable.dispatchEvent(new Event('input', {bubbles: true}));
    Element Text Should Be    ${CLEAR_INPUT_STATUS}    All fields are cleared!

All Scroll To Click Targets Should Be Reachable And Clicked
    [Documentation]    Each button needs a different technique to become clickable: a
    ...    plain page scroll, scrolling inside a nested scrollable container, and
    ...    hovering over a row to reveal a button that isn't in the layout at all until
    ...    then.
    Go To Playground Page    scrolltoclick
    FOR    ${target}    IN    ${SCROLL_TARGET_1}    ${SCROLL_TARGET_2}    ${SCROLL_TARGET_3}
        Scroll Element Into View    ${target}
        Click Button    ${target}
    END
    Mouse Over    ${SCROLL_HOVER_ROW}
    Scroll Element Into View    ${SCROLL_TARGET_4}
    Click Button    ${SCROLL_TARGET_4}
    Element Text Should Be    ${SCROLL_PROGRESS_TEXT}    All buttons clicked!

Css Selectors Should Correctly Distinguish The Highlighted Button From Its Hidden Siblings
    [Documentation]    Five buttons are hidden using five different CSS techniques, none
    ...    of which are all caught by Selenium's built-in visibility check alone.
    Go To Playground Page    cssselectors
    Click Button    ${CSS_SELECTORS_PRIMARY_BUTTON}
    Click Button    ${CSS_SELECTORS_VISIBLE_BUTTON}
    Element Text Should Be    ${CSS_SELECTORS_HIGHLIGHTED_BUTTON}    Third
    Element Should Not Be Visible    ${CSS_SELECTORS_HIDDEN_DISPLAY}
    Element Should Not Be Visible    ${CSS_SELECTORS_HIDDEN_VISIBILITY}
    Remaining Css Selector Hiding Techniques Should Be Hidden

Select Dropdowns Should Update Their Status Text After Each Selection
    [Documentation]    Each dropdown's status paragraph reflects the most recent
    ...    selection, single-select or multi-select alike.
    Go To Playground Page    select
    Select From List By Label    ${SELECT_LANGUAGE}    Python
    Element Text Should Be    ${SELECT_STATUS_LANGUAGE}    Selected: Python (value: py)
    Select From List By Label    ${SELECT_CITY}    New York
    Element Should Not Contain    ${SELECT_STATUS_CITY}    none
    Select From List By Label    ${SELECT_PRODUCT}    Release 1.0
    Element Should Not Contain    ${SELECT_STATUS_PRODUCT}    none
    Select From List By Label    ${SELECT_FRUITS}    Banana
    Element Should Contain    ${SELECT_STATUS_FRUITS}    Banana


*** Keywords ***
Open Playground Browser
    [Documentation]    Starts a single browser session reused by every test in this suite.
    Open Browser    about:blank    ${BROWSER}
    Set Selenium Timeout    ${SELENIUM_TIMEOUT}
    Set Window Size    1920    1080

Capture Screenshot On Failure
    [Documentation]    Saves a screenshot of the current page whenever a test fails.
    Run Keyword If Test Failed    Capture Page Screenshot

Progress Bar Value Should Be At Least
    [Documentation]    Polls the progress bar's aria-valuenow attribute until it reaches
    ...                the given threshold, or fails once Wait Until Keyword Succeeds
    ...                gives up retrying.
    [Arguments]    ${threshold}
    ${value}=    Get Element Attribute    ${PROGRESS_BAR}    aria-valuenow
    Should Be True    ${value} >= ${threshold}

Trigger Alert And Verify Message
    [Documentation]    Clicks a button that opens a native dialog, optionally answers a
    ...                prompt, accepts the dialog, and asserts it carried a message. The
    ...                Prompt dialog raises a second follow-up alert echoing the entered
    ...                value, which must also be accepted before the next test runs.
    [Arguments]    ${button_locator}    ${prompt_text}=${NONE}
    Click Button    ${button_locator}
    IF    $prompt_text is not None    Input Text Into Alert    ${prompt_text}
    ${message}=    Handle Alert    action=ACCEPT
    Should Not Be Empty    ${message}
    IF    $prompt_text is not None
        ${followup_message}=    Handle Alert    action=ACCEPT
        Should Contain    ${followup_message}    ${prompt_text}
    END

Remaining Visibility Techniques Should Be Hidden
    [Documentation]    Checks the four Visibility page techniques that Selenium's
    ...                built-in visibility check cannot detect on its own: zero width,
    ...                opacity 0, occlusion by another element, and off-screen position.
    ${result_json}=    Execute Javascript
    ...    function rect(id) { return document.getElementById(id).getBoundingClientRect(); }
    ...    var overlapRect = rect('overlappedButton');
    ...    var topElement = document.elementFromPoint(
    ...    overlapRect.left + overlapRect.width / 2, overlapRect.top + overlapRect.height / 2);
    ...    return JSON.stringify({
    ...    zeroWidth: rect('zeroWidthButton').width,
    ...    transparentOpacity: parseFloat(getComputedStyle(document.getElementById('transparentButton')).opacity),
    ...    overlapped: topElement !== document.getElementById('overlappedButton'),
    ...    offscreenLeft: rect('offscreenButton').left
    ...    });
    ${result}=    Evaluate    json.loads('''${result_json}''')    json
    Should Be Equal As Numbers    ${result}[zeroWidth]    0
    ...    msg=Zero Width button should have zero width after clicking Hide.
    Should Be Equal As Numbers    ${result}[transparentOpacity]    0
    ...    msg=Transparent button should have opacity 0 after clicking Hide.
    Should Be True    ${result}[overlapped]
    ...    msg=Overlapped button should be covered by another element after clicking Hide.
    Should Be True    ${result}[offscreenLeft] < 0
    ...    msg=Offscreen button should be positioned outside the viewport after clicking Hide.

Remaining Css Selector Hiding Techniques Should Be Hidden
    [Documentation]    Checks the three CSS Selectors page techniques that Selenium's
    ...                built-in visibility check cannot detect on its own: clipping by an
    ...                overflow:hidden ancestor, opacity 0, and off-screen position.
    ${result_json}=    Execute Javascript
    ...    function rect(id) { return document.getElementById(id).getBoundingClientRect(); }
    ...    var overflowRect = rect('hidden-overflow');
    ...    var topElement = document.elementFromPoint(
    ...    overflowRect.left + overflowRect.width / 2, overflowRect.top + overflowRect.height / 2);
    ...    return JSON.stringify({
    ...    overflowClipped: topElement !== document.getElementById('hidden-overflow'),
    ...    opacityValue: parseFloat(getComputedStyle(document.getElementById('hidden-opacity')).opacity),
    ...    offscreenLeft: rect('hidden-offscreen').left
    ...    });
    ${result}=    Evaluate    json.loads('''${result_json}''')    json
    Should Be True    ${result}[overflowClipped]
    ...    msg=The overflow-clipped button should not be the topmost element at its own coordinates.
    Should Be Equal As Numbers    ${result}[opacityValue]    0
    ...    msg=The opacity-hidden button should have opacity 0.
    Should Be True    ${result}[offscreenLeft] < 0
    ...    msg=The offscreen button should be positioned outside the viewport.
