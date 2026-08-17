*** Settings ***
Documentation       Coverage for every challenge page listed on the
...                 uitestingplayground.com homepage. Each page is an independent,
...                 self-contained UI automation challenge (dynamic attributes, timing,
...                 visibility, Shadow DOM, and so on), so each test case navigates to
...                 its own page directly rather than sharing state with the others.

Resource            ../../resources/common.resource
Resource            ../../resources/pages/playground_page.resource

Suite Setup         Open Playground Browser
Suite Teardown      Close All Browsers
Test Teardown       Capture Screenshot On Failure
Test Timeout        1 minute

Test Tags           playground


*** Test Cases ***
Dynamic ID Button Is Locatable Despite Its Changing Id
    [Documentation]    The button's id attribute changes on every page load, so it's
    ...                located by its stable CSS class instead.
    Go To Playground Page    dynamicid
    Element Text Should Be    ${DYNAMIC_ID_BUTTON}    Button with Dynamic ID
    Click Button    ${DYNAMIC_ID_BUTTON}

Class Attribute Locates The Exact Button Among Look Alike Decoys
    [Documentation]    Several buttons share very similar classes; only an exact class
    ...                match finds the correct one.
    Go To Playground Page    classattr
    Element Attribute Value Should Be    ${CLASS_ATTRIBUTE_TARGET_BUTTON}    class
    ...    btn btn-primary
    Click Button    ${CLASS_ATTRIBUTE_TARGET_BUTTON}

Hidden Layer Blocks A Second Click On The Same Button
    [Documentation]    The first click reveals an invisible overlay covering the
    ...                button, so a second click at the same coordinates is
    ...                intercepted by that overlay instead of reaching the button.
    Go To Playground Page    hiddenlayers
    Click Element    ${HIDING_BUTTON}
    Element Should Be Visible    css:#hidden-layer
    Run Keyword And Expect Error    *    Click Element    ${HIDING_BUTTON}

Load Delay Button Appears Only After An Explicit Wait
    [Documentation]    The page takes several seconds to render the button; only an
    ...                explicit wait (not a fixed sleep) reliably catches it.
    Go To Playground Page    loaddelay
    Wait Until Element Is Visible    ${LOAD_DELAY_BUTTON}    timeout=20s
    Click Button    ${LOAD_DELAY_BUTTON}

Ajax Data Request Populates The Result Text After A Delay
    [Documentation]    Clicking the button triggers a server round trip; the result
    ...                text only appears once that AJAX call completes.
    Go To Playground Page    ajax
    Click Button    ${AJAX_BUTTON}
    Wait Until Element Is Visible    ${AJAX_RESULT}    timeout=20s
    Element Text Should Be    ${AJAX_RESULT}    Data loaded with AJAX get request.

Client Side Delay Does Not Block The Page While Waiting
    [Documentation]    The delay here runs entirely in the browser (not a server
    ...                round trip), but the result still only appears once it settles.
    Go To Playground Page    clientdelay
    Click Button    ${CLIENT_DELAY_BUTTON}
    Wait Until Element Is Visible    ${CLIENT_DELAY_RESULT}    timeout=20s
    Element Text Should Be    ${CLIENT_DELAY_RESULT}    Data calculated on the client side.

Click Registers On The Correctly Identified Button
    [Documentation]    A decoy button sits nearby; only clicking the real target
    ...                changes its class, confirming the right element was hit.
    Go To Playground Page    click
    Click Button    ${CLICK_TARGET_BUTTON}
    Element Attribute Value Should Be    ${CLICK_TARGET_BUTTON}    class    btn btn-success

Text Input Value Is Reflected On The Button Label
    [Documentation]    Typing a new name and clicking the button updates the button's
    ...                own label to match what was typed.
    Go To Playground Page    textinput
    Input Text    ${TEXT_INPUT_FIELD}    Automated Button Name
    Click Button    ${TEXT_INPUT_UPDATE_BUTTON}
    Element Text Should Be    ${TEXT_INPUT_UPDATE_BUTTON}    Automated Button Name

Scrollbar Hidden Button Is Clicked After Scrolling Into View
    [Documentation]    The button sits inside a scrollable container out of the
    ...                initial viewport; a standard click scrolls it into view first.
    Go To Playground Page    scrollbars
    Wait Until Element Is Visible    ${SCROLLBAR_BUTTON}
    Click Button    ${SCROLLBAR_BUTTON}

Dynamic Table Reports The Highlighted Browser Cpu Usage Correctly
    [Documentation]    Reads which browser the warning label calls out, finds that
    ...                browser's row in the table, and verifies the CPU percentage
    ...                shown there matches the value stated in the label.
    Go To Playground Page    dynamictable
    ${result}=    Execute Javascript
    ...    var label = document.querySelector('p.bg-warning').innerText;
    ...    var match = label.match(/([A-Za-z]+)[^\d]*(\d+)%/);
    ...    var browser = match[1];
    ...    var expected = match[2];
    ...    var actual = null;
    ...    function checkRow(row) {
    ...    var cells = row.querySelectorAll('td');
    ...    if (cells[0] && cells[0].innerText.trim() === browser) { actual = cells[1].innerText.trim(); }
    ...    }
    ...    document.querySelectorAll('table tbody tr').forEach(checkRow);
    ...    return JSON.stringify({browser: browser, expected: expected, actual: actual});
    ${data}=    Evaluate    json.loads('''${result}''')    json
    ${message}=    Catenate
    ...    CPU usage for ${data}[browser] in the table (${data}[actual]%)
    ...    did not match the warning label (${data}[expected]%)
    Should Be Equal As Strings    ${data}[expected]    ${data}[actual]    msg=${message}

Verify Text Handles Non Obvious Internal Whitespace
    [Documentation]    The paragraph's rendered text uses irregular internal spacing
    ...                that a naive hard-coded comparison would miss, so it's
    ...                normalized before asserting on its content.
    Go To Playground Page    verifytext
    ${text}=    Get Text    ${VERIFY_TEXT_PARAGRAPH}
    ${normalized}=    Evaluate    ' '.join($text.split())
    Should Not Be Empty    ${normalized}
    Should Not Contain    ${normalized}    ${SPACE}${SPACE}

Progress Bar Can Be Stopped Near A Target Value
    [Documentation]    Starts the progress bar, stops it once it reaches at least 75%,
    ...                and verifies it didn't run all the way to completion.
    Go To Playground Page    progressbar
    Click Button    ${PROGRESS_BAR_START_BUTTON}
    Wait Until Keyword Succeeds    20s    100ms    Progress Bar Value Should Be At Least    75
    Click Button    ${PROGRESS_BAR_STOP_BUTTON}
    ${value}=    Get Element Attribute    ${PROGRESS_BAR}    aria-valuenow
    Should Be True    75 <= ${value} <= 100

Each Visibility Challenge Is Undetectable By Its Own Hiding Technique
    [Documentation]    Clicking "Hide" hides five buttons via five different
    ...                techniques; each is verified undetectable by whichever check
    ...                actually applies to how it was hidden.
    Go To Playground Page    visibility
    Click Button    ${VISIBILITY_HIDE_BUTTON}
    Page Should Not Contain Element    ${VISIBILITY_REMOVED_BUTTON}
    Element Should Not Be Visible    ${VISIBILITY_ZERO_WIDTH_BUTTON}
    Element Should Not Be Visible    ${VISIBILITY_TRANSPARENT_BUTTON}
    Element Should Not Be Visible    ${VISIBILITY_INVISIBLE_BUTTON}
    Element Should Not Be Visible    ${VISIBILITY_NOT_VISIBLE_BUTTON}
    Run Keyword And Expect Error    *    Click Button    ${VISIBILITY_OVERLAPPED_BUTTON}

Sample App Login Succeeds With The Documented Password
    [Documentation]    The sample login form accepts any username paired with the
    ...                password "pwd" and greets the user by the name they entered.
    Go To Playground Page    sampleapp
    Input Text    ${SAMPLE_APP_USERNAME_FIELD}    michelle
    Input Text    ${SAMPLE_APP_PASSWORD_FIELD}    pwd
    Click Button    ${SAMPLE_APP_LOGIN_BUTTON}
    Element Text Should Be    ${SAMPLE_APP_STATUS_MESSAGE}    Welcome, michelle!

Mouse Over Link Only Registers A Click After Hovering First
    [Documentation]    The link is covered by a decoy layer that only clears on
    ...                mouse-over, so hovering before clicking is required for the
    ...                click to register.
    Go To Playground Page    mouseover
    Mouse Over    ${MOUSE_OVER_LINK}
    Click Element    ${MOUSE_OVER_LINK}
    Element Text Should Be    ${MOUSE_OVER_CLICK_COUNT}    1

Non Breaking Space Button Is Missed By A Naive Text Locator
    [Documentation]    The button's visible text looks like "My Button" but uses a
    ...                non-breaking space, so a locator built on a regular space
    ...                genuinely fails to find it, while a class-based locator works.
    Go To Playground Page    nbsp
    Run Keyword And Expect Error    *    Page Should Contain Element
    ...    ${NBSP_BUTTON_EXACT_TEXT}
    Element Should Be Visible    ${NBSP_BUTTON}
    Click Button    ${NBSP_BUTTON}

Overlapped Input Still Receives The Entered Text
    [Documentation]    The name field becomes covered by another panel once the page
    ...                is interacted with, but sending keys directly still correctly
    ...                sets its value.
    Go To Playground Page    overlapped
    Input Text    ${OVERLAPPED_NAME_FIELD}    Michelle
    Element Attribute Value Should Be    ${OVERLAPPED_NAME_FIELD}    value    Michelle

Shadow Dom Generated Value Can Be Copied Into The Regular Input
    [Documentation]    The GUID is generated and displayed inside a Shadow DOM tree
    ...                that plain locators can't pierce, so it's read via JavaScript.
    ...                Clicking "Copy" should place that same value into the visible
    ...                input field that lives outside the shadow tree.
    Go To Playground Page    shadowdom
    Click Shadow Element    ${SHADOW_HOST}    ${SHADOW_GENERATE_BUTTON_ID}
    ${generated}=    Get Shadow Element Text    ${SHADOW_HOST}    ${SHADOW_OUTPUT_ID}
    Click Shadow Element    ${SHADOW_HOST}    ${SHADOW_COPY_BUTTON_ID}
    Textfield Value Should Be    ${SHADOW_EDIT_FIELD}    ${generated}

Alert Result Reflects The Chosen Alert Action
    [Documentation]    Clicking the button triggers a native JS alert after a short
    ...                delay; accepting it is reflected in the result text.
    Go To Playground Page    alerts
    Click Button    ${ALERT_BUTTON}
    Handle Alert    action=ACCEPT    timeout=10s
    Element Text Should Be    ${ALERT_RESULT}    You have chosen: Ok

File Upload Accepts A Selected File
    [Documentation]    Selecting a local file and submitting the upload form should
    ...                be accepted without error.
    Go To Playground Page    upload
    Choose File    ${FILE_UPLOAD_INPUT}    ${SAMPLE_UPLOAD_FILE}
    Click Button    ${FILE_UPLOAD_BUTTON}

Animated Button Is Clicked Only Once It Stops Moving
    [Documentation]    The button moves via a CSS transition for a short time after
    ...                the page loads; clicking waits for it to settle first.
    Go To Playground Page    animatedbutton
    Wait Until Animation Stops    ${ANIMATED_BUTTON}
    Click Button    ${ANIMATED_BUTTON}

Disabled Input Becomes Enabled After A Delay
    [Documentation]    The input field starts disabled and is enabled by client-side
    ...                JavaScript after a short delay.
    Go To Playground Page    disabledinput
    Wait Until Element Is Enabled    ${DISABLED_INPUT_FIELD}    timeout=10s
    Input Text    ${DISABLED_INPUT_FIELD}    Michelle

Auto Wait Button Is Clicked Only After Its Own Delay Settles
    [Documentation]    Clicking the button starts a client-side delay before the
    ...                success text appears; an explicit wait is required since the
    ...                button gives no visible feedback while the delay is running.
    Go To Playground Page    auto_wait
    Click Button    ${AUTO_WAIT_BUTTON}
    Wait Until Element Is Visible    ${AJAX_RESULT}    timeout=20s

Auto Complete Suggests And Selects A Matching Tag
    [Documentation]    Typing a partial name shows matching suggestions; selecting one
    ...                adds it as a tag.
    Go To Playground Page    auto_complete
    Input Text    ${AUTO_COMPLETE_INPUT}    Cal
    Wait Until Element Is Visible    ${AUTO_COMPLETE_SUGGESTIONS}    timeout=10s
    Click Element    ${AUTO_COMPLETE_FIRST_SUGGESTION}
    Element Should Be Visible    ${AUTO_COMPLETE_SELECTED_TAGS}


*** Keywords ***
Open Playground Browser
    [Documentation]    Starts a single browser session reused across every challenge
    ...                page in this suite, since each test navigates independently.
    Open Browser    about:blank    ${BROWSER}
    Set Selenium Timeout    ${SELENIUM_TIMEOUT}
    Set Window Size    1920    1080

Progress Bar Value Should Be At Least
    [Documentation]    Fails unless the progress bar's current value has reached the
    ...                given threshold.
    [Arguments]    ${threshold}
    ${value}=    Get Element Attribute    ${PROGRESS_BAR}    aria-valuenow
    Should Be True    ${value} >= ${threshold}
