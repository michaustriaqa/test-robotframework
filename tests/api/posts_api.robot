*** Settings ***
Documentation       API regression coverage for the JSONPlaceholder users and posts
...                 resources, exercised with RequestsLibrary.

Library             Collections
Resource            ../../resources/api/jsonplaceholder.resource

Suite Setup         Create JSONPlaceholder Session

Test Tags           api    regression


*** Test Cases ***
Get Existing User Returns Expected Profile Fields
    [Documentation]    Fetching a known user id returns a 200 response containing the
    ...    expected profile fields.
    [Tags]    smoke
    ${response}=    Get User By Id    1
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    email
    Dictionary Should Contain Key    ${response.json()}    username

Get Non Existing User Returns Not Found
    [Documentation]    Requesting a user id that does not exist returns a 404 response.
    Get User By Id    9999    expected_status=404

Get Multiple Existing Users Successfully
    [Documentation]    A sample of seeded user ids can all be retrieved successfully.
    [Template]    Existing User Should Be Retrievable
    1
    2
    3
    10

Create Post Returns Created Resource
    [Documentation]    Creating a new post returns the created resource with a
    ...    generated id and the submitted title.
    ${response}=    Create Post    title=Robot Framework    body=Automated with RequestsLibrary
    ...    user_id=1
    Should Be Equal As Integers    ${response.status_code}    201
    Dictionary Should Contain Key    ${response.json()}    id
    Should Be Equal As Strings    ${response.json()}[title]    Robot Framework

Delete Post Returns Success
    [Documentation]    Deleting an existing post returns a successful response.
    Delete Post    1


*** Keywords ***
Existing User Should Be Retrievable
    [Documentation]    Verifies that fetching the given user id returns a 200 response.
    [Arguments]    ${user_id}
    ${response}=    Get User By Id    ${user_id}
    Should Be Equal As Integers    ${response.status_code}    200
