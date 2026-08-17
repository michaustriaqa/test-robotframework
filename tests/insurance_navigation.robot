*** Settings ***
Documentation       Smoke coverage for switching between the available insurance types
...                 on the landing page.

Resource            ../resources/common.resource
Resource            ../resources/pages/home_page.resource

Suite Setup         Open Insurance Application
Suite Teardown      Close Insurance Application
Test Setup          Go To Homepage
Test Teardown       Capture Screenshot On Failure

Test Tags           smoke    navigation


*** Test Cases ***
Automobile Tab Is Selectable
    [Documentation]    The automobile insurance tab becomes active when selected and
    ...    reveals the vehicle data form.
    Select Automobile Insurance
    Automobile Tab Should Be Active
    Element Should Be Visible    css:#entervehicledata

Motorcycle Tab Is Selectable
    [Documentation]    The motorcycle insurance tab becomes active when selected.
    Select Motorcycle Insurance
    Motorcycle Tab Should Be Active

Travel Tab Is Selectable
    [Documentation]    The travel insurance tab becomes active when selected.
    Select Travel Insurance
    Travel Tab Should Be Active
