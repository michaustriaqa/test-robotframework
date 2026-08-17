*** Settings ***
Documentation       Regression coverage for the vehicle, insurant, product data and price
...                 selection steps of the insurance quote wizard on the Tricentis sample
...                 insurance application.
...
...                 Quote submission (the contact/registration step after price
...                 selection) is not covered here; see the "Known limitations" section
...                 of the project README.

Resource            ../resources/common.resource
Resource            ../resources/pages/home_page.resource
Resource            ../resources/pages/vehicle_data_page.resource
Resource            ../resources/pages/insurant_data_page.resource
Resource            ../resources/pages/product_data_page.resource
Resource            ../resources/pages/price_option_page.resource
Resource            ../resources/data/car_insurance_test_data.resource

Suite Setup         Open Insurance Application
Suite Teardown      Close Insurance Application
Test Setup          Go To Homepage
Test Teardown       Capture Screenshot On Failure
Test Timeout        2 minutes

Test Tags           car-insurance


*** Test Cases ***
Create Quote For Car With Valid Data
    [Documentation]    A customer can complete the vehicle, insurant, product data and
    ...                price selection steps of a car insurance quote with a valid
    ...                profile, and each step's data is genuinely accepted by the wizard.
    [Tags]    smoke
    Select Automobile Insurance
    Enter Vehicle Data    &{VEHICLE_MERCEDES_BENZ}
    Vehicle Data Should Be Accepted
    Enter Insurant Data    &{INSURANT_JANE_DOE}
    Insurant Data Should Be Accepted
    Enter Product Data
    Product Data Should Be Accepted
    Select Price Option    silver
    Price Option Should Be Accepted

Create Quote For Car With Multiple Vehicle Profiles
    [Documentation]    The quote wizard accepts a range of valid vehicle configurations.
    [Tags]    regression
    [Template]    Request Car Quote For Vehicle
    ${VEHICLE_VOLKSWAGEN}
    ${VEHICLE_BMW}
    ${VEHICLE_MERCEDES_BENZ}


*** Keywords ***
Request Car Quote For Vehicle
    [Documentation]    Requests a car insurance quote for the given vehicle profile,
    ...                using a fixed, valid insurant profile, and verifies each step's
    ...                data is genuinely accepted by the wizard.
    [Arguments]    ${vehicle}
    Select Automobile Insurance
    Enter Vehicle Data    &{vehicle}
    Vehicle Data Should Be Accepted
    Enter Insurant Data    &{INSURANT_JOHN_SMITH}
    Insurant Data Should Be Accepted
    Enter Product Data
    Product Data Should Be Accepted
    Select Price Option    silver
    Price Option Should Be Accepted
