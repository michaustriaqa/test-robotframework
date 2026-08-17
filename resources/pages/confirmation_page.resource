*** Settings ***
Documentation       Keywords for verifying the quote confirmation step.

Library             SeleniumLibrary


*** Keywords ***
Quote Should Be Confirmed
    [Documentation]    Verifies that the insurance quote request was submitted successfully.
    Wait Until Page Contains    Thank You
