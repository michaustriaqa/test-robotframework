*** Settings ***
Documentation       End-to-end regression coverage for the car insurance quote wizard
...                 on the Tricentis sample insurance application.

Resource            ../resources/common.resource
Resource            ../resources/pages/home_page.resource
Resource            ../resources/pages/vehicle_data_page.resource
Resource            ../resources/pages/insurant_data_page.resource
Resource            ../resources/pages/product_data_page.resource
Resource            ../resources/pages/price_option_page.resource
Resource            ../resources/pages/confirmation_page.resource

Suite Setup         Open Insurance Application
Suite Teardown      Close Insurance Application
Test Setup          Go To Homepage
Test Teardown       Capture Screenshot On Failure
Test Timeout        2 minutes

Test Tags           car-insurance    e2e


*** Test Cases ***
Create Quote For Car With Valid Data
    [Documentation]    A customer can obtain a car insurance quote by completing the
    ...    full quote wizard with a valid vehicle and personal profile.
    [Tags]    smoke
    Select Automobile Insurance
    Enter Vehicle Data
    ...    make=Mercedes Benz
    ...    engine_performance=68
    ...    manufacture_date=08/25/2023
    ...    seats=7
    ...    fuel=Diesel
    ...    list_price=50000
    ...    annual_mileage=32185
    Enter Insurant Data
    ...    first_name=Jane
    ...    last_name=Doe
    ...    birthdate=05/14/1990
    ...    gender=Female
    ...    street=Baker Street 221B
    ...    zip_code=10115
    ...    city=Berlin
    ...    occupation=Employee
    Enter Product Data
    ...    start_date=09/01/2023
    ...    insurance_sum=1000000
    ...    meritrating=1
    ...    damage_insurance=Basic
    ...    courtesy_car=${TRUE}
    Select Price Option    basic
    Send Quote
    Quote Should Be Confirmed

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
    ...    fixed, valid insurant profile.
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
    ...    occupation=Employee
    Enter Product Data
    ...    start_date=09/01/2023
    ...    insurance_sum=1000000
    ...    meritrating=1
    ...    damage_insurance=Basic
    ...    courtesy_car=${FALSE}
    Select Price Option    basic
    Send Quote
    Quote Should Be Confirmed
