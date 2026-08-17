*** Settings ***
Documentation       Locators and keywords for the "Enter Product Data" step of the
...                 insurance quote wizard.
...
...                 The coverage dropdowns (insurance sum, merit rating, damage
...                 insurance, courtesy car) use application-specific option values, so
...                 the keyword below selects the first real (non-placeholder) option
...                 for each rather than a hard-coded label. Every interaction retries
...                 briefly, since fields can still be settling into place right after
...                 the previous step's panel closes.

Library             DateTime
Library             SeleniumLibrary
Resource            ../common.resource


*** Variables ***
${START_DATE_FIELD}             css:#startdate
${INSURANCE_SUM_FIELD}          css:#insurancesum
${MERITRATING_FIELD}            css:#meritrating
${DAMAGE_INSURANCE_FIELD}       css:#damageinsurance
${COURTESY_CAR_FIELD}           css:#courtesycar
${PRICE_LOADER}                 css:#xLoaderPrice


*** Keywords ***
Enter Product Data
    [Documentation]    Fills in the requested product options with a valid, future
    ...                policy start date, and submits the step.
    ${start_date}=    Get Current Date    increment=60 days    result_format=%m/%d/%Y
    Wait Until Keyword Succeeds    10x    300ms    Input Text    ${START_DATE_FIELD}    ${start_date}
    Select First Available Option    ${INSURANCE_SUM_FIELD}    insurancesum
    Select First Available Option    ${MERITRATING_FIELD}    meritrating
    Select First Available Option    ${DAMAGE_INSURANCE_FIELD}    damageinsurance
    Select First Available Option    ${COURTESY_CAR_FIELD}    courtesycar
    No Validation Errors Should Be Visible
    Click Next Button

Click Next Button
    [Documentation]    Submits the step. A plain WebDriver click on the equivalent
    ...                button in an earlier step was observed to intermittently and
    ...                repeatedly fail with ElementNotInteractableException in CI even
    ...                after several retries, so it's dispatched via JavaScript instead,
    ...                which the button's own click handler responds to just as well.
    Execute Javascript    document.getElementById('nextselectpriceoption').click();

Select First Available Option
    [Documentation]    Selects the first real (non-placeholder) option of a select field.
    ...                ``locator`` is the SeleniumLibrary locator used to select the value;
    ...                ``element_id`` is the field's raw HTML id, used to read the option
    ...                list via JavaScript.
    [Arguments]    ${locator}    ${element_id}
    ${value}=    Execute Javascript
    ...    return document.getElementById('${element_id}').options[1].value;
    Wait Until Keyword Succeeds    10x    300ms    Select From List By Value    ${locator}    ${value}

Product Data Should Be Accepted
    [Documentation]    Verifies the wizard genuinely moved on: the product data panel
    ...                is gone, and the price step's loading indicator has appeared,
    ...                confirming the submission was accepted rather than merely that
    ...                the previous panel disappeared for some unrelated reason.
    Wait Until Element Is Not Visible    ${START_DATE_FIELD}
    Wait Until Element Is Visible    ${PRICE_LOADER}
