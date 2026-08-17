*** Settings ***
Documentation       Locators and keywords for the "Enter Vehicle Data" step of the
...                 insurance quote wizard.

Library             SeleniumLibrary


*** Variables ***
${MAKE_FIELD}                   css:#make
${ENGINE_PERFORMANCE_FIELD}     css:#engineperformance
${MANUFACTURE_DATE_FIELD}       css:#dateofmanufacture
${SEATS_FIELD}                  css:#numberofseats
${FUEL_FIELD}                   css:#fuel
${LIST_PRICE_FIELD}             css:#listprice
${ANNUAL_MILEAGE_FIELD}         css:#annualmileage
${NEXT_BUTTON}                  css:#nextenterinsurantdata
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
    Select From List By Value    ${MAKE_FIELD}    ${make}
    Input Text    ${ENGINE_PERFORMANCE_FIELD}    ${engine_performance}
    Input Text    ${MANUFACTURE_DATE_FIELD}    ${manufacture_date}
    Select From List By Value    ${SEATS_FIELD}    ${seats}
    Select From List By Value    ${FUEL_FIELD}    ${fuel}
    Input Text    ${LIST_PRICE_FIELD}    ${list_price}
    Input Text    ${ANNUAL_MILEAGE_FIELD}    ${annual_mileage}
    Click Button    ${NEXT_BUTTON}
    Wait Until Element Is Visible    ${INSURANT_DATA_FIRST_FIELD}
