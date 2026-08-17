*** Settings ***
Documentation       Keywords for interacting with the JSONPlaceholder REST API
...                 (https://jsonplaceholder.typicode.com), used to demonstrate API
...                 test coverage alongside the UI test suite.

Library             RequestsLibrary


*** Variables ***
${API_SESSION}      jsonplaceholder
${API_BASE_URL}     https://jsonplaceholder.typicode.com


*** Keywords ***
Create JSONPlaceholder Session
    [Documentation]    Opens an HTTP session that every test in the suite can reuse.
    Create Session    ${API_SESSION}    ${API_BASE_URL}

Get User By Id
    [Documentation]    Retrieves a single user resource by id.
    [Arguments]    ${user_id}    ${expected_status}=200
    ${response}=    GET On Session    ${API_SESSION}    /users/${user_id}
    ...    expected_status=${expected_status}
    RETURN    ${response}

Create Post
    [Documentation]    Creates a new post resource for the given user.
    [Arguments]    ${title}    ${body}    ${user_id}
    VAR    &{payload}=    title=${title}    body=${body}    userId=${user_id}
    ${response}=    POST On Session    ${API_SESSION}    /posts    json=${payload}
    ...    expected_status=201
    RETURN    ${response}

Delete Post
    [Documentation]    Deletes the post with the given id.
    [Arguments]    ${post_id}
    ${response}=    DELETE On Session    ${API_SESSION}    /posts/${post_id}
    ...    expected_status=200
    RETURN    ${response}
