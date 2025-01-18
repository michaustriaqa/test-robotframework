*** Settings ***
Documentation      First Test Case
Library            SeleniumLibrary
Library          RequestsLibrary
Library          Collections


*** Variables ***
${BROWSER}     chrome
${LINK}        https://sampleapp.tricentis.com/
${OUTPUTDIR}    ..\results\Screenshots

*** Test Cases ***
Create Quote for Car
    Open Insurance Application
    Enter Vehicle Data for Automobile
    Enter Insurant Data
    Enter Product Data
    Select Price Option
    Send Quote
    End Test

*** Keywords ***
Open Insurance Application 
    Open Browser    ${LINK}    ${BROWSER}
    Maximize Browser Window


Enter Vehicle Data for Automobile
    Scroll Element Into View    css:#nav_automobile
    Click Element    css:#nav_automobile
    Wait Until Element Is Visible    css:#entervehicledata
    Sleep    5s
    Select From List By Value    css:#make    Mercedes Benz
    Sleep    5s
    Input Text    css:#engineperformance    68
    Input Text    css:#dateofmanufacture    08/25/2023
    Select From List By Value    css:#numberofseats    7
    Sleep    5s
    Select From List By Value    css:#fuel    Diesel
    Sleep    5s
    Input Text    css:#listprice    50000
    Input Text    css:#annualmileage    32185
    Sleep    5s
    Click Button    css:#nextenterinsurantdata


Enter Insurant Data
    Sleep    5s
    Input Text    css:#firstname    test


Enter Product Data
    Sleep    5s

Select Price Option
    Sleep    5s

Send Quote
    Sleep    5s

End Test
    Close Browser