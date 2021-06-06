*** Settings ***
Library    SeleniumLibrary
Library    dctLibrary
Library    DebuggingLibrary
Resource    ../keywords/Gitlab.txt

*** Test Cases ***
Add User To Project In Gitlab
    [Setup]    Run Keywords    Open Gitlab Web
    ...                 AND    Log In For Gitlab    username=109000000    password=qo0hankASDF!
    [Template]    Add Maintainer User To Project
    projectName=FSS2020w_HW_106590042
    projectName=FSS2020w_HW_106590046
    projectName=FSS2020w_HW_106820011
    projectName=FSS2020w_HW_108AEA005
    projectName=FSS2020w_HW_108AEA007
    projectName=FSS2020w_HW_108AEA008
    projectName=FSS2020w_HW_108318165
    projectName=FSS2020w_HW_108599002
    projectName=FSS2020w_HW_109598052
    projectName=FSS2020w_HW_109598061
    projectName=FSS2020w_HW_109598071
    projectName=FSS2020w_HW_109598074
    projectName=FSS2020w_HW_109598085
    projectName=FSS2020w_HW_109598088
    projectName=FSS2020w_HW_109598111
    projectName=FSS2020w_HW_109599006
    [Teardown]    Close Browser

Set Webhooks In Project In Gitlab
    [Setup]    Run Keywords    Open Gitlab Web
    ...                 AND    Log In For Gitlab    username=109000000    password=qo0hankASDF!
    [Template]    Set Webhooks Of Setting
    gitlabProjectName=FSS2020w_HW_106590042    jenkinsProjectName=FSS2021s_106590042_HW
    gitlabProjectName=FSS2020w_HW_106590046    jenkinsProjectName=FSS2021s_106590046_HW
    gitlabProjectName=FSS2020w_HW_106820011    jenkinsProjectName=FSS2021s_106820011_HW
    gitlabProjectName=FSS2020w_HW_108AEA005    jenkinsProjectName=FSS2021s_108AEA005_HW
    gitlabProjectName=FSS2020w_HW_108AEA007    jenkinsProjectName=FSS2021s_108AEA007_HW
    gitlabProjectName=FSS2020w_HW_108AEA008    jenkinsProjectName=FSS2021s_108AEA008_HW
    gitlabProjectName=FSS2020w_HW_108318165    jenkinsProjectName=FSS2021s_108318165_HW
    gitlabProjectName=FSS2020w_HW_108599002    jenkinsProjectName=FSS2021s_108599002_HW
    gitlabProjectName=FSS2020w_HW_109598052    jenkinsProjectName=FSS2021s_109598052_HW
    gitlabProjectName=FSS2020w_HW_109598061    jenkinsProjectName=FSS2021s_109598061_HW
    gitlabProjectName=FSS2020w_HW_109598071    jenkinsProjectName=FSS2021s_109598071_HW
    gitlabProjectName=FSS2020w_HW_109598074    jenkinsProjectName=FSS2021s_109598074_HW
    gitlabProjectName=FSS2020w_HW_109598085    jenkinsProjectName=FSS2021s_109598085_HW
    gitlabProjectName=FSS2020w_HW_109598088    jenkinsProjectName=FSS2021s_109598088_HW
    gitlabProjectName=FSS2020w_HW_109598111    jenkinsProjectName=FSS2021s_109598111_HW
    gitlabProjectName=FSS2020w_HW_109599006    jenkinsProjectName=FSS2021s_109599006_HW
    [Teardown]    Close Browser

Test
    [Documentation]
    ...    chrome.exe --remote-debugging-port=9014 --user-data-dir="C:\testChrome"
    ...    Debug::Execute On Opened Browser
    Debug::Execute On Opened Browser
    Log    1

*** Keywords ***
Add Maintainer User To Project
    [Arguments]    ${projectName}    ${addedUserName}=109000000    ${role}=Maintainer
    Go To Admin Area Menu
    Gitlab::Admin Area::Go To Sidebar Option    Overview    Projects
    Gitlab::Admin Area::Go To Project Detail Page    ${projectName}
    Gitlab::Admin Area::Go To Project Overview    ${projectName}
    Gitlab::Project Page::Go To Sidebar Optain    ${projectName}    Members
    Invite Maintainer Member To Project    addedUserName=${addedUserName}    role=${role}

Set Webhooks Of Setting
    [Arguments]    ${gitlabProjectName}    ${jenkinsProjectName}
    Go To Admin Area Menu
    Gitlab::Admin Area::Go To Sidebar Option    Overview    Projects
    Gitlab::Admin Area::Go To Project Detail Page    ${gitlabProjectName}
    Gitlab::Admin Area::Go To Project Overview    ${gitlabProjectName}
    Gitlab::Project Page::Go To Sidebar Optain    ${gitlabProjectName}    Settings    Webhook
    Add Setting In Webhooks    projectName=${jenkinsProjectName}

Invite Maintainer Member To Project
    [Arguments]    ${addedUserName}    ${role}
    Add Member To Project    ${addedUserName}
    Select From List By Label    //*[@id='access_level']    ${role}
    Click "Invite" Button    ${addedUserName}

Add Member To Project
    [Arguments]    ${userName}
    Input Text    id:s2id_autogen1    ${userName}
    Wait Until Element Is Visible    //*[@class='select2-result-label' and ./*[contains(normalize-space(), '${userName}')]]    timeout=${shortTime}    error=Search member should be visible.
    ${userFullName} =    Get Text    //*[@class='select2-result-label' and ./*[contains(normalize-space(), '${userName}')]]//*[contains(@class, 'full-name')]
    Click Element    //*[contains(@class, 'result-label') and ./*[contains(normalize-space(), '${userName}')]]
    Wait Until Element Is Visible    //*[contains(@class, 'search-choice') and contains(normalize-space(), '${userFullName}')]    timeout=${shortTime}    error=Search member should be visible in the input box.

Click "Invite" Button
    [Arguments]    ${userName}
    Click Element    //*[contains(@class, 'btn-success') and not (contains(@class, 'disabled')) and @value='Invite']
    Wait Until Element Is Visible    //*[@data-qa-selector='member_row']//*[@data-username='${userName}']    timeout=${shortTime}    error=Field should be contain new member.
    Wait Until Element Is Visible    //*[contains(@class, 'flash-container-page')]//*[contains(@class, 'flash-notice mb-2')]//*[normalize-space()='Users were successfully added.']    timeout=${shortTime}    error=Success message should be visible.

Add Setting In Webhooks
    [Arguments]    ${projectName}
    ${webhookURL} =    Set Variable    https://css438:11b9372fa327b2b4201af768449b0d5a7c@css-lab.csie.ntut.edu.tw/jenkins/project/${projectName}
    ${addedWebhook} =    Set Variable    //*[@class='card']//*[normalize-space()='https://css438:11b9372fa327b2b4201af768449b0d5a7c@css-lab.csie.ntut.edu.tw/jenkins/project/${projectName}']
    Input Text    id:hook_url    ${webhookURL}
    "Enable SSL verification" Should Be Selected
    Click Button    //*[@value='Add webhook']
    Wait Until Element Is Visible    ${addedWebhook}    timeout=${normalTime}    error="Webhooks URL" should be visible.
    Click "Test" Dropdowmn Button And Select "Push events"

"Enable SSL verification" Should Be Selected
    Select Checkbox    //*[@id='hook_enable_ssl_verification']
    Checkbox Should Be Selected    //*[@id='hook_enable_ssl_verification']

Click "Test" Dropdowmn Button And Select "Push events"
    Scroll View With Smooth Method
    Click Button    //*[contains(@class, 'btn') and contains(normalize-space(),'Test')]
    Click Element    //*[contains(@class, 'dropdown-menu')]//*[contains(normalize-space(),'Push events')]
    Wait Until Element Is Visible    //*[contains(@class, 'flash-container-page')]//*[normalize-space()='Hook executed successfully: HTTP 200']    timeout=${shortTime}    error=Test message should be visible.