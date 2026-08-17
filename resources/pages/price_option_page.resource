*** Settings ***
Documentation       Locators and keywords for the "Select Price Option" step of the
...                 car insurance quote wizard.

Library             SeleniumLibrary


*** Variables ***
${SEND_QUOTE_BUTTON}    css:#sendinsurance


*** Keywords ***
Select Price Option
    [Documentation]    Selects a price package. Valid values: basic, premium, top.
    [Arguments]    ${option}
    VAR    &{options}
    ...    basic=css:#optionbasic
    ...    premium=css:#optionpremium
    ...    top=css:#optiontop
    Click Element    ${options}[${option}]

Send Quote
    [Documentation]    Submits the completed quote request.
    Click Button    ${SEND_QUOTE_BUTTON}
