*** Settings ***
Documentation       Locators and keywords for the "Enter Vehicle Data" step of the
...                 insurance quote wizard.
...
...                 Every interaction retries briefly, since fields can still be
...                 settling into place right after the insurance type tab is selected.

Library             SeleniumLibrary


*** Variables ***
${MAKE_FIELD}                   css:#make
${ENGINE_PERFORMANCE_FIELD}     css:#engineperformance
${MANUFACTURE_DATE_FIELD}       css:#dateofmanufacture
${SEATS_FIELD}                  css:#numberofseats
${FUEL_FIELD}                   css:#fuel
${LIST_PRICE_FIELD}             css:#listprice
${ANNUAL_MILEAGE_FIELD}         css:#annualmileage
${INSURANT_DATA_FIRST_FIELD}    css:#firstname


*** Keywords ***
Enter Vehicle Data
    [Documentation]    Fills in the vehicle details and proceeds to the insurant data step.
    [Arguments]    ${make}
    ...    ${engine_performance}
    ...    ${manufacture_date}
    ...    ${seats}
    ...    ${fuel}
    ...    ${list_price}
    ...    ${annual_mileage}
    Wait Until Keyword Succeeds    10x    300ms    Select From List By Value    ${MAKE_FIELD}    ${make}
    Wait Until Keyword Succeeds    10x    300ms
    ...    Input Text    ${ENGINE_PERFORMANCE_FIELD}    ${engine_performance}
    Wait Until Keyword Succeeds    10x    300ms
    ...    Input Text    ${MANUFACTURE_DATE_FIELD}    ${manufacture_date}
    Wait Until Keyword Succeeds    10x    300ms    Select From List By Value    ${SEATS_FIELD}    ${seats}
    Wait Until Keyword Succeeds    10x    300ms    Select From List By Value    ${FUEL_FIELD}    ${fuel}
    Wait Until Keyword Succeeds    10x    300ms    Input Text    ${LIST_PRICE_FIELD}    ${list_price}
    Wait Until Keyword Succeeds    10x    300ms
    ...    Input Text    ${ANNUAL_MILEAGE_FIELD}    ${annual_mileage}
    Click Next Button
    Wait Until Element Is Visible    ${INSURANT_DATA_FIRST_FIELD}

Click Next Button
    [Documentation]    Submits the step. A plain WebDriver click on the equivalent
    ...                button in a later step was observed to intermittently and
    ...                repeatedly fail with ElementNotInteractableException in CI even
    ...                after several retries, so it's dispatched via JavaScript instead,
    ...                which the button's own click handler responds to just as well.
    Execute Javascript    document.getElementById('nextenterinsurantdata').click();
