*** Settings ***
Documentation       Keywords shared by every UI test suite: browser lifecycle and
...                 failure diagnostics.

Library             SeleniumLibrary
Resource            variables.resource


*** Keywords ***
Open Insurance Application
    [Documentation]    Starts a browser session and opens the insurance sample application.
    Open Browser    ${APP_URL}    ${BROWSER}
    Set Selenium Timeout    ${SELENIUM_TIMEOUT}
    Set Window Size    1920    1080

Close Insurance Application
    [Documentation]    Closes every browser window opened during the suite.
    Close All Browsers

Capture Screenshot On Failure
    [Documentation]    Saves a screenshot of the current page whenever a test fails,
    ...    to speed up debugging.
    Run Keyword If Test Failed    Capture Page Screenshot
