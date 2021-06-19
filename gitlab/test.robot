*** Settings ***
Library    SeleniumLibrary
Library    dctLibrary
Suite Setup    Open Browser    https://css-gitlab.csie.ntut.edu.tw/users/sign_in    Chrome
Suite Teardown    Run Keywords    Log Off    Close Browser

*** Test Cases ***
Login
    Check Element Availability    //*[@id="user_login"]    username field
    Input Text    //*[@id="user_login"]    gmfcd128@gmail.com
    Check Element Availability    //*[@id="user_password"]    password field
    Input Text    //*[@id="user_password"]    pZ7Sugnw 
    Check Element Availability    //*[@value="Sign in"]    login button
    Click Element    //*[@value="Sign in"]
    #post condition
    Wait Until Element Is Visible    //*[contains(@class, 'header-user-avatar')]    timeout=5 seconds    error=cannot login
    
Create Project
    GoTo New Blank Project Page
    Input Project Info    project_name=12345678    description=Selenium robot is ready to rock. 
        
*** Keywords ***
GoTo New Blank Project Page
    Check Element Availability    //*[@class="blank-state blank-state-link" and @href='/projects/new']    new project option
    Click Element    //*[@class="blank-state blank-state-link" and @href='/projects/new']  
    Check Element Availability    //*[@href="#blank_project"]    blank project option 
    Click Element    //*[@href="#blank_project"]    
    #post condition
    Wait Until Element Is Visible    //*[@value="Create project"]    timeout=3 seconds    error=cannot start new project
    
    
Input Project Info
    [Arguments]    ${project_name}    ${description}
    Check Element Availability    //*[@id="project_name"]    project name field
    Input Text    //*[@id="project_name"]    ${project_name}
    Check Element Availability    //*[@id="project_description"]    project description field
    Input Text    //*[@id="project_description"]    ${description}
    Check Element Availability    //*[@id="project_visibility_level_10"]    project visibility internal button
    Click Element    //*[@id="project_visibility_level_10"]
    Check ELement Availability    //*[@class="form-check-input qa-initialize-with-readme-checkbox"]    create project button
    Click Element    //*[@class="form-check-input qa-initialize-with-readme-checkbox"]
    #post condition
    Element Attribute Value Should Be    //*[@id="project_name"]    value    ${project_name}
    Element Attribute Value Should Be    //*[@id="project_description"]    value    ${description}
    Radio Button Should Be Set To    project[visibility_level]    10
      
    
Log Off
    Check Element Availability    //*[@class="header-user-dropdown-toggle"]    user dropdown toggle
    Click Element    //*[@class="header-user-dropdown-toggle"]
    Check Element Availability    //*[@class="sign-out-link"]    sign out link
    Click Element    //*[@class="sign-out-link"]
    #post condition
    Wait Until Element Is Visible    //*[@id="user_login"]    timeout=3 seconds    error=logout failed

    
Check Element Availability
    [Arguments]    ${locator}    ${alias}
    Wait Until Page Contains Element    ${locator}    timeout=1 second    error="cannot find ${alias}"
    Wait Until Element Is Visible    ${locator}    timeout=1 second    error="${alias} is not visible"
    
    

    
       
    