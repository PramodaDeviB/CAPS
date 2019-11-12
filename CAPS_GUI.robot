*** Settings ***
Suite Setup
Suite Teardown
Library           SeleniumLibrary
Library           clipboard
Library           pylibs/get_as_many_cust.py
Library           pylibs/create_file.py
Library           pylibs/write_to_five_cust_file.py

*** Variables ***
${uploadUrl}      https://capsv.nokia.com/93f6cc8e/uploadattachment

*** Test Cases ***
to check labels positive test case
    [Tags]    positive
    [Setup]    suite_setup
    ${var}=    Create List    customerSelectBoxID    productSelectBoxID    classificationSelectBoxID    retention_days    descriptionBoxID
    ...    purposeBoxID    ticketSelBox    ticketBoxIDError    capsservice    emailListError
    ${p}=    Set Variable    ${0}
    : FOR    ${v}    IN    @{var}
    \    Page Should Contain Element    ${v}
    [Teardown]

to check labels negative test case
    [Setup]
    ${var}=    Create List    abcgd    negative
    : FOR    ${v}    IN    @{var}
    \    Page Should Not Contain Element    ${v}
    [Teardown]    tear_down

CAPS GUI FINAL
    [Setup]    suite_setup
    ${cust}=    Create Dictionary
    : FOR    ${i}    IN RANGE    1    6
    \    ${cust}    ${rc}=    customer    ${i}
    \    Should Be Equal    ${rc}    ${0}
    \    Input Text    customerSelectBoxID    ${cust["Customer"]}
    \    Sleep    20s
    \    Select Radio Button    showAllProducts    true
    \    Click Element    productSelectBoxID
    \    sleep    40s
    \    Select Radio Button    product    41242
    \    Input Text    classificationSelectBoxID    ${cust["Classification"]}
    \    Input Text    retention_days    ${cust["Retention_days"]}
    \    Input Text    descriptionBoxID    ${cust["Description"]}
    \    Input Text    purposeBoxID    ${cust["Purpose"]}
    \    Select From List    capsservice    ${cust["Service class"]}
    \    Choose File    id:files    ${exec_dir}/uploads/common_keywords.txt
    \    Click Button    uploadAttachSubmit
    \    Click Button    xpath=//*[@id="WarningAlerts"]/div/div/div[2]/button[1]
    \    sleep    10s
    \    Click Link    //*[@id="detailsPOPup"]/div/div[1]/ul/li[1]/a
    \    sleep    2s
    \    ${url}=    Get Locations
    \    write_to_five_cust_file    ${cust["Customer"]}
    \    write_to_five_cust_file    @{url}[-1]
    \    sleep    10s
    \    Go To    https://capsv.nokia.com/93f6cc8e/uploadattachment
    [Teardown]

to check ready status
    [Setup]    suite_setup
    ${cust}    ${rc}=    customer    ${1}
    Should Be Equal    ${rc}    ${0}
    Input Text    customerSelectBoxID    ${cust["Customer"]}
    Sleep    20s
    Select Radio Button    showAllProducts    true
    Click Element    productSelectBoxID
    sleep    40s
    Select Radio Button    product    41242
    Input Text    classificationSelectBoxID    ${cust["Classification"]}
    Input Text    retention_days    ${cust["Retention_days"]}
    Input Text    descriptionBoxID    ${cust["Description"]}
    Input Text    purposeBoxID    ${cust["Purpose"]}
    Select From List    capsservice    ${cust["Service class"]}
    Choose File    id:files    ${exec_dir}/uploads/common_keywords.txt
    Click Button    uploadAttachSubmit
    Click Button    xpath=//*[@id="WarningAlerts"]/div/div/div[2]/button[1]
    sleep    10s
    Click Link    //*[@id="detailsPOPup"]/div/div[1]/ul/li[1]/a
    sleep    2s
    ${url}=    Get Locations
    Comment    write_to_file    ${cust["Customer"]}
    Comment    write_to_file    @{url}[-1]
    Comment    sleep    10s
    Comment    Page Should Contain    //*[@id="attachmentFiles"]/div/div/div[1]/table/tbody/tr[3]/td[3]/text()
    Go To    ${url}[-1]
    sleep    30s
    Page Should Contain    READY
    [Teardown]    tear_down

check_Product_error
    [Setup]    suite_setup
    ${details}    ${rc}=    customer    ${1}
    Input Text    customerSelectBoxID    ${details['Customer']}
    Sleep    20s
    Input Text    descriptionBoxID    ${details['Description']}
    input text    retention_days    ${details['Retention_days']}
    Input Text    purposeBoxID    ${details['Purpose']}
    Select From List    ticketSelBox    REFRA
    Select From List By Value    capsservice    ${details['Service class']}
    Choose File    files    ${exec_dir}/uploads/test.txt
    click button    uploadAttachSubmit
    Page Should Contain    Product Or Product version is manadatory for Ticket 'REFRA' application. Please select any Product or Product version to proceed
    sleep    5s
    [Teardown]    tear_down

*** Keywords ***
singleSignOn
    Click Button    id=silentLogin
    Click Button    id=popUpButton

suite_setup
    Open Browser    ${uploadUrl}    Chrome
    singleSignOn
    Title Should Be    Nokia | CAPSV Attachment Upload

tear_down
    Close All Browsers
