*** Settings ***
Documentation       Locators and keywords for uitestingplayground.com (Inflectra's "UI Test
...                 Automation Playground"), a collection of small, independent pages that
...                 each demonstrate one UI automation challenge (dynamic attributes,
...                 timing, visibility, Shadow DOM, and so on). Unlike the car insurance
...                 wizard, these pages aren't part of a shared flow and each locator/keyword
...                 is used by exactly one test, so they're kept in a single file rather
...                 than one per page.

Library             SeleniumLibrary


*** Variables ***
${PLAYGROUND_BASE_URL}                  http://www.uitestingplayground.com
${SAMPLE_UPLOAD_FILE}
...                                     ${{os.path.normpath(r'${CURDIR}' + '/../data/sample_upload.txt')}}

# Dynamic ID
${DYNAMIC_ID_BUTTON}                    css:.btn.btn-primary

# Class Attribute
${CLASS_ATTRIBUTE_TARGET_BUTTON}        css:.btn-primary

# Hidden Layers
${HIDING_BUTTON}                        css:#greenButton

# Load Delay
${LOAD_DELAY_BUTTON}                    css:.btn.btn-primary

# AJAX Data
${AJAX_BUTTON}                          css:#ajaxButton
${AJAX_RESULT}                          css:#content

# Client Side Delay
${CLIENT_DELAY_BUTTON}                  css:#ajaxButton
${CLIENT_DELAY_RESULT}                  css:#content

# Click
${CLICK_TARGET_BUTTON}                  css:#badButton

# Text Input
${TEXT_INPUT_FIELD}                     css:#newButtonName
${TEXT_INPUT_UPDATE_BUTTON}             css:#updatingButton

# Scrollbars
${SCROLLBAR_BUTTON}                     css:#hidingButton

# Dynamic Table
${DYNAMIC_TABLE_ANSWER}                 css:.bg-warning

# Verify Text
${VERIFY_TEXT_PLAIN_PARAGRAPH}          xpath://p[contains(.,'Hello') and not(contains(@class,'bg-warning'))]
${VERIFY_TEXT_HIGHLIGHTED_PARAGRAPH}    css:.bg-warning

# Progress Bar
${PROGRESS_BAR_START_BUTTON}            css:#startButton
${PROGRESS_BAR_STOP_BUTTON}             css:#stopButton
${PROGRESS_BAR}                         css:#progressBar

# Visibility
${VISIBILITY_HIDE_BUTTON}               css:#hideButton
${VISIBILITY_REMOVED_BUTTON}            css:#removedButton
${VISIBILITY_ZERO_WIDTH_BUTTON}         css:#zeroWidthButton
${VISIBILITY_OVERLAPPED_BUTTON}         css:#overlappedButton
${VISIBILITY_TRANSPARENT_BUTTON}        css:#transparentButton
${VISIBILITY_INVISIBLE_BUTTON}          css:#invisibleButton
${VISIBILITY_NOT_DISPLAYED_BUTTON}      css:#notdisplayedButton
${VISIBILITY_OFFSCREEN_BUTTON}          css:#offscreenButton

# Sample App
${SAMPLE_APP_USERNAME_FIELD}            css:input[type="text"]
${SAMPLE_APP_PASSWORD_FIELD}            css:input[type="password"]
${SAMPLE_APP_LOGIN_BUTTON}              css:#login
${SAMPLE_APP_STATUS_MESSAGE}            css:#loginstatus
${SAMPLE_APP_VALID_PASSWORD}            pwd

# Mouse Over
${MOUSE_OVER_LINK}                      xpath://a[@class="text-primary" and text()="Click me"]
${MOUSE_OVER_CLICK_COUNT}               css:#clickCount
${MOUSE_OVER_BUTTON_LINK}               xpath://a[@class="text-primary" and text()="Link Button"]
${MOUSE_OVER_BUTTON_CLICK_COUNT}        css:#clickButtonCount

# Non-Breaking Space
${NBSP_BUTTON}                          css:.btn-primary
${NBSP_BUTTON_EXACT_TEXT}               xpath://button[text()="My Button"]

# Overlapped Element
${OVERLAPPED_NAME_FIELD}                css:#name

# Shadow DOM
${SHADOW_HOST}                          guid-generator
${SHADOW_GENERATE_BUTTON_ID}            buttonGenerate
${SHADOW_COPY_BUTTON_ID}                buttonCopy
${SHADOW_EDIT_FIELD_ID}                 editField

# Alerts
${ALERT_BUTTON}                         css:#alertButton
${CONFIRM_BUTTON}                       css:#confirmButton
${PROMPT_BUTTON}                        css:#promptButton

# File Upload
${FILE_UPLOAD_IFRAME}                   css:iframe
${FILE_UPLOAD_INPUT}                    css:#browse

# Animated Button
${ANIMATION_START_BUTTON}               css:#animationButton
${ANIMATION_MOVING_TARGET}              css:#movingTarget
${ANIMATION_STATUS}                     css:#opstatus

# Disabled Input
${DISABLED_INPUT_FIELD}                 css:#inputField
${DISABLED_INPUT_ENABLE_BUTTON}         css:#enableButton

# Auto Wait
${AUTO_WAIT_APPLY_3S_BUTTON}            css:#applyButton3
${AUTO_WAIT_TARGET_BUTTON}              css:#target
${AUTO_WAIT_STATUS}                     css:#opstatus

# Frames
${FRAMES_OUTER_FRAME}                   css:iframe

# Geolocation
${GEOLOCATION_REQUEST_BUTTON}           css:#requestLocation
${GEOLOCATION_RESULT}                   css:#location

# Clear Input
@{CLEAR_INPUT_FIELD_LOCATORS}
...                                     css:#clearInput
...                                     css:#clearTextarea
...                                     css:#clearPassword
...                                     css:#clearEmail
...                                     css:#clearNumber
...                                     css:#clearSearch
...                                     css:#clearUrl
...                                     css:#clearTel
${CLEAR_INPUT_EDITABLE_DIV}             css:#clearContentEditable
${CLEAR_INPUT_STATUS}                   css:#opstatus

# Scroll To Click
${SCROLL_TARGET_1}                      css:#scrollTarget1
${SCROLL_TARGET_2}                      css:#scrollTarget2
${SCROLL_TARGET_3}                      css:#scrollTarget3
${SCROLL_TARGET_4}                      css:#scrollTarget4
${SCROLL_HOVER_ROW}                     css:#targetRow4
${SCROLL_PROGRESS_TEXT}                 css:#progressText

# CSS Selectors
${CSS_SELECTORS_PRIMARY_BUTTON}         css:#primary-btn
${CSS_SELECTORS_VISIBLE_BUTTON}         css:#visible-btn
${CSS_SELECTORS_HIGHLIGHTED_BUTTON}     css:.css-btn.highlight
${CSS_SELECTORS_HIDDEN_DISPLAY}         css:#hidden-display
${CSS_SELECTORS_HIDDEN_VISIBILITY}      css:#hidden-visibility
${CSS_SELECTORS_HIDDEN_OVERFLOW}        css:#hidden-overflow
${CSS_SELECTORS_HIDDEN_OPACITY}         css:#hidden-opacity
${CSS_SELECTORS_HIDDEN_OFFSCREEN}       css:#hidden-offscreen

# Select
${SELECT_LANGUAGE}                      css:#selectLanguage
${SELECT_CITY}                          css:#selectCity
${SELECT_PRODUCT}                       css:#selectProduct
${SELECT_FRUITS}                        css:#selectFruits
${SELECT_STATUS_LANGUAGE}               css:#statusLanguage
${SELECT_STATUS_CITY}                   css:#statusCity
${SELECT_STATUS_PRODUCT}                css:#statusProduct
${SELECT_STATUS_FRUITS}                 css:#statusFruits


*** Keywords ***
Go To Playground Page
    [Documentation]    Navigates to the given uitestingplayground.com challenge page.
    [Arguments]    ${path}
    Go To    ${PLAYGROUND_BASE_URL}/${path}

Get Shadow Element Text
    [Documentation]    Reads the text content of an element nested inside a Shadow DOM
    ...                tree, which plain SeleniumLibrary locators cannot pierce. Works
    ...                for both form controls (via .value) and plain text elements.
    [Arguments]    ${host_tag}    ${element_id}
    ${text}=    Execute Javascript
    ...    var el = document.querySelector('${host_tag}').shadowRoot.getElementById('${element_id}');
    ...    return ('value' in el) ? el.value : el.textContent.trim();
    RETURN    ${text}

Click Shadow Element
    [Documentation]    Clicks an element nested inside a Shadow DOM tree by dispatching
    ...                a native click through JavaScript.
    [Arguments]    ${host_tag}    ${element_id}
    Execute Javascript
    ...    document.querySelector('${host_tag}').shadowRoot.getElementById('${element_id}').click();

Wait Until Animation Stops
    [Documentation]    Waits until the given element's horizontal position stops
    ...                changing between polls, confirming a CSS animation has finished
    ...                before interacting with it.
    [Arguments]    ${locator}    ${attempts}=50
    ${previous}=    Get Horizontal Position    ${locator}
    FOR    ${_attempt}    IN RANGE    ${attempts}
        Sleep    200ms
        ${current}=    Get Horizontal Position    ${locator}
        IF    ${current} == ${previous}    RETURN
        VAR    ${previous}=    ${current}
    END
    Fail    Element '${locator}' never stopped moving.

Set Value Via Javascript
    [Documentation]    Sets an input's value directly through JavaScript and dispatches an
    ...                input event so the page's own listeners see the change. Used for the
    ...                Overlapped Element challenge, where the field is covered by another
    ...                element and native Selenium keystrokes never register.
    [Arguments]    ${locator}    ${value}
    ${element}=    Get WebElement    ${locator}
    Execute Javascript
    ...    arguments[0].value = arguments[1];
    ...    arguments[0].dispatchEvent(new Event('input', {bubbles: true}));
    ...    ARGUMENTS
    ...    ${element}
    ...    ${value}

Get Row Cell Values
    [Documentation]    Reads the ARIA role="row" elements of the Dynamic Table challenge
    ...                (which uses divs, not a real <table>) and returns each row's cell
    ...                text values as a list of lists, first row first.
    ${rows}=    Execute Javascript
    ...    function cellText(cell) { return cell.textContent.trim(); }
    ...    function rowCells(row) { return Array.from(row.querySelectorAll('[role="cell"]')).map(cellText); }
    ...    return Array.from(document.querySelectorAll('[role="row"]'))
    ...    .filter(function(row) { return row.querySelector('[role="cell"]'); })
    ...    .map(rowCells);
    RETURN    ${rows}

Get Cpu Column Index
    [Documentation]    Returns the position of the "CPU" column among the Dynamic Table
    ...                challenge's headers. Column order (not just row order) reshuffles
    ...                on every page load, so this can't be hardcoded.
    ${index}=    Execute Javascript
    ...    var headers = Array.from(document.querySelectorAll('[role="columnheader"]'))
    ...    .map(function(h) { return h.textContent.trim(); });
    ...    return headers.indexOf('CPU');
    RETURN    ${index}

Clear Field And Notify Page
    [Documentation]    Clears an input/textarea and manually dispatches an input event.
    ...                SeleniumLibrary's Clear Element Text updates the DOM value but does
    ...                not fire an input event, so pages that recompute state from that
    ...                event (like Clear Input's live counter) never notice the change
    ...                without this extra nudge.
    [Arguments]    ${locator}
    Clear Element Text    ${locator}
    ${element}=    Get WebElement    ${locator}
    Execute Javascript
    ...    arguments[0].dispatchEvent(new Event('input', {bubbles: true}));
    ...    ARGUMENTS
    ...    ${element}
