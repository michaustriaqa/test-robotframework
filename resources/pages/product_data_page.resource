*** Settings ***
Documentation       Locators and keywords for the "Enter Product Data" step of the
...                 insurance quote wizard.
...
...                 The coverage dropdowns (insurance sum, merit rating, damage
...                 insurance, courtesy car) use application-specific option values, so
...                 the keyword below selects the first real (non-placeholder) option
...                 for each rather than a hard-coded label.

Library             DateTime
Library             SeleniumLibrary


*** Variables ***
${START_DATE_FIELD}             css:#startdate
${INSURANCE_SUM_FIELD}          css:#insurancesum
${MERITRATING_FIELD}            css:#meritrating
${DAMAGE_INSURANCE_FIELD}       css:#damageinsurance
${COURTESY_CAR_FIELD}           css:#courtesycar
${NEXT_BUTTON}                  css:#nextselectpriceoption


*** Keywords ***
Enter Product Data
    [Documentation]    Fills in the requested product options with a valid, future
    ...                policy start date, and submits the step.
    ${start_date}=    Get Current Date    increment=60 days    result_format=%m/%d/%Y
    Input Text    ${START_DATE_FIELD}    ${start_date}
    Select First Available Option    ${INSURANCE_SUM_FIELD}    insurancesum
    Select First Available Option    ${MERITRATING_FIELD}    meritrating
    Select First Available Option    ${DAMAGE_INSURANCE_FIELD}    damageinsurance
    Select First Available Option    ${COURTESY_CAR_FIELD}    courtesycar
    Click Button    ${NEXT_BUTTON}

Select First Available Option
    [Documentation]    Selects the first real (non-placeholder) option of a select field.
    ...                ``locator`` is the SeleniumLibrary locator used to select the value;
    ...                ``element_id`` is the field's raw HTML id, used to read the option
    ...                list via JavaScript.
    [Arguments]    ${locator}    ${element_id}
    ${value}=    Execute Javascript
    ...    return document.getElementById('${element_id}').options[1].value;
    Select From List By Value    ${locator}    ${value}

Product Data Should Be Accepted
    [Documentation]    Verifies that the product data step was accepted and the wizard
    ...                advanced towards price selection.
    Wait Until Element Is Not Visible    ${START_DATE_FIELD}
