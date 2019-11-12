*** Settings ***
Suite Setup       suite_setup
Suite Teardown
Resource          common_keywords.txt
Library           OperatingSystem
Library           RequestsLibrary
Library           SeleniumLibrary
Library           JSONLibrary
Library           Collections
Library           String
Library           pylibs/helper_functions.py
Library           pylibs/create_file.py

*** Variables ***
${capscli}        python capscli/CAPSCLI.py
${Capsurl}        https://capsv.nokia.com
${TokenAddress}    /93f6cc8e/api/log/gettoken
${auth_token}     Token 1ac2311ddeffb98ab95774ce1c88e493a6b92773
${token_file}     capscli/mytoken.tok
${test_file_path}    capscli/test_files

*** Test Cases ***
Simple Upload attachment
    ${rc}    ${output}=    OperatingSystem.Run And Return Rc And Output    ${capscli} ul --datatypecode " NETACT_CM" --emaillist vishnukant.h@nokia.com --cert ${token_file} --log mylog.log --qa --customer 469657 --product "134-080167_00" --description "Test Description" --purpose "Test Purpose" --service "CARE" --retention 1 --classification 12 --ticketapp "REFRA" ${test_file_path}/README
    Log    ${rc}
    Log    ${output}
    write_to_file    simple upload
    write_to_file    ${output}

load_balancing
    ${rc}    ${output}=    OperatingSystem.Run And Return Rc And Output    ${capscli} ul --datatypecode " NETACT_CM" --emaillist vishnukant.h@nokia.com --cert ${token_file} --log mylog.log --qa --customer 434383 --product "134-080167_00" --description "Test Description" --purpose "Test Purpose" --service "CARE" --retention 1 --classification 12 --ticketapp "REFRA" ${test_file_path}/README ${test_file_path}/test.txt \ \ ${test_file_path}/test1.txt \ ${test_file_path}/test2.txt \ ${test_file_path}/test3.txt \ ${test_file_path}/test4.txt
    Log    ${rc}
    Log    ${output}
    write_to_file    load balancing
    write_to_file    ${output}

upload_multiple file
    ${rc}    ${output}=    OperatingSystem.Run And Return Rc And Output    ${capscli} ul --datatypecode " NETACT_CM" --emaillist vishnukant.h@nokia.com --cert ${token_file} --log mylog.log --qa --customer 469657 --product "134-080167_00" --description "Test Description" --purpose "Test Purpose" --service "CARE" --retention 1 --classification 12 --ticketapp "REFRA" ${test_file_path}/README ${test_file_path}/test.txt
    Log    ${rc}
    Log    ${output}
    write_to_file    upload multiple file
    write_to_file    ${output}

multiple_email_list
    ${rc}    ${output}=    OperatingSystem.Run And Return Rc And Output    ${capscli} ul --datatypecode " NETACT_CM" --emaillist pramoda.devi_b@nokia.com --emaillist kalavani.t@nokia.com --cert ${token_file} --log mylog.log --qa --customer 469657 --product "134-080167_00" --description "Test Description" --purpose "Test Purpose" --service "CARE" --retention 1 --classification 12 --ticketapp "REFRA" ${test_file_path}/README
    log    ${rc}
    log    ${output}
    write_to_file    upload file with multiple email_list
    write_to_file    ${output}

filename_with_special_char
    ${rc}    ${output}=    OperatingSystem.Run And Return Rc And Output    ${capscli} ul --datatypecode " NETACT_CM" --emaillist pramoda.devi_b@nokia.com \ --cert ${token_file} --log mylog.log --qa --customer 469657 --product "134-080167_00" --description "Test Description" --purpose "Test Purpose" --service "CARE" --retention 1 --classification 12 --ticketapp "REFRA" ${test_file_path}/special+char-.txt
    log    ${rc}
    log    ${output}
    write_to_file    File name with special character
    write_to_file    ${output}

upload_without_refra
    ${rc}    ${output}=    OperatingSystem.Run And Return Rc And Output    ${capscli} ul \ --emaillist pramoda.devi_b@nokia.com \ --cert ${token_file} --log mylog.log --qa --customer 469657 --product "833-022515_00" --description "Test Description" --purpose "Test Purpose" --service "CARE" --retention 1 --classification 14 \ ${test_file_path}/test.txt
    log    ${rc}
    log    ${output}
    write_to_file    upload file without refra field
    write_to_file    ${output}

*** Keywords ***
suite_setup
    Create Session    webservice    ${Capsurl}
    ${authorisation}=    Create Dictionary    Authorization=${auth_token}
    &{headers}=    Create Dictionary    Authorization=${auth_token}    Content-Type=application/json
    ${resp}=    Get Request    webservice    ${TokenAddress}    headers=${headers}
    Should Be Equal As Strings    ${resp.status_code}    200
    ${secret_key}=    evaluate    $resp.json()[0].get("secret_key")
    ${access_key}=    evaluate    $resp.json()[0].get("access_key")
    ${auth_token}=    form_access_token    ${access_key}    ${secret_key}    -
    Set Suite Variable    ${auth_token}
    update auth token    ${token_file}    ${auth_token}
