*** Settings ***
Documentation       Locators and keywords for uitestingplayground.com, a collection of
...                 small, independent pages that each demonstrate one UI automation
...                 challenge (dynamic attributes, timing, visibility, Shadow DOM, and
...                 so on). Unlike the car insurance wizard, these pages aren't part of
...                 a shared flow and each locator/keyword is used by exactly one test,
...                 so they're kept in a single file rather than one per page.

Library             SeleniumLibrary


*** Variables ***
${PLAYGROUND_BASE_URL}                  http://www.uitestingplayground.com
${SAMPLE_UPLOAD_FILE}                   ${CURDIR}/../data/sample_upload.txt

# Dynamic ID
${DYNAMIC_ID_BUTTON}                    css:button.btn.btn-primary

# Class Attribute
${CLASS_ATTRIBUTE_TARGET_BUTTON}        xpath://button[@class="btn btn-primary"]

# Hidden Layers
${HIDING_BUTTON}                        css:#hidingButton

# Load Delay
${LOAD_DELAY_BUTTON}                    css:button.btn.btn-primary

# AJAX Data
${AJAX_BUTTON}                          css:#ajaxButton
${AJAX_RESULT}                          css:.bg-success

# Client Side Delay
${CLIENT_DELAY_BUTTON}                  css:#ajaxButton
${CLIENT_DELAY_RESULT}                  css:.bg-success

# Click
${CLICK_TARGET_BUTTON}                  css:#badButton

# Text Input
${TEXT_INPUT_FIELD}                     css:#newButtonName
${TEXT_INPUT_UPDATE_BUTTON}             css:#updatingButton

# Scrollbars
${SCROLLBAR_BUTTON}                     css:#hidingButton

# Verify Text
${VERIFY_TEXT_PARAGRAPH}                css:.p-3

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
${VISIBILITY_NOT_VISIBLE_BUTTON}        css:#notvisibleButton

# Sample App
${SAMPLE_APP_USERNAME_FIELD}            css:#username
${SAMPLE_APP_PASSWORD_FIELD}            css:#password
${SAMPLE_APP_LOGIN_BUTTON}              css:#login
${SAMPLE_APP_STATUS_MESSAGE}            css:.output

# Mouse Over
${MOUSE_OVER_LINK}                      css:div.text-center > a[href="#"]
${MOUSE_OVER_CLICK_COUNT}               css:#clickCount

# Non-Breaking Space
${NBSP_BUTTON}                          xpath://button[contains(@class, "btn-primary")]
${NBSP_BUTTON_EXACT_TEXT}               xpath://button[text()="My Button"]

# Overlapped Element
${OVERLAPPED_NAME_FIELD}                css:#name

# Shadow DOM
${SHADOW_HOST}                          guid-generator
${SHADOW_GENERATE_BUTTON_ID}            buttonGenerate
${SHADOW_COPY_BUTTON_ID}                buttonCopy
${SHADOW_OUTPUT_ID}                     output
${SHADOW_EDIT_FIELD}                    css:#editField

# Alerts
${ALERT_BUTTON}                         css:#alertButton
${ALERT_RESULT}                         css:#result

# File Upload
${FILE_UPLOAD_INPUT}                    css:#fileinput
${FILE_UPLOAD_BUTTON}                   css:#uploadButton

# Animated Button
${ANIMATED_BUTTON}                      css:#animatedButton

# Disabled Input
${DISABLED_INPUT_FIELD}                 css:#input-example

# Auto Wait
${AUTO_WAIT_BUTTON}                     css:#ajaxButton

# Auto Complete
${AUTO_COMPLETE_INPUT}                  css:.react-autosuggest__input
${AUTO_COMPLETE_SUGGESTIONS}            css:.react-autosuggest__suggestions-list li
${AUTO_COMPLETE_FIRST_SUGGESTION}       css:.react-autosuggest__suggestions-list li:first-child
${AUTO_COMPLETE_SELECTED_TAGS}          css:.tag


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
