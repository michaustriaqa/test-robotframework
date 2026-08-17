*** Settings ***
Documentation       Locators and keywords for the "Enter Insurant Data" step of the
...                 insurance quote wizard.
...
...                 The country and occupation dropdowns use ideal-select styling with
...                 application-specific option values, so the keywords below select the
...                 first real (non-placeholder) option rather than a hard-coded label.
...                 Every interaction retries briefly, since fields can still be settling
...                 into place right after the previous step's panel closes.

Library             SeleniumLibrary


*** Variables ***
${FIRST_NAME_FIELD}             css:#firstname
${LAST_NAME_FIELD}              css:#lastname
${BIRTHDATE_FIELD}              css:#birthdate
${GENDER_MALE_RADIO}            css:#gendermale + span.ideal-radio
${GENDER_FEMALE_RADIO}          css:#genderfemale + span.ideal-radio
${STREET_FIELD}                 css:#streetaddress
${COUNTRY_FIELD}                css:#country
${ZIP_CODE_FIELD}               css:#zipcode
${CITY_FIELD}                   css:#city
${OCCUPATION_FIELD}             css:#occupation
${PRODUCT_DATA_FIRST_FIELD}     css:#startdate


*** Keywords ***
Enter Insurant Data
    [Documentation]    Fills in the insurant's personal details and proceeds to the
    ...                product data step.
    [Arguments]    ${first_name}
    ...    ${last_name}
    ...    ${birthdate}
    ...    ${gender}
    ...    ${street}
    ...    ${zip_code}
    ...    ${city}
    Wait Until Keyword Succeeds    10x    300ms    Input Text    ${FIRST_NAME_FIELD}    ${first_name}
    Wait Until Keyword Succeeds    10x    300ms    Input Text    ${LAST_NAME_FIELD}    ${last_name}
    Wait Until Keyword Succeeds    10x    300ms    Input Text    ${BIRTHDATE_FIELD}    ${birthdate}
    Select Gender    ${gender}
    Wait Until Keyword Succeeds    10x    300ms    Input Text    ${STREET_FIELD}    ${street}
    Select First Available Option    ${COUNTRY_FIELD}    country
    Wait Until Keyword Succeeds    10x    300ms    Input Text    ${ZIP_CODE_FIELD}    ${zip_code}
    Wait Until Keyword Succeeds    10x    300ms    Input Text    ${CITY_FIELD}    ${city}
    Select First Available Option    ${OCCUPATION_FIELD}    occupation
    Click Next Button
    Wait Until Element Is Visible    ${PRODUCT_DATA_FIRST_FIELD}

Click Next Button
    [Documentation]    Submits the step. A plain WebDriver click on this button was
    ...                observed to intermittently and repeatedly fail with
    ...                ElementNotInteractableException in CI even after several retries,
    ...                so it's dispatched via JavaScript instead, which the button's own
    ...                click handler responds to just as well.
    Execute Javascript    document.getElementById('nextenterproductdata').click();

Select Gender
    [Documentation]    Selects the insurant's gender. Valid values: Male, Female.
    [Arguments]    ${gender}
    IF    '${gender}' == 'Male'
        Wait Until Keyword Succeeds    10x    300ms    Click Element    ${GENDER_MALE_RADIO}
    ELSE
        Wait Until Keyword Succeeds    10x    300ms    Click Element    ${GENDER_FEMALE_RADIO}
    END

Select First Available Option
    [Documentation]    Selects the first real (non-placeholder) option of a select field.
    ...                ``locator`` is the SeleniumLibrary locator used to select the value;
    ...                ``element_id`` is the field's raw HTML id, used to read the option
    ...                list via JavaScript.
    [Arguments]    ${locator}    ${element_id}
    ${value}=    Execute Javascript
    ...    return document.getElementById('${element_id}').options[1].value;
    Wait Until Keyword Succeeds    10x    300ms    Select From List By Value    ${locator}    ${value}
