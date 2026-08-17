*** Settings ***
Documentation       Regression coverage for the vehicle, insurant and product data steps
...                 of the insurance quote wizard on the Tricentis sample insurance
...                 application.
...
...                 Price selection and quote submission are not covered here; see the
...                 "Known limitations" section of the project README.

Resource            ../resources/common.resource
Resource            ../resources/pages/home_page.resource
Resource            ../resources/pages/vehicle_data_page.resource
Resource            ../resources/pages/insurant_data_page.resource
Resource            ../resources/pages/product_data_page.resource

Suite Setup         Open Insurance Application
Suite Teardown      Close Insurance Application
Test Setup          Go To Homepage
Test Teardown       Capture Screenshot On Failure
Test Timeout        1 minute

Test Tags           car-insurance


*** Test Cases ***
Create Quote For Car With Valid Data
    [Documentation]    A customer can complete the vehicle, insurant and product data
    ...                steps of a car insurance quote with a valid profile, and the
    ...                wizard accepts the submission.
    [Tags]    smoke
    Log    STEP: Select Automobile Insurance    console=True
    Select Automobile Insurance
    Log    STEP: Enter Vehicle Data    console=True
    Enter Vehicle Data
    ...    make=Mercedes Benz
    ...    engine_performance=68
    ...    manufacture_date=08/25/2023
    ...    seats=7
    ...    fuel=Diesel
    ...    list_price=50000
    ...    annual_mileage=32185
    Log    STEP: firstname    console=True
    Input Text    css:#firstname    Jane
    Log    STEP: lastname    console=True
    Input Text    css:#lastname    Doe
    Log    STEP: birthdate    console=True
    Input Text    css:#birthdate    05/14/1990
    Log    STEP: gender    console=True
    Click Element    css:#genderfemale + span.ideal-radio
    Log    STEP: streetaddress    console=True
    Input Text    css:#streetaddress    Baker Street 221B
    Log    STEP: country    console=True
    ${country_value}=    Execute Javascript    return document.getElementById('country').options[1].value;
    Select From List By Value    css:#country    ${country_value}
    Log    STEP: zipcode    console=True
    Input Text    css:#zipcode    10115
    Log    STEP: city    console=True
    Input Text    css:#city    Berlin
    Log    STEP: occupation    console=True
    ${occupation_value}=    Execute Javascript    return document.getElementById('occupation').options[1].value;
    Select From List By Value    css:#occupation    ${occupation_value}
    Log    STEP: nextenterproductdata    console=True
    Click Button    css:#nextenterproductdata
    Log    STEP: wait startdate    console=True
    Wait Until Element Is Visible    css:#startdate
    Log    STEP: Enter Product Data    console=True
    Enter Product Data
    Log    STEP: Product Data Should Be Accepted    console=True
    Product Data Should Be Accepted
    Log    STEP: DONE    console=True

Create Quote For Car With Multiple Vehicle Profiles
    [Documentation]    The quote wizard accepts a range of valid vehicle configurations.
    [Tags]    regression
    [Template]    Request Car Quote For Vehicle
    Volkswagen    75    01/15/2022    5    Petrol    28000    15000
    BMW    140    03/10/2021    5    Diesel    45000    20000
    Mercedes Benz    68    08/25/2023    7    Diesel    50000    32185


*** Keywords ***
Request Car Quote For Vehicle
    [Documentation]    Requests a car insurance quote for the given vehicle, using a
    ...                fixed, valid insurant profile.
    [Arguments]    ${make}
    ...    ${engine_performance}
    ...    ${manufacture_date}
    ...    ${seats}
    ...    ${fuel}
    ...    ${list_price}
    ...    ${annual_mileage}
    Select Automobile Insurance
    Enter Vehicle Data
    ...    make=${make}
    ...    engine_performance=${engine_performance}
    ...    manufacture_date=${manufacture_date}
    ...    seats=${seats}
    ...    fuel=${fuel}
    ...    list_price=${list_price}
    ...    annual_mileage=${annual_mileage}
    Enter Insurant Data
    ...    first_name=John
    ...    last_name=Smith
    ...    birthdate=01/01/1985
    ...    gender=Male
    ...    street=Main Street 1
    ...    zip_code=10115
    ...    city=Berlin
    Enter Product Data
    Product Data Should Be Accepted
