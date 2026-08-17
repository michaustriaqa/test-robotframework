*** Settings ***
Documentation       Temporary diagnostic: checks whether the price-plan step actually
...                 fires a data-fetching request this time. Not part of the portfolio.
Resource            ../resources/common.resource
Resource            ../resources/pages/home_page.resource
Resource            ../resources/pages/vehicle_data_page.resource
Resource            ../resources/pages/insurant_data_page.resource
Resource            ../resources/pages/product_data_page.resource
Resource            ../resources/data/car_insurance_test_data.resource
Suite Setup         Open Insurance Application
Suite Teardown      Close Insurance Application
Test Tags           smoke


*** Test Cases ***
Check Price Plan Load
    Select Automobile Insurance
    Enter Vehicle Data    &{VEHICLE_MERCEDES_BENZ}
    Vehicle Data Should Be Accepted
    Enter Insurant Data    &{INSURANT_JANE_DOE}
    Insurant Data Should Be Accepted
    Enter Product Data
    Product Data Should Be Accepted
    Sleep    10s
    ${state}=    Execute Javascript
    ...    var xhrs = performance.getEntriesByType('resource').filter(function(r) { return r.initiatorType === 'xmlhttprequest' || r.initiatorType === 'fetch'; }).map(function(r) { return r.name + ' dur=' + Math.round(r.duration) + ' start=' + Math.round(r.startTime); }).join(' || ');
    ...    var loader = document.getElementById('xLoaderPrice');
    ...    var loaderVis = loader ? (loader.offsetParent !== null) : 'MISSING';
    ...    var silver = document.getElementById('selectsilver');
    ...    var silverVis = silver ? (silver.offsetParent !== null) : 'MISSING';
    ...    return 'loaderVisible=' + loaderVis + ' silverVisible=' + silverVis + ' XHRS: ' + xhrs;
    Log    PRICE STATE: ${state}    console=True
