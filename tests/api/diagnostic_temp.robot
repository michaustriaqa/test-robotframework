*** Settings ***
Documentation       Temporary diagnostic: logs real restful-booker API responses (status
...                 codes and bodies) before writing the real suite. Not part of the
...                 portfolio.
Library             RequestsLibrary
Library             Collections

Test Tags           smoke


*** Test Cases ***
Dump Ping
    Create Session    booker    https://restful-booker.herokuapp.com
    ${response}=    GET On Session    booker    /ping    expected_status=any
    Log    PING STATUS: ${response.status_code} BODY: ${response.text}    console=True

Dump Auth
    ${payload}=    Create Dictionary    username=admin    password=password123
    ${response}=    POST On Session    booker    /auth    json=${payload}    expected_status=any
    Log    AUTH STATUS: ${response.status_code} BODY: ${response.text}    console=True

Dump Create Booking
    ${dates}=    Create Dictionary    checkin=2026-01-01    checkout=2026-01-05
    ${payload}=    Create Dictionary
    ...    firstname=Diagnostic
    ...    lastname=Tester
    ...    totalprice=150
    ...    depositpaid=${True}
    ...    bookingdates=${dates}
    ...    additionalneeds=Breakfast
    ${response}=    POST On Session    booker    /booking    json=${payload}    expected_status=any
    Log    CREATE STATUS: ${response.status_code} BODY: ${response.text}    console=True
    ${booking_id}=    Set Variable    ${response.json()}[bookingid]
    Set Suite Variable    ${DIAG_BOOKING_ID}    ${booking_id}

Dump Get Booking
    ${response}=    GET On Session    booker    /booking/${DIAG_BOOKING_ID}    expected_status=any
    Log    GET STATUS: ${response.status_code} BODY: ${response.text}    console=True

Dump Get Non Existing Booking
    ${response}=    GET On Session    booker    /booking/999999999    expected_status=any
    Log    GET MISSING STATUS: ${response.status_code} BODY: ${response.text}    console=True

Dump Update Booking Without Auth
    ${dates}=    Create Dictionary    checkin=2026-02-01    checkout=2026-02-10
    ${payload}=    Create Dictionary
    ...    firstname=NoAuth
    ...    lastname=Attempt
    ...    totalprice=999
    ...    depositpaid=${False}
    ...    bookingdates=${dates}
    ...    additionalneeds=None
    ${response}=    PUT On Session    booker    /booking/${DIAG_BOOKING_ID}    json=${payload}    expected_status=any
    Log    UPDATE NO AUTH STATUS: ${response.status_code} BODY: ${response.text}    console=True

Dump Update Booking With Auth
    ${auth_payload}=    Create Dictionary    username=admin    password=password123
    ${auth_response}=    POST On Session    booker    /auth    json=${auth_payload}
    ${token}=    Set Variable    ${auth_response.json()}[token]
    Log    TOKEN: ${token}    console=True
    &{headers}=    Create Dictionary    Cookie=token=${token}
    ${dates}=    Create Dictionary    checkin=2026-03-01    checkout=2026-03-10
    ${payload}=    Create Dictionary
    ...    firstname=Updated
    ...    lastname=Person
    ...    totalprice=500
    ...    depositpaid=${True}
    ...    bookingdates=${dates}
    ...    additionalneeds=Lunch
    ${response}=    PUT On Session    booker    /booking/${DIAG_BOOKING_ID}    json=${payload}
    ...    headers=${headers}    expected_status=any
    Log    UPDATE WITH AUTH STATUS: ${response.status_code} BODY: ${response.text}    console=True

Dump Partial Update Booking
    ${auth_payload}=    Create Dictionary    username=admin    password=password123
    ${auth_response}=    POST On Session    booker    /auth    json=${auth_payload}
    ${token}=    Set Variable    ${auth_response.json()}[token]
    &{headers}=    Create Dictionary    Cookie=token=${token}
    ${payload}=    Create Dictionary    totalprice=777
    ${response}=    PATCH On Session    booker    /booking/${DIAG_BOOKING_ID}    json=${payload}
    ...    headers=${headers}    expected_status=any
    Log    PATCH STATUS: ${response.status_code} BODY: ${response.text}    console=True

Dump Delete Booking Without Auth
    ${response}=    DELETE On Session    booker    /booking/${DIAG_BOOKING_ID}    expected_status=any
    Log    DELETE NO AUTH STATUS: ${response.status_code} BODY: ${response.text}    console=True

Dump Delete Booking With Auth
    ${auth_payload}=    Create Dictionary    username=admin    password=password123
    ${auth_response}=    POST On Session    booker    /auth    json=${auth_payload}
    ${token}=    Set Variable    ${auth_response.json()}[token]
    &{headers}=    Create Dictionary    Cookie=token=${token}
    ${response}=    DELETE On Session    booker    /booking/${DIAG_BOOKING_ID}    headers=${headers}    expected_status=any
    Log    DELETE WITH AUTH STATUS: ${response.status_code} BODY: ${response.text}    console=True

Dump Get After Delete
    ${response}=    GET On Session    booker    /booking/${DIAG_BOOKING_ID}    expected_status=any
    Log    GET AFTER DELETE STATUS: ${response.status_code} BODY: ${response.text}    console=True

Dump Filter By Name
    ${response}=    GET On Session    booker    /booking    params=firstname=Diagnostic&lastname=Tester
    ...    expected_status=any
    Log    FILTER STATUS: ${response.status_code} BODY: ${response.text}    console=True

Dump Auth With Bad Credentials
    ${payload}=    Create Dictionary    username=admin    password=wrongpassword
    ${response}=    POST On Session    booker    /auth    json=${payload}    expected_status=any
    Log    BAD AUTH STATUS: ${response.status_code} BODY: ${response.text}    console=True
