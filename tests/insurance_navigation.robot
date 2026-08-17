*** Settings ***
Documentation       Smoke coverage for switching between the available insurance types
...                 on the landing page.

Resource            ../resources/common.resource
Resource            ../resources/pages/home_page.resource

Suite Setup         Open Insurance Application
Suite Teardown      Close Insurance Application
Test Setup          Go To Homepage
Test Teardown       Capture Screenshot On Failure

Test Tags           navigation


*** Test Cases ***
Automobile Tab Is Selectable
    [Documentation]    Selecting the automobile insurance type reveals the vehicle data
    ...                form.
    [Tags]    smoke
    Select Automobile Insurance
    Element Should Be Visible    css:#make

Other Insurance Types Are Selectable
    [Documentation]    Selecting truck, motorcycle or camper insurance also reveals the
    ...                vehicle data form. Extrapolated from the verified automobile
    ...                behaviour above, since the wizard is shared across vehicle types;
    ...                not included in the CI-gated smoke suite.
    [Tags]    regression
    [Template]    Insurance Type Should Reveal Vehicle Data Form
    Truck
    Motorcycle
    Camper


*** Keywords ***
Insurance Type Should Reveal Vehicle Data Form
    [Documentation]    Selects the given insurance type and verifies the vehicle data
    ...                form becomes visible. Valid values: Truck, Motorcycle, Camper.
    [Arguments]    ${insurance_type}
    Run Keyword    Select ${insurance_type} Insurance
    Element Should Be Visible    css:#make
