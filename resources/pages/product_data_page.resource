*** Settings ***
Documentation       Locators and keywords for the "Enter Product Data" step of the
...                 car insurance quote wizard.

Library             SeleniumLibrary


*** Variables ***
${START_DATE_FIELD}             css:#startdate
${INSURANCE_SUM_FIELD}          css:#insurancesum
${MERITRATING_FIELD}            css:#meritrating
${DAMAGE_INSURANCE_FIELD}       css:#damageinsurance
${COURTESY_CAR_FIELD}           css:#courtesycar
${NEXT_BUTTON}                  css:#nextselectproduct
${PRICE_OPTION_FORM}            css:#selectproduct


*** Keywords ***
Enter Product Data
    [Documentation]    Fills in the requested product options and proceeds to the
    ...    price selection step.
    [Arguments]    ${start_date}
    ...    ${insurance_sum}
    ...    ${meritrating}
    ...    ${damage_insurance}
    ...    ${courtesy_car}=${FALSE}
    Input Text    ${START_DATE_FIELD}    ${start_date}
    Select From List By Value    ${INSURANCE_SUM_FIELD}    ${insurance_sum}
    Select From List By Value    ${MERITRATING_FIELD}    ${meritrating}
    Select From List By Value    ${DAMAGE_INSURANCE_FIELD}    ${damage_insurance}
    IF    ${courtesy_car}    Select Checkbox    ${COURTESY_CAR_FIELD}
    Click Button    ${NEXT_BUTTON}
    Wait Until Element Is Visible    ${PRICE_OPTION_FORM}
