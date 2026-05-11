*** Settings ***
Documentation       Test on the API level

Library             Collections
Library             RequestsLibrary

Suite Setup         Initialize Server
Test Setup          Clean Library


*** Variables ***
${BASE_URL}     http://localhost:8000


*** Test Cases ***
Add Book Successfully
    [Documentation]
    ...    Given an empty library
    ...    When a book is added via the API
    ...    Then the book is stored successfully

    ${response}=    POST On Session    api    /books/Dune

    Should Be Equal As Integers    ${response.status_code}    200
    Should Be Equal    ${response.json()["status"]}    success

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

    VAR    ${books}=    ${response.json()["data"]}

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
    Should Be Equal    ${response.json()["status"]}    success

    ${response}=    GET On Session    api    /books
    VAR    ${books}=    ${response.json()["data"]}

    Should Be Empty    ${books}

Borrow Book Successfully
    [Documentation]
    ...    Given a book exists in the library
    ...    When the book is borrowed by a user
    ...    Then the book is marked as borrowed

    POST On Session    api    /books/Dune

    ${response}=    POST On Session    api    /borrow/Dune/alice

    Should Be Equal As Integers    ${response.status_code}    200
    Should Be Equal    ${response.json()["status"]}    success

    ${response}=    GET On Session    api    /books
    VAR    ${data}=    ${response.json()["data"]}

    Should Be Equal    ${data["Dune"]}    alice

Borrow Non Existing Book Fails
    [Documentation]
    ...    Given no such book exists
    ...    When a user tries to borrow it
    ...    Then API returns not_found

    ${response}=    POST On Session    api    /borrow/Unknown/alice    expected_status=404

    Should Be Equal As Integers    ${response.status_code}    404

Borrow Already Borrowed Book Fails
    [Documentation]
    ...    Given a book is already borrowed
    ...    When another user tries to borrow it
    ...    Then API returns conflict

    POST On Session    api    /books/Dune
    POST On Session    api    /borrow/Dune/alice

    ${response}=    POST On Session    api    /borrow/Dune/bob    expected_status=409

    Should Be Equal As Integers    ${response.status_code}    409

Borrow Empty User Fails
    [Documentation]
    ...    Given a valid book exists
    ...    When user name is empty
    ...    Then API returns bad request

    POST On Session    api    /books/Dune

    ${response}=    POST On Session    api    /borrow/Dune/%20    expected_status=400

    Should Be Equal As Integers    ${response.status_code}    400


*** Keywords ***
Initialize Server
    [Documentation]    Initializes the backend server.
    Create Session    api    ${BASE_URL}

Clean Library
    [Documentation]    Ensures the library starts clean before each test.
    DELETE On Session    api    /books
