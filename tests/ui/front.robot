*** Settings ***
Documentation       Test on the UI level

Library             SeleniumLibrary

Suite Setup         Open Browser To Library
Suite Teardown      Close All Browsers
Test Teardown       Clear UI State


*** Variables ***
${BASE_URL}         http://localhost:8000/
${BROWSER}          Chrome

${INPUT}            id:title
${ADD_BUTTON}       id:add-button
${RESET_BUTTON}     id:reset-button
${BOOK_LIST}        id:books


*** Test Cases ***
Add Book Via UI
    [Documentation]
    ...    Given the library page is open
    ...    When a user adds a book via the UI
    ...    Then the book should appear in the list

    Input Text    ${INPUT}    Dune
    Click Button    ${ADD_BUTTON}

    Wait Until Page Contains    Dune    timeout=3s
    Page Should Contain    Dune

Clear Library Via UI
    [Documentation]
    ...    Given a book exists in the library
    ...    When the user clicks the clear button
    ...    Then the book should be removed from the UI

    Input Text    ${INPUT}    Dune
    Click Button    ${ADD_BUTTON}

    Wait Until Page Contains    Dune    timeout=3s

    Click Button    ${RESET_BUTTON}

    Wait Until Page Does Not Contain    Dune    timeout=3s
    Page Should Not Contain    Dune


*** Keywords ***
Open Browser To Library
    [Documentation]    Opens the browser at the Book Library application.
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window

Clear UI State
    [Documentation]    Ensures UI is reset between tests (clears library if needed).
    Go To    ${BASE_URL}

    Run Keyword And Ignore Error    Click Button    ${RESET_BUTTON}

    Sleep    0.2s
