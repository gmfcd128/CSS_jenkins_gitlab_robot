*** Settings ***
Library    SeleniumLibrary
Library    dctLibrary
Library    DebuggingLibrary
Resource    ../keywords/Variable.txt
Resource    ../keywords/Jenkins.txt
Resource    ../keywords/common.txt
Suite Setup    Run Keywords    Open Jenkins Web
    ...                 AND    Log In For Jenkins    &{jenkinsAdministrator}

*** Test Cases ***
Set Shell In Jenkins
    [Template]    To Do Job Shell Instruction
    studentId=106590042
    studentId=106590046
    studentId=106820011
    studentId=108AEA005
    studentId=108AEA007
    studentId=108AEA008
    studentId=108318165
    studentId=108599002
    studentId=109598052
    studentId=109598061
    studentId=109598071
    studentId=109598074
    studentId=109598085
    studentId=109598088
    studentId=109598111
    studentId=109599006
    studentId=109998410
    [Teardown]    Close Browser

Open "Disable This Project" Of Configure
    [Documentation]
    ...    To close the jenkins job
    [Template]    To Open "Disable This Project" Checkbox
    studentId=106590042
    studentId=106590046
    studentId=106820011
    studentId=108AEA005
    studentId=108AEA007
    studentId=108AEA008
    studentId=108318165
    studentId=108599002
    studentId=109598052
    studentId=109598061
    studentId=109598071
    studentId=109598074
    studentId=109598085
    studentId=109598088
    studentId=109598111
    studentId=109599006
    studentId=109998410
    [Teardown]    Close Browser

Close "Permission to Copy Artifact" Checkbox Of Configure
    [Documentation]
    ...    To close the "Permission to Copy Artifact" of job configure
    [Template]    To Close "Permission to Copy Artifact" Checkbox
    studentId=106590042
    studentId=106590046
    studentId=106820011
    studentId=108AEA005
    studentId=108AEA007
    studentId=108AEA008
    studentId=108318165
    studentId=108599002
    studentId=109598052
    studentId=109598061
    studentId=109598071
    studentId=109598074
    studentId=109598085
    studentId=109598088
    studentId=109598111
    studentId=109599006
    studentId=109998410
    [Teardown]    Close Browser

Add "Copy Artifacts From Another Project" Of Job Configure
    [Template]    To Add "Copy Artifacts From Another Project"
    studentId=106590042
    studentId=106590046
    studentId=106820011
    studentId=108AEA005
    studentId=108AEA007
    studentId=108AEA008
    studentId=108318165
    studentId=108599002
    studentId=109598052
    studentId=109598061
    studentId=109598071
    studentId=109598074
    # studentId=109598085
    studentId=109598088
    studentId=109598111
    studentId=109599006
    studentId=109998410
    [Teardown]    Close Browser

Add Post-build Actions Of Job Configure
    [Template]    To Set Parsing Rule
    studentId=106590042
    studentId=106590046
    studentId=106820011
    studentId=108AEA005
    studentId=108AEA007
    studentId=108AEA008
    studentId=108318165
    studentId=108599002
    studentId=109598052
    studentId=109598061
    studentId=109598071
    studentId=109598074
    studentId=109598085
    studentId=109598088
    studentId=109598111
    studentId=109599006
    studentId=109998410
    [Teardown]    Close Browser

*** Keywords ***
To Open "Disable This Project" Checkbox
    [Arguments]    ${studentId}
    Open "Disable this project"    jobname=FSS2021s_${studentId}_HW
    Open "Disable this project"    jobname=FSS2021s_${studentId}_TA

To Do Job Shell Instruction
    [Arguments]    ${studentId}
    Set HW Shell    jobname=FSS2021s_${studentId}_HW    shellFile=HW_Shell.txt
    Set TA Shell    jobname=FSS2021s_${studentId}_TA    shellFile=TA_Shell.txt

To Close "Permission to Copy Artifact" Checkbox
    [Arguments]    ${studentId}
    Close "Permission to Copy Artifact"    jobname=FSS2021s_${studentId}_HW
    Close "Permission to Copy Artifact"    jobname=FSS2021s_${studentId}_TA

To Set Parsing Rule
    [Arguments]    ${studentId}
    Set Parsing Rule    jobname=FSS2021s_${studentId}_HW
    Set Parsing Rule    jobname=FSS2021s_${studentId}_TA

To Add "Copy Artifacts From Another Project"
    [Arguments]    ${studentId}
    Add "Copy Artifacts From Another Project"    jobname=FSS2021s_${studentId}_TA

Set HW Shell
    [Arguments]    ${jobname}    ${shellFile}
    Go To Job Configure    jobname=${jobname}
    Jenkins::Job Configure::Set Job Shell Instruction    ${jobname}    ${shellFile}
    Click "Save" Button Of Configure    ${jobname}

Set TA Shell
    [Arguments]    ${jobname}    ${shellFile}
    Go To Job Configure    jobname=${jobname}
    Jenkins::Job Configure::Set Job Shell Instruction    ${jobname}    ${shellFile}
    Click "Save" Button Of Configure    ${jobname}

Set Parsing Rule
    [Arguments]    ${jobname}
    Go To Job Configure    ${jobname}
    Jenkins::Job Configure::Set Parsing Rule    ${jobname}
    Click "Save" Button Of Configure    ${jobname}

Add "Copy Artifacts From Another Project"
    [Arguments]    ${jobname}
    Go To Job Configure    jobname=${jobname}
    Jenkins::Job Configure::Click Tab    Build
    Jenkins::Job Configure::Make Box    Add build step    Copy artifacts from another project
    Jenkins::Job Configure::Set "Copy artifacts from another project"    projectName=FSS2020w_Copy_Test_Cases    whichBuild=Copy from WORKSPACE of latest completed build    artifactsToCopy=code/test/
    Click "Save" Button Of Configure    ${jobname}

Jenkins::Job Configure::Set Job Shell Instruction
    [Documentation]
    ...    If you want to add the shell, use "Jenkins::Job Configure::Make Box    Add build step    Execute shell".
    [Arguments]    ${jobname}    ${testFile}
    Jenkins::Job Configure::Click Tab    Build
    Sleep    1s
    Jenkins::Job Configure::Input Shell Instruction    ${testFile}

Jenkins::Job Configure::Set Parsing Rule
    [Arguments]    ${jobname}
    Jenkins::Job Configure::Click Tab    Post-build Actions
    Jenkins::Job Configure::Make Box    Add post-build action    Console output (build log) parsing
    Jenkins::Job Configure::Click Tab    Post-build Actions
    Jenkins::Job Configure::Select Parsing Rule    Default Parsing Rule

Close "Permission to Copy Artifact"
    [Arguments]    ${jobname}
    Go To Job Configure    ${jobname}
    ${isSelectedCheckbox} =    Run Keyword And Return Status    Jenkins::Job Configure::Wait until "Projects to allow copy artifact" Field Is Visible
    Run Keyword If    ${isSelectedCheckbox}    Jenkins::Job Configure::Click "Permission to Copy Artifact" Checkbox
    Jenkins::Job Configure::Wait until "Projects to allow copy artifact" Field Is Not Visible
    [Teardown]    Click "Save" Button Of Configure    ${jobname}

Go To Job Configure
    [Arguments]    ${jobname}
    Jenkins::Search Box To Search And Access To Job Page    jobname=${jobname}
    Jenkins::Click Left Bar Option    Configure

Jenkins::Job Configure::Make Box
    [Arguments]    ${addBox}    ${option}
    ${addButton} =    Set Variable    //*[@type='button' and normalize-space()='${addBox}']
    ${hoverAddButton} =    Set Variable    //*[contains(@class, yui-menu-button-hover)]${addButton}
    ${menu} =    Set Variable    //*[contains(@class, 'yui-button-menu') and contains(@class, 'visible')]
    ${menuOption} =    Set Variable    ${menu}//*[contains(@class, 'yuimenuitem')]//*[normalize-space()='${option}']
    ${menuSelectedOption} =    Set Variable    ${menu}//*[contains(@class, 'yuimenuitem') and contains(@class, 'selected')]//*[normalize-space()='${option}']
    ${optionBox} =    Set Variable    //*[@class='repeated-chunk']//*[contains(@class, 'dd-handle') and normalize-space()='${option}']
    Wait Until Element Is Visible On Page    ${addButton}    timeout=${shortTime}    error="${addBox}" button of "Configure" should be visible.
    Mouse Over    ${addButton}
    Wait Until Element Is Visible On Page    ${hoverAddButton}    timeout=${shortTime}    error="${addBox}" hover button of "Configure" should be visible.
    Click Button    ${hoverAddButton}
    Wait Until Element Is Visible On Page    ${menu}    timeout=${shortTime}    error=Menu of "${addBox}" should be visible.
    Mouse Over    ${menuOption}
    Wait Until Element Is Visible On Page    ${menuSelectedOption}    timeout=${shortTime}    error=${option} should be visible.
    Click Element    ${menuSelectedOption}
    Wait Until Element Is Visible On Page    ${optionBox}    timeout=${shortTime}    error=${option} box should be visible.

Jenkins::Job Configure::Select Parsing Rule
    [Arguments]    ${rule}
    ${parsingRulesField} =    Set Variable    //*[@class='setting-name' and normalize-space()='Select Parsing Rules']
    ${selectedList} =    Set Variable    //*[normalize-space()='Select Parsing Rules']/following-sibling::*[@class='setting-main']//*[contains(@class, 'setting-input')]
    Wait Until Element Is Visible On Page    ${parsingRulesField}    timeout=${shortTime}    error="Select Parsing Rules" option selection should be visible.
    Select From List By Label    ${selectedList}    ${rule}

Jenkins::Job Configure::Set "Copy artifacts from another project"
    [Arguments]    ${projectName}=${Empty}    ${whichBuild}=${Empty}    ${artifactsToCopy}=${Empty}    ${artifactsNotToCopy}=${Empty}    ${targetDirectory}=${Empty}    ${parameterFilters}=${Empty}
    Input Text    //*[@class='setting-name' and normalize-space()='Project name']/following-sibling::*[@class='setting-main']//*[contains(@class, 'setting-input')]    ${projectName}
    Select From List By Label    //*[@class='setting-name' and normalize-space()='Which build']/following-sibling::*[@class='setting-main']//*[contains(@class, 'dropdownList')]    ${whichBuild}
    Input Text    //*[@class='setting-name' and normalize-space()='Artifacts to copy']/following-sibling::*[@class='setting-main']//*[contains(@class, 'setting-input')]    ${artifactsToCopy}
    Input Text    //*[@class='setting-name' and normalize-space()='Artifacts not to copy']/following-sibling::*[@class='setting-main']//*[contains(@class, 'setting-input')]    ${artifactsNotToCopy}
    Input Text    //*[@class='setting-name' and normalize-space()='Target directory']/following-sibling::*[@class='setting-main']//*[contains(@class, 'setting-input')]    ${targetDirectory}
    Input Text    //*[@class='setting-name' and normalize-space()='Parameter filters']/following-sibling::*[@class='setting-main']//*[contains(@class, 'setting-input')]    ${parameterFilters}

Jenkins::Job Configure::Click "Mark Build Failed On Error" Checkbox
    Jenkins::Job Configure::Click Tab    Post-build Actions
    Sleep    1s
    Click Element    //*[@class='setting-name' and normalize-space()='Mark build Failed on Error']/following-sibling::*[@class='setting-main']//*[@type='checkbox']
    Sleep    1s

Open "Disable this project"
    [Arguments]    ${jobname}
    Go To Job Configure    ${jobname}
    Jenkins::Job Configure::Wait until "Disable this project" Field Is Visible
    Jenkins::Job Configure::Click "Disable this project" Checkbox
    Sleep    1s    #FIXEME
    [Teardown]    Click "Save" Button Of Configure    ${jobname}