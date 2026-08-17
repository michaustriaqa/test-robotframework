*** Settings ***
Documentation       Locators and keywords for the "Select Price Option" step of the
...                 insurance quote wizard.
...
...                 Like the gender radios on the insurant data step, the price plan
...                 radios are hidden behind styled spans (idealforms), so they're
...                 selected by clicking the visible sibling span, not the input.

Library             SeleniumLibrary
Resource            ../common.resource


*** Variables ***
${SILVER_OPTION}                css:#selectsilver + span.ideal-radio
${GOLD_OPTION}                  css:#selectgold + span.ideal-radio
${PLATINUM_OPTION}              css:#selectplatinum + span.ideal-radio
${ULTIMATE_OPTION}              css:#selectultimate + span.ideal-radio
${SEND_QUOTE_FIRST_FIELD}       css:#email


*** Keywords ***
Select Price Option
    [Documentation]    Waits for the price plans to finish loading, selects one and
    ...                submits the step. Valid values: silver, gold, platinum, ultimate.
    ...                The price plans are fetched asynchronously after the product
    ...                data step, so this allows a generous timeout for that to settle.
    [Arguments]    ${plan}
    VAR    &{options}
    ...    silver=${SILVER_OPTION}
    ...    gold=${GOLD_OPTION}
    ...    platinum=${PLATINUM_OPTION}
    ...    ultimate=${ULTIMATE_OPTION}
    Wait Until Element Is Visible    ${options}[${plan}]    timeout=45s
    Wait Until Keyword Succeeds    10x    300ms    Click Element    ${options}[${plan}]
    No Validation Errors Should Be Visible
    Click Next Button

Click Next Button
    [Documentation]    Submits the step. A plain WebDriver click on the equivalent
    ...                button in an earlier step was observed to intermittently and
    ...                repeatedly fail with ElementNotInteractableException in CI even
    ...                after several retries, so it's dispatched via JavaScript instead,
    ...                which the button's own click handler responds to just as well.
    Execute Javascript    document.getElementById('nextsendquote').click();

Price Option Should Be Accepted
    [Documentation]    Verifies the wizard genuinely moved on: the price plan selection
    ...                was accepted and the send-quote contact form has taken its place.
    Wait Until Element Is Visible    ${SEND_QUOTE_FIRST_FIELD}    timeout=30s
