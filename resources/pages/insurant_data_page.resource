*** Settings ***
Documentation       Locators and keywords for the "Enter Insurant Data" step of the
...                 car insurance quote wizard.

Library             SeleniumLibrary


*** Variables ***
${FIRST_NAME_FIELD}         css:#firstname
${LAST_NAME_FIELD}          css:#lastname
${BIRTHDATE_FIELD}          css:#birthdate
${GENDER_MALE_RADIO}        css:#gender_m
${GENDER_FEMALE_RADIO}      css:#gender_f
${STREET_FIELD}             css:#street
${ZIP_CODE_FIELD}           css:#zipcode
${CITY_FIELD}               css:#city
${OCCUPATION_FIELD}         css:#occupation
${NEXT_BUTTON}              css:#nextenterproductdata
${PRODUCT_DATA_FORM}        css:#enterproductdata


*** Keywords ***
Enter Insurant Data
    [Documentation]    Fills in the insurant's personal details and proceeds to the
    ...    product data step.
    [Arguments]    ${first_name}
    ...    ${last_name}
    ...    ${birthdate}
    ...    ${gender}
    ...    ${street}
    ...    ${zip_code}
    ...    ${city}
    ...    ${occupation}
    Input Text    ${FIRST_NAME_FIELD}    ${first_name}
    Input Text    ${LAST_NAME_FIELD}    ${last_name}
    Input Text    ${BIRTHDATE_FIELD}    ${birthdate}
    Select Gender    ${gender}
    Input Text    ${STREET_FIELD}    ${street}
    Input Text    ${ZIP_CODE_FIELD}    ${zip_code}
    Input Text    ${CITY_FIELD}    ${city}
    Select From List By Value    ${OCCUPATION_FIELD}    ${occupation}
    Click Button    ${NEXT_BUTTON}
    Wait Until Element Is Visible    ${PRODUCT_DATA_FORM}

Select Gender
    [Documentation]    Selects the insurant's gender. Valid values: Male, Female.
    [Arguments]    ${gender}
    IF    '${gender}' == 'Male'
        Click Element    ${GENDER_MALE_RADIO}
    ELSE
        Click Element    ${GENDER_FEMALE_RADIO}
    END
