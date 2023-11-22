*** Settings ***
Library             String
Library             Telnet

Resource            ../resources/ubuntu/Utils.robot
Resource            ../resources/OLTUtils.robot
Library             ../resources/cmdLines.py

Test Setup          Telnet Login
Test Teardown       Logout with Sleep

*** Test Cases ***
Show User Commands
    FOR  ${command}  IN  @{USR_CMDs}
        ${show_usr} =  Catenate  show  ${command}
        ${file_name} =  build_unique_commands  ${IP}  ${HOSTNAME}  ${EXC_PROMPT}  ${show_usr}  show_usr_cmds.txt
        BuiltIn.Sleep  3
    END
    Compare Files  ${file_name}

System mode commands
    ${file_name} =  build_mode_commands  ${IP}  ${HOSTNAME}  ${EXC_PROMPT}  System mode commands:
    Compare Files  ${file_name}

Exec Commands
    ${file_name} =  build_mode_commands  ${IP}  ${HOSTNAME}  ${EXC_PROMPT}  Privilege EXEC mode commands:
    Compare Files  ${file_name}

Global Switching Commands
    ${file_name} =  build_mode_commands  ${IP}  ${HOSTNAME}  ${CFG_PROMPT}  Global mode-switching commands:
    ${file_name} =  build_mode_commands  ${IP}  ${HOSTNAME}  ${CFG_PROMPT}  Global mode-switching commands:  show
    Compare Files  ${file_name}

Config Commands
    ${file_name} =  build_mode_commands  ${IP}  ${HOSTNAME}  ${CFG_PROMPT}  Global configure mode commands:
    ${file_name} =  build_mode_commands  ${IP}  ${HOSTNAME}  ${CFG_PROMPT}  Global configure mode commands:  show
    Compare Files  ${file_name}

Interface vlan Commands
    ${file_name} =  build_mode_commands  ${IP}  ${HOSTNAME}  ${INTER_VLAN1_PROMPT}  VlanInterface interface configure mode commands:
    ${file_name} =  build_mode_commands  ${IP}  ${HOSTNAME}  ${INTER_VLAN1_PROMPT}  VlanInterface interface configure mode commands:  show
    Compare Files  ${file_name}

Interface ethernet Commands
    ${file_name} =  build_mode_commands  ${IP}  ${HOSTNAME}  ${INTER_ETH1_PROMPT}  Ethernet interface configure mode commands:
    ${file_name} =  build_mode_commands  ${IP}  ${HOSTNAME}  ${INTER_ETH1_PROMPT}  Ethernet interface configure mode commands:  show
    Compare Files  ${file_name}

Interface pon Commands
    ${file_name} =  build_mode_commands  ${IP}  ${HOSTNAME}  ${INTER_PON1_PROMPT}  Pon interface configure mode commands:
    ${file_name} =  build_mode_commands  ${IP}  ${HOSTNAME}  ${INTER_PON1_PROMPT}  Pon interface configure mode commands:  show
    Compare Files  ${file_name}


ONU Commands
    ${file_name} =  build_mode_commands  ${IP}  ${HOSTNAME}  ${ONU1_PROMPT}  Onu interface configure mode commands:
    ${file_name} =  build_mode_commands  ${IP}  ${HOSTNAME}  ${ONU1_PROMPT}  Onu interface configure mode commands:  show
    Compare Files  ${file_name}



*** Keywords ***
Compare Files
    [Arguments]  ${file_name}
    ${file1} =  Get File  ${file_name}
    ${file_name2} =  Catenate  SEPARATOR=  resources/cmds/epon/  ${file_name}
    ${file2} =  Get File  ${file_name2}
    Should Be Equal As Strings  ${file1}  ${file2}

Logout with Sleep
    Telnet Logout
    BuiltIn.Sleep  3