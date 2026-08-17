*** Settings ***
Documentation       Locators and keywords for the insurance type selection landing page.

Library             SeleniumLibrary
Resource            ../variables.resource


*** Variables ***
${AUTOMOBILE_TAB}       css:#nav_automobile
${MOTORCYCLE_TAB}       css:#nav_motorcycle
${TRAVEL_TAB}           css:#nav_travel
${VEHICLE_DATA_FORM}    css:#entervehicledata


*** Keywords ***
Go To Homepage
    [Documentation]    Navigates (back) to the insurance type selection page.
    Go To    ${APP_URL}
    Wait Until Element Is Visible    ${AUTOMOBILE_TAB}

Select Automobile Insurance
    [Documentation]    Opens the car insurance quote wizard.
    Click Element    ${AUTOMOBILE_TAB}
    Wait Until Element Is Visible    ${VEHICLE_DATA_FORM}

Select Motorcycle Insurance
    [Documentation]    Switches the landing page to the motorcycle insurance type.
    Click Element    ${MOTORCYCLE_TAB}

Select Travel Insurance
    [Documentation]    Switches the landing page to the travel insurance type.
    Click Element    ${TRAVEL_TAB}

Automobile Tab Should Be Active
    [Documentation]    Verifies the automobile tab is highlighted as the active insurance type.
    Tab Should Be Active    ${AUTOMOBILE_TAB}

Motorcycle Tab Should Be Active
    [Documentation]    Verifies the motorcycle tab is highlighted as the active insurance type.
    Tab Should Be Active    ${MOTORCYCLE_TAB}

Travel Tab Should Be Active
    [Documentation]    Verifies the travel tab is highlighted as the active insurance type.
    Tab Should Be Active    ${TRAVEL_TAB}

Tab Should Be Active
    [Documentation]    Verifies that the given navigation tab carries the "active" class.
    [Arguments]    ${tab_locator}
    ${classes}=    Get Element Attribute    ${tab_locator}    class
    Should Contain    ${classes}    active
