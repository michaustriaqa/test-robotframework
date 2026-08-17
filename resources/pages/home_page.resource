*** Settings ***
Documentation       Locators and keywords for the insurance type selection landing page.

Library             SeleniumLibrary
Resource            ../variables.resource


*** Variables ***
${AUTOMOBILE_TAB}       css:#nav_automobile
${TRUCK_TAB}            css:#nav_truck
${MOTORCYCLE_TAB}       css:#nav_motorcycle
${CAMPER_TAB}           css:#nav_camper
${MAKE_FIELD}           css:#make


*** Keywords ***
Go To Homepage
    [Documentation]    Navigates (back) to the insurance type selection page.
    Go To    ${APP_URL}
    Wait Until Element Is Visible    ${AUTOMOBILE_TAB}

Select Automobile Insurance
    [Documentation]    Opens the automobile insurance quote wizard.
    Click Element    ${AUTOMOBILE_TAB}
    Wait Until Element Is Visible    ${MAKE_FIELD}

Select Truck Insurance
    [Documentation]    Opens the truck insurance quote wizard.
    Click Element    ${TRUCK_TAB}
    Wait Until Element Is Visible    ${MAKE_FIELD}

Select Motorcycle Insurance
    [Documentation]    Opens the motorcycle insurance quote wizard.
    Click Element    ${MOTORCYCLE_TAB}
    Wait Until Element Is Visible    ${MAKE_FIELD}

Select Camper Insurance
    [Documentation]    Opens the camper insurance quote wizard.
    Click Element    ${CAMPER_TAB}
    Wait Until Element Is Visible    ${MAKE_FIELD}
