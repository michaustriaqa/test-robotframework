*** Settings ***
Documentation       Temporary diagnostic suite: dumps live page structure to CI logs
...                 so real locators can be confirmed. Not part of the portfolio.
Resource            ../resources/common.resource
Resource            ../resources/pages/home_page.resource
Suite Setup         Open Insurance Application
Suite Teardown      Close Insurance Application
Test Tags           smoke


*** Test Cases ***
Dump Page Structure
    Go To Homepage
    ${home_ids}=    Execute Javascript
    ...    return Array.from(document.querySelectorAll('[id]')).map(e => e.tagName + '#' + e.id + '.' + e.className).join(' | ');
    Log    HOME: ${home_ids}    console=True
    Select Automobile Insurance
    ${vehicle_ids}=    Execute Javascript
    ...    return Array.from(document.querySelectorAll('[id]')).map(e => e.tagName + '#' + e.id + '.' + e.className).join(' | ');
    Log    VEHICLE: ${vehicle_ids}    console=True
