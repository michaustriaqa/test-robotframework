*** Settings ***
Documentation       Keywords for interacting with the restful-booker API
...                 (https://restful-booker.herokuapp.com), a public REST API practice
...                 target modeling a hotel booking system with token-based auth on
...                 write operations.

Library             Collections
Library             RequestsLibrary


*** Variables ***
${API_SESSION}          restful_booker
${API_BASE_URL}         https://restful-booker.herokuapp.com
${BOOKER_USERNAME}      admin
${BOOKER_PASSWORD}      password123


*** Keywords ***
Create Restful Booker Session
    [Documentation]    Opens an HTTP session that every test in the suite can reuse.
    Create Session    ${API_SESSION}    ${API_BASE_URL}

Ping Api
    [Documentation]    Confirms the service is reachable. Note the service returns 201
    ...                (not 200) for a successful health check.
    ${response}=    GET On Session    ${API_SESSION}    /ping    expected_status=201
    RETURN    ${response}

Authenticate
    [Documentation]    Requests an auth token for the given credentials, defaulting to
    ...                the service's published valid admin credentials. The endpoint
    ...                always returns 200 -- even for wrong credentials -- and signals
    ...                failure through the response body instead.
    [Arguments]    ${username}=${BOOKER_USERNAME}    ${password}=${BOOKER_PASSWORD}
    VAR    &{payload}=    username=${username}    password=${password}
    ${response}=    POST On Session    ${API_SESSION}    /auth    json=${payload}
    ...    expected_status=200
    RETURN    ${response}

Get Auth Token
    [Documentation]    Authenticates with the default admin credentials and returns
    ...                just the token string, for tests that only need the token.
    ${response}=    Authenticate
    RETURN    ${response.json()}[token]

Get Auth Headers
    [Documentation]    Builds the Cookie header restful-booker expects on authenticated
    ...                write operations.
    [Arguments]    ${token}
    VAR    &{headers}=    Cookie=token=${token}
    RETURN    ${headers}

Build Booking Payload
    [Documentation]    Assembles a booking request body from individual field values.
    [Arguments]    ${firstname}
    ...    ${lastname}
    ...    ${totalprice}
    ...    ${depositpaid}
    ...    ${checkin}
    ...    ${checkout}
    ...    ${additionalneeds}=${EMPTY}
    VAR    &{dates}=    checkin=${checkin}    checkout=${checkout}
    VAR    &{payload}=
    ...    firstname=${firstname}
    ...    lastname=${lastname}
    ...    totalprice=${totalprice}
    ...    depositpaid=${depositpaid}
    ...    bookingdates=${dates}
    ...    additionalneeds=${additionalneeds}
    RETURN    ${payload}

Create Booking
    [Documentation]    Creates a new booking (no auth required) and returns the raw
    ...                response.
    [Arguments]    ${firstname}
    ...    ${lastname}
    ...    ${totalprice}
    ...    ${depositpaid}
    ...    ${checkin}
    ...    ${checkout}
    ...    ${additionalneeds}=${EMPTY}
    ${payload}=    Build Booking Payload
    ...    ${firstname}    ${lastname}    ${totalprice}    ${depositpaid}
    ...    ${checkin}    ${checkout}    ${additionalneeds}
    ${response}=    POST On Session    ${API_SESSION}    /booking    json=${payload}
    ...    expected_status=200
    RETURN    ${response}

Get Booking By Id
    [Documentation]    Retrieves a single booking resource by id.
    [Arguments]    ${booking_id}    ${expected_status}=200
    ${response}=    GET On Session    ${API_SESSION}    /booking/${booking_id}
    ...    expected_status=${expected_status}
    RETURN    ${response}

Get Booking Ids By Name
    [Documentation]    Lists booking ids matching the given first and last name.
    [Arguments]    ${firstname}    ${lastname}
    VAR    &{params}=    firstname=${firstname}    lastname=${lastname}
    ${response}=    GET On Session    ${API_SESSION}    /booking    params=${params}
    ...    expected_status=200
    RETURN    ${response}

Update Booking
    [Documentation]    Fully replaces a booking's details with the given payload dict
    ...                (build one with Build Booking Payload). Requires a valid auth
    ...                token.
    [Arguments]    ${booking_id}    ${token}    ${payload}    ${expected_status}=200
    ${headers}=    Get Auth Headers    ${token}
    ${response}=    PUT On Session    ${API_SESSION}    /booking/${booking_id}
    ...    json=${payload}    headers=${headers}    expected_status=${expected_status}
    RETURN    ${response}

Partial Update Booking
    [Documentation]    Updates only the given fields of a booking. Requires a valid auth
    ...                token.
    [Arguments]    ${booking_id}    ${token}    &{fields}
    ${headers}=    Get Auth Headers    ${token}
    ${response}=    PATCH On Session    ${API_SESSION}    /booking/${booking_id}
    ...    json=${fields}    headers=${headers}    expected_status=200
    RETURN    ${response}

Delete Booking
    [Documentation]    Deletes a booking. Requires a valid auth token. Note the service
    ...                returns 201 (not 200 or 204) for a successful delete.
    [Arguments]    ${booking_id}    ${token}    ${expected_status}=201
    ${headers}=    Get Auth Headers    ${token}
    ${response}=    DELETE On Session    ${API_SESSION}    /booking/${booking_id}
    ...    headers=${headers}    expected_status=${expected_status}
    RETURN    ${response}
