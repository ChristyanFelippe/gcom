*** Settings ***
Library             String
Library             Telnet

Resource            ../resources/ubuntu/Utils.robot
Resource            ../resources/OLTUtils.robot
Library             ../resources/cmdLines.py

Test Setup          Telnet Login
Test Teardown       Telnet Logout

*** Test Cases ***
Default access and clear config
    Enter exec mode
    Clear startup config and reboot
    Telnet.Close All Connections
    Sleep  10
    Wait Until Keyword Succeeds  3 min  5 sec  Telnet Login
    Telnet.Write  \n
    Telnet.Read Until Prompt

Version Info
    Telnet.Write  show version
    ${return} =  Telnet.Read
    Log  ${return}
    ${version} =  Get Lines Containing String  ${return}  Software version
    Should Contain  ${version}  ${SOFTWARE_VERSION}
    ${version} =  Get Lines Containing String  ${return}  Hardware version
    Should Contain  ${version}  ${HARDWARE_VERSION}
    ${version} =  Get Lines Containing String  ${return}  Bootrom version
    Should Contain  ${version}  ${BOOTROM_VERSION}
    ${version} =  Get Lines Containing String  ${return}  EPLD version
    Should Contain  ${version}  ${EPLD_VERSION}

Device Types
    Enter config mode
    Telnet.Write  ont upgrade auto-reboot include device-type ?
    ${return} =  Telnet.Read Until Prompt
    Log  ${return}
    ${return} =  Split To Lines  ${return}  0  -2
    Should Be Equal  ${return}  ${DEVICE_TYPES}

Config File
    Enter exec mode
    Load configuration and reboot  ${TA_IP}  ${CFG_FILE}
    Wait Until Keyword Succeeds  3 min  5 sec  Telnet Login
    Enter exec mode
    Upload configuration  ${TA_IP}  ${NEW_CFG_FILE}
    ${file1} =  Get File  ${CFG_FILE_PATH}
    ${file2} =  Get File  ${NEW_CFG_FILE_PATH}
    Should Be Equal As Strings  ${file1}  ${file2}