*** Settings ***
Documentation       Temporary diagnostic suite: attempts the full corrected wizard flow
...                 against the live application and logs the outcome. Not part of the
...                 portfolio.
Library             DateTime
Resource            ../resources/common.resource
Suite Setup         Open Insurance Application
Suite Teardown      Close Insurance Application
Test Tags           smoke


*** Test Cases ***
Attempt Full Quote Flow
    Go To    ${APP_URL}
    Wait Until Element Is Visible    css:#nav_automobile
    Click Element    css:#nav_automobile
    Wait Until Element Is Visible    css:#make

    Select From List By Value    css:#make    Mercedes Benz
    Input Text    css:#engineperformance    68
    Input Text    css:#dateofmanufacture    08/25/2023
    Select From List By Value    css:#numberofseats    7
    Select From List By Value    css:#fuel    Diesel
    Input Text    css:#listprice    50000
    Input Text    css:#annualmileage    32185
    Click Button    css:#nextenterinsurantdata
    Wait Until Element Is Visible    css:#firstname

    Input Text    css:#firstname    Jane
    Input Text    css:#lastname    Doe
    Input Text    css:#birthdate    05/14/1990
    Click Element    css:#genderfemale + span.ideal-radio
    Input Text    css:#streetaddress    Baker Street 221B
    ${country_value}=    Execute Javascript    return document.querySelector('#country').options[1].value;
    Select From List By Value    css:#country    ${country_value}
    Input Text    css:#zipcode    10115
    Input Text    css:#city    Berlin
    ${occupation_value}=    Execute Javascript    return document.querySelector('#occupation').options[1].value;
    Select From List By Value    css:#occupation    ${occupation_value}
    Click Button    css:#nextenterproductdata
    Wait Until Element Is Visible    css:#startdate

    ${start_date}=    Get Current Date    increment=60 days    result_format=%m/%d/%Y
    Input Text    css:#startdate    ${start_date}
    ${insurancesum_value}=    Execute Javascript    return document.querySelector('#insurancesum').options[1].value;
    Select From List By Value    css:#insurancesum    ${insurancesum_value}
    ${meritrating_value}=    Execute Javascript    return document.querySelector('#meritrating').options[1].value;
    Select From List By Value    css:#meritrating    ${meritrating_value}
    ${damageinsurance_value}=    Execute Javascript    return document.querySelector('#damageinsurance').options[1].value;
    Select From List By Value    css:#damageinsurance    ${damageinsurance_value}
    ${courtesycar_value}=    Execute Javascript    return document.querySelector('#courtesycar').options[1].value;
    Select From List By Value    css:#courtesycar    ${courtesycar_value}
    Click Button    css:#nextselectpriceoption
    Sleep    3s
    ${state}=    Execute Javascript
    ...    function vis(sel) { var e = document.querySelector(sel); if (!e) return sel + '=MISSING'; return sel + '=' + (e.offsetParent !== null ? 'VISIBLE' : 'hidden'); } var errs = Array.from(document.querySelectorAll('.error, .errorMessage, .invalid, [class*="error"]')).map(e => e.id + ':' + e.textContent.trim()).filter(t => t.length > 1).join(' || '); return [vis('#startdate'), vis('#selectsilver'), vis('#pricePlans'), vis('#xLoaderPrice')].join(', ') + ' ERRORS: ' + errs;
    Log    STATE AFTER NEXT: ${state}    console=True
    Wait Until Element Is Visible    css:#selectsilver    timeout=15s

    Click Element    css:#selectsilver + span.ideal-radio
    Click Button    css:#nextsendquote
    Wait Until Element Is Visible    css:#email

    Input Text    css:#email    jane.doe@example.com
    Input Text    css:#phone    1234567890
    Input Text    css:#username    janedoe123
    Input Text    css:#password    Passw0rd!
    Input Text    css:#confirmpassword    Passw0rd!
    Click Button    css:#sendemail
    Wait Until Element Is Visible    css:#finished-container    timeout=15s
    ${finished_text}=    Execute Javascript    return document.querySelector('#finished-container').innerText.substring(0, 500);
    Log    FINISHED: ${finished_text}    console=True
