*** Settings ***
Suite Setup       suite_setup
Library           SeleniumLibrary
Library           clipboard

*** Test Cases ***
Access
    Comment    select access
    Click Element    xpath=//*[@id="capsv"]/div[1]/div/div/label/input[1]
    Click Element    id=classRoleId
    comment    classification&role
    Select Radio Button    role    212
    Comment    business justification
    Click Element    id=requestComment
    comment    submit
    Click Element    id=compliancerequestsubmit

*** Keywords ***
suite_setup
    Open Browser    https://capsv.nokia.com/93f6cc8e/compliancerequest    Chrome
    singleSignOn
    Title Should Be    Nokia | Compliance Access Request

singleSignOn
    Click Button    id=silentLogin
    Click Button    id=popUpButton
