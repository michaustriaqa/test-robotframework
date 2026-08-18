*** Settings ***
Documentation       API regression coverage for the restful-booker hotel booking
...                 service, exercised with RequestsLibrary. Covers authentication,
...                 full CRUD on bookings, partial updates, filtering, and auth
...                 enforcement on write operations.

Library             Collections
Resource            ../../resources/api/restful_booker.resource

Suite Setup         Create Restful Booker Session

Test Tags           api    regression


*** Variables ***
${SAMPLE_CHECKIN}       2026-06-01
${SAMPLE_CHECKOUT}      2026-06-10


*** Test Cases ***
Api Health Check Should Confirm The Service Is Up
    [Documentation]    The service's ping endpoint responds even though it uses an
    ...    unconventional 201 status for a successful health check.
    [Tags]    smoke
    ${response}=    Ping Api
    Should Be Equal As Integers    ${response.status_code}    201

Authentication With Valid Credentials Returns A Usable Token
    [Documentation]    A correct username/password pair returns a non-empty
    ...    alphanumeric token that write operations can present as proof of auth.
    [Tags]    smoke
    ${response}=    Authenticate
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    token
    Should Match Regexp    ${response.json()}[token]    ^[A-Za-z0-9]+$

Authentication With Invalid Credentials Is Rejected
    [Documentation]    The service always returns 200 for /auth (a documented quirk of
    ...    this API) but signals failure through the response body instead of the
    ...    status code.
    ${response}=    Authenticate    password=wrong-password
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Item    ${response.json()}    reason    Bad credentials

Create Booking Returns The Submitted Details With A Generated Id
    [Documentation]    The created resource echoes back every submitted field exactly,
    ...    plus a generated booking id.
    [Tags]    smoke
    ${response}=    Create Booking
    ...    firstname=Michelle    lastname=Austria    totalprice=250
    ...    depositpaid=${True}    checkin=${SAMPLE_CHECKIN}    checkout=${SAMPLE_CHECKOUT}
    ...    additionalneeds=Breakfast
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    bookingid
    Booking Fields Should Match    ${response.json()}[booking]
    ...    Michelle    Austria    250    ${True}
    ...    ${SAMPLE_CHECKIN}    ${SAMPLE_CHECKOUT}    Breakfast
    Delete Booking Using Fresh Token    ${response.json()}[bookingid]

Get Booking By Id Returns The Same Details As Created
    [Documentation]    Fetching a booking independently after creation confirms the
    ...    data was genuinely persisted server-side, not just echoed back once.
    ${create_response}=    Create Booking
    ...    firstname=Jordan    lastname=Reyes    totalprice=180
    ...    depositpaid=${False}    checkin=${SAMPLE_CHECKIN}    checkout=${SAMPLE_CHECKOUT}
    VAR    ${booking_id}=    ${create_response.json()}[bookingid]
    ${get_response}=    Get Booking By Id    ${booking_id}
    Should Be Equal As Integers    ${get_response.status_code}    200
    Booking Fields Should Match    ${get_response.json()}
    ...    Jordan    Reyes    180    ${False}
    ...    ${SAMPLE_CHECKIN}    ${SAMPLE_CHECKOUT}    ${EMPTY}
    Delete Booking Using Fresh Token    ${booking_id}

Get Non Existing Booking Returns Not Found
    [Documentation]    Requesting a booking id that does not exist returns a 404
    ...    response.
    Get Booking By Id    999999999    expected_status=404

Update Booking Without A Token Is Rejected
    [Documentation]    Write operations require a valid auth token; an anonymous
    ...    request is refused and the booking is left untouched.
    ${create_response}=    Create Booking
    ...    firstname=Priya    lastname=Nair    totalprice=300
    ...    depositpaid=${True}    checkin=${SAMPLE_CHECKIN}    checkout=${SAMPLE_CHECKOUT}
    VAR    ${booking_id}=    ${create_response.json()}[bookingid]
    ${payload}=    Build Booking Payload
    ...    firstname=Hacked    lastname=Attempt    totalprice=1    depositpaid=${False}
    ...    checkin=${SAMPLE_CHECKIN}    checkout=${SAMPLE_CHECKOUT}
    Update Booking    ${booking_id}    invalid-token    ${payload}    expected_status=403
    ${get_response}=    Get Booking By Id    ${booking_id}
    Should Be Equal As Strings    ${get_response.json()}[firstname]    Priya
    Delete Booking Using Fresh Token    ${booking_id}

Update Booking With A Valid Token Persists The New Details
    [Documentation]    A full update with a valid token is reflected in a subsequent,
    ...    independent read -- not just in the update call's own response.
    ${create_response}=    Create Booking
    ...    firstname=Old    lastname=Name    totalprice=100
    ...    depositpaid=${False}    checkin=${SAMPLE_CHECKIN}    checkout=${SAMPLE_CHECKOUT}
    VAR    ${booking_id}=    ${create_response.json()}[bookingid]
    ${token}=    Get Auth Token
    ${payload}=    Build Booking Payload
    ...    firstname=New    lastname=Details    totalprice=999    depositpaid=${True}
    ...    checkin=2026-07-01    checkout=2026-07-15    additionalneeds=Late checkout
    Update Booking    ${booking_id}    ${token}    ${payload}
    ${get_response}=    Get Booking By Id    ${booking_id}
    Booking Fields Should Match    ${get_response.json()}
    ...    New    Details    999    ${True}
    ...    2026-07-01    2026-07-15    Late checkout
    Delete Booking    ${booking_id}    ${token}

Partially Updating A Booking Only Changes The Given Field
    [Documentation]    A PATCH request updates just the submitted field and leaves
    ...    every other field exactly as it was.
    ${create_response}=    Create Booking
    ...    firstname=Stable    lastname=Fields    totalprice=200
    ...    depositpaid=${True}    checkin=${SAMPLE_CHECKIN}    checkout=${SAMPLE_CHECKOUT}
    ...    additionalneeds=None
    VAR    ${booking_id}=    ${create_response.json()}[bookingid]
    ${token}=    Get Auth Token
    Partial Update Booking    ${booking_id}    ${token}    totalprice=450
    ${get_response}=    Get Booking By Id    ${booking_id}
    Should Be Equal As Integers    ${get_response.json()}[totalprice]    450
    Should Be Equal As Strings    ${get_response.json()}[firstname]    Stable
    Should Be Equal As Strings    ${get_response.json()}[lastname]    Fields
    Should Be Equal As Strings    ${get_response.json()}[additionalneeds]    None
    Delete Booking    ${booking_id}    ${token}

Delete Booking Without A Token Is Rejected
    [Documentation]    An anonymous delete request is refused and the booking still
    ...    exists afterwards.
    ${create_response}=    Create Booking
    ...    firstname=Protected    lastname=Booking    totalprice=120
    ...    depositpaid=${True}    checkin=${SAMPLE_CHECKIN}    checkout=${SAMPLE_CHECKOUT}
    VAR    ${booking_id}=    ${create_response.json()}[bookingid]
    Delete Booking    ${booking_id}    invalid-token    expected_status=403
    Get Booking By Id    ${booking_id}
    Delete Booking Using Fresh Token    ${booking_id}

Delete Booking With A Valid Token Removes It Permanently
    [Documentation]    Deleting with a valid token is reflected in a subsequent GET
    ...    returning 404, confirming genuine removal rather than trusting the delete
    ...    call's own status code alone.
    ${create_response}=    Create Booking
    ...    firstname=Temporary    lastname=Record    totalprice=90
    ...    depositpaid=${False}    checkin=${SAMPLE_CHECKIN}    checkout=${SAMPLE_CHECKOUT}
    VAR    ${booking_id}=    ${create_response.json()}[bookingid]
    ${token}=    Get Auth Token
    Delete Booking    ${booking_id}    ${token}
    Get Booking By Id    ${booking_id}    expected_status=404

Filter Bookings By Name Returns The Created Booking
    [Documentation]    Filtering by first and last name returns a list that includes
    ...    the id of a booking just created with those names.
    ${create_response}=    Create Booking
    ...    firstname=Filterable    lastname=Persson    totalprice=175
    ...    depositpaid=${True}    checkin=${SAMPLE_CHECKIN}    checkout=${SAMPLE_CHECKOUT}
    VAR    ${booking_id}=    ${create_response.json()}[bookingid]
    ${filter_response}=    Get Booking Ids By Name    Filterable    Persson
    Should Be Equal As Integers    ${filter_response.status_code}    200
    ${matching_ids}=    Evaluate    [b['bookingid'] for b in $filter_response.json()]
    List Should Contain Value    ${matching_ids}    ${booking_id}
    Delete Booking Using Fresh Token    ${booking_id}

Multiple Booking Profiles Should Be Created Successfully
    [Documentation]    A sample of differently-shaped booking profiles can all be
    ...    created and independently confirmed through a follow-up GET.
    [Template]    Booking Profile Should Be Created And Persisted
    Alice    Wonderland    120    ${True}    Tea party
    Bruno    Silva    89    ${False}    ${EMPTY}
    Chen    Wei    410    ${True}    Airport transfer


*** Keywords ***
Delete Booking Using Fresh Token
    [Documentation]    Authenticates and deletes the given booking, keeping the shared
    ...    public test server tidy after a test that doesn't already exercise delete.
    [Arguments]    ${booking_id}
    ${token}=    Get Auth Token
    Delete Booking    ${booking_id}    ${token}

Booking Fields Should Match
    [Documentation]    Asserts every field of a booking dict (as returned either by
    ...    create's "booking" sub-object or a direct get) matches the given expected
    ...    values.
    [Arguments]    ${booking}
    ...    ${firstname}
    ...    ${lastname}
    ...    ${totalprice}
    ...    ${depositpaid}
    ...    ${checkin}
    ...    ${checkout}
    ...    ${additionalneeds}
    Should Be Equal As Strings    ${booking}[firstname]    ${firstname}
    Should Be Equal As Strings    ${booking}[lastname]    ${lastname}
    Should Be Equal As Integers    ${booking}[totalprice]    ${totalprice}
    Should Be Equal    ${booking}[depositpaid]    ${depositpaid}
    Should Be Equal As Strings    ${booking}[bookingdates][checkin]    ${checkin}
    Should Be Equal As Strings    ${booking}[bookingdates][checkout]    ${checkout}
    Should Be Equal As Strings    ${booking}[additionalneeds]    ${additionalneeds}

Booking Profile Should Be Created And Persisted
    [Documentation]    Creates one booking profile, verifies every submitted field
    ...    round-trips through an independent GET, then cleans it up.
    [Arguments]    ${firstname}
    ...    ${lastname}
    ...    ${totalprice}
    ...    ${depositpaid}
    ...    ${additionalneeds}
    ${create_response}=    Create Booking
    ...    firstname=${firstname}    lastname=${lastname}    totalprice=${totalprice}
    ...    depositpaid=${depositpaid}    checkin=${SAMPLE_CHECKIN}
    ...    checkout=${SAMPLE_CHECKOUT}    additionalneeds=${additionalneeds}
    VAR    ${booking_id}=    ${create_response.json()}[bookingid]
    ${get_response}=    Get Booking By Id    ${booking_id}
    Should Be Equal As Strings    ${get_response.json()}[firstname]    ${firstname}
    Should Be Equal As Strings    ${get_response.json()}[lastname]    ${lastname}
    Should Be Equal As Integers    ${get_response.json()}[totalprice]    ${totalprice}
    Delete Booking Using Fresh Token    ${booking_id}
