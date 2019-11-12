*** Settings ***
Suite Setup       suite_setup
Library           RequestsLibrary
Library           SeleniumLibrary
Library           JSONLibrary
Library           Collections
Library           String
Resource          common_keywords.txt
Library           pylibs/sshconnect.py
Library           pylibs/get_id.py
Library           pylibs/timestamp.py
Library           pylibs/grpname.py

*** Variables ***
${Base_SF_URL}    https://nokia--qcrm2.my.salesforce.com/    # base url for SF
${Auth_URL}       https://test.salesforce.com/services/    # authorisation url
&{credentials}    client_id=3MVG9Vik22TUgUpgvHWYuPXEkSZ1wq9vuEZUoMBpucdKXBmK9K1GXQGMXFmyI9N_XLjTG4CBpaM4tto2tNbqw    grant_type=password    client_secret=9A94CE76C8D142543BD26A3D1BB41F8B59BDD2FF525FB7D44E7F69A03BBFBC58    username=capsinterfaceuser.nokia@salesforce.com.qcrm2    password=Nokia123

*** Test Cases ***
GET_AUTH_TOKEN
    [Setup]
    Create Session    webservice    ${Auth_URL}    proxies=${proxies}
    &{headers}=    Create Dictionary    Content-Type=application/x-www-form-urlencoded
    &{data}=    Create Dictionary    grant_type=password    client_id=3MVG9Vik22TUgUpgvHWYuPXEkSZ1wq9vuEZUoMBpucdKXBmK9K1GXQGMXFmyI9N_XLjTG4CBpaM4tto2tNbqw    client_secret=9A94CE76C8D142543BD26A3D1BB41F8B59BDD2FF525FB7D44E7F69A03BBFBC58    username=capsinterfaceuser.nokia@salesforce.com.qcrm2    username=capsinterfaceuser.nokia@salesforce.com.qcrm2
    ...    password=Nokia123
    ${resp}=    Post Request    webservice    /oauth2/token    data=${data}    headers=${headers}
    Should Be Equal As Strings    ${resp.status_code}    200
    ${token}=    evaluate    $resp.json().get("access_token")
    ${bearer_token}=    Strip String    ${token}
    Set Suite Variable    ${bearer_token}
    ${auth_token}=    Catenate    Bearer    ${bearer_token}
    Set Suite Variable    ${auth_token}

SF_00_GETNEWUSERS
    ${authorisation}=    Create Dictionary    Authorization=${auth_token}
    &{headers}=    Create Dictionary    Authorization=${auth_token}    Content-Type=application/octetstream
    Create Session    sf_new_users    ${Base_SF_URL}    proxies=${proxies}
    ${resp}=    Get Request    sf_new_users    /services/apexrest/GetNewUsers/startdatetime=2019-04-16T13:50:58.000Z/enddatetime=2019-07-31T23:50:58.000Z    headers=${headers}
    Log    ${resp.json()}

GET_SSH
    ${attach_id}=    get_id
    Comment    SSH execute Cmd    ${client}    cd /project/capsapi-dev/logapi/;source /project/capsapi-dev/logapi/logapi-dev/bin/activate;python manage.py --help
    Comment    SSH execute Cmd    ${client}    cd /project/capsapi-dev/logapi/;source /project/capsapi-dev/logapi/logapi-dev/bin/activate;python manage.py --help
    ${out}    ${rc}=    SSH execute Cmd    ${client}    grep ${attach_id} /project/log/capsrt3.dena.log
    Should Be Equal As Integers    ${rc}    ${0}

SF_timestamp
    ${start}    ${end}    get_timestamp
    ${authorisation}=    Create Dictionary    Authorization=${auth_token}
    &{headers}=    Create Dictionary    Authorization=${auth_token}    Content-Type=application/octetstream
    Create Session    sf_new_users    ${Base_SF_URL}    proxies=${proxies}
    ${resp}=    Get Request    sf_new_users    /services/apexrest/GetNewUsers/startdatetime=${start}/enddatetime=${end}    headers=${headers}
    Log    ${resp.json()}

SF_chk_SECDefault
    ${start}    ${end}    get_timestamp
    ${authorisation}=    Create Dictionary    Authorization=${auth_token}
    &{headers}=    Create Dictionary    Authorization=${auth_token}    Content-Type=application/octetstream
    Create Session    sf_new_users    ${Base_SF_URL}    proxies=${proxies}
    ${resp}=    Get Request    sf_new_users    /services/apexrest/GetNewUsers/startdatetime=${start}/enddatetime=${end}    headers=${headers}
    Log    ${resp.json()}
    findGroupNames    ${resp.json()}

*** Keywords ***
suite_setup
    ${client}=    ssh connect    10.135.198.92    root    %aw{EA3Pp~IM
    Set Suite Variable    ${client}
    &{proxies}=    Create Dictionary    http=http://87.254.212.122:8080    https=https://87.254.212.122:8080
    Set Suite Variable    &{proxies}
    Comment    Create Session    webservice    ${Auth_URL}    proxies=${proxies}
    Comment    ${alias_name}=    webservice
    Comment    Set Suite Variable    ${alias_name}
