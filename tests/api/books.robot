*** Settings ***
Documentation       Test on the API level

Library             Collections
Library             RequestsLibrary
Library             Collections
Library             RequestsLibrary

Suite Setup         Initialize server
Test Setup          Clean Library


*** Variables ***
${BASE_URL}     http://localhost:8000/


*** Test Cases ***
Add Book Successfully
    [Documentation]
    ...    Given an empty library
    ...    When a book is added via the API
    ...    Then the book is stored successfully

    ${response}=    POST On Session    api    /books/Dune

    Should Be Equal As Integers    ${response.status_code}    200
    Should Be True    ${response.json()["success"]}

Add Duplicate Book Fails
    [Documentation]
    ...    Given a book already exists in the library
    ...    When the same book is added again
    ...    Then the API returns a conflict error

    POST On Session    api    /books/Foundation

    ${response}=    POST On Session    api    /books/Foundation    expected_status=409

    Should Be Equal As Integers    ${response.status_code}    409

Get Books
    [Documentation]
    ...    Given multiple books exist in the library
    ...    When the list of books is requested
    ...    Then all stored books are returned

    POST On Session    api    /books/Dune
    POST On Session    api    /books/1984

    ${response}=    GET On Session    api    /books

    Should Be Equal As Integers    ${response.status_code}    200

    ${books}=    Set Variable    ${response.json()}

    Dictionary Should Contain Key    ${books}    Dune
    Dictionary Should Contain Key    ${books}    1984

Clear Library Removes All Books
    [Documentation]
    ...    Given a library with books
    ...    When the library is cleared
    ...    Then no books remain in the system

    POST On Session    api    /books/Dune
    POST On Session    api    /books/1984

    ${response}=    DELETE On Session    api    /books
    Should Be Equal As Integers    ${response.status_code}    200
    Should Be True    ${response.json()["success"]}

    ${resp}=    GET On Session    api    /books
    VAR    ${books}=    ${resp.json()}

    Should Be Empty    ${books}


*** Keywords ***
Initialize Server
    [Documentation]    Initializes the backend server.
    Create Session    api    ${BASE_URL}

Clean Library
    [Documentation]    Ensures the library starts clean before each test.
    DELETE On Session    api    /books
