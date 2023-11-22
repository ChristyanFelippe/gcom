*** Settings ***
Library    String
Library    Telnet

Resource    ../resources/ubuntu/Utils.robot
Resource    ../resources/OLTUtils.robot
Library     ../resources/cmdLines.py

Test Setup       Telnet Login
Test Teardown    Logout with Sleep

*** Test Cases ***
Show User Commands
    FOR               ${command}               IN       @{USR_CMDs}
    ${show_usr} =     Catenate                 show     ${command}
    ${file_name} =    build_unique_commands    ${IP}    ${HOSTNAME}    ${EXC_PROMPT}    ${show_usr}    show_usr_cmds.txt
    BuiltIn.Sleep     3
    END
    Compare Files     ${file_name}

Config Commands
    ${file_name} =    build_mode_commands    ${IP}    ${HOSTNAME}    ${CFG_PROMPT}    Global configure (config) mode commands:
    ${file_name} =    build_mode_commands    ${IP}    ${HOSTNAME}    ${CFG_PROMPT}    Global configure (config) mode commands:    show
    Compare Files     ${file_name}

System mode commands
    ${file_name} =    build_mode_commands    ${IP}    ${HOSTNAME}    ${EXC_PROMPT}    System (system) mode commands:
    Compare Files     ${file_name}

Exec Commands
    ${file_name} =    build_mode_commands    ${IP}    ${HOSTNAME}    ${EXC_PROMPT}    Privilege EXEC (privilege) mode commands:
    Compare Files     ${file_name}

Global Switching Commands
    ${file_name} =    build_mode_commands    ${IP}    ${HOSTNAME}    ${CFG_PROMPT}    Global mode-switching (globaljump) mode commands:
    ${file_name} =    build_mode_commands    ${IP}    ${HOSTNAME}    ${CFG_PROMPT}    Global mode-switching (globaljump) mode commands:    show
    Compare Files     ${file_name}



Profile DBA Commands
    ${file_name} =    build_mode_commands    ${IP}    ${HOSTNAME}    ${PROFILE_DBA1_PROMPT}    C_entry_dba (c_entry_dba) mode commands:
    Compare Files     ${file_name}

Profile Line Commands
    ${file_name} =    build_mode_commands    ${IP}    ${HOSTNAME}    ${PROFILE_LINE1_PROMPT}    C_entry_line (c_entry_line) mode commands:
    Compare Files     ${file_name}

Profile VLAN Commands
    ${file_name} =    build_mode_commands    ${IP}    ${HOSTNAME}    ${PROFILE_VLAN1_PROMPT}    C_entry_vlan (c_entry_vlan) mode commands:
    Compare Files     ${file_name}

Profile Rule Commands
    ${file_name} =    build_mode_commands    ${IP}    ${HOSTNAME}    ${PROFILE_RULE1_PROMPT}    C_entry_rule (c_entry_rule) mode commands:
    Compare Files     ${file_name}

Profile WiFi Commands
    ${file_name} =    build_mode_commands    ${IP}    ${HOSTNAME}    ${PROFILE_WIFI1_PROMPT}    C_entry_wifi (c_entry_wifi) mode commands:
    Compare Files     ${file_name}

Profile Unique Commands
    ${file_name} =    build_mode_commands    ${IP}    ${HOSTNAME}    ${PROFILE_UNIQUE1_PROMPT}    C_entry_unique (c_entry_unique) mode commands:
    Compare Files     ${file_name}

Profile Alarm Commands
    ${file_name} =    build_mode_commands    ${IP}    ${HOSTNAME}    ${PROFILE_ALARM1_PROMPT}    C_entry_alarm (c_entry_alarm) mode commands:
    Compare Files     ${file_name}


Interface vlan Commands
    ${file_name} =    build_mode_commands    ${IP}    ${HOSTNAME}    ${INTER_VLAN1_PROMPT}    VlanInterface interface configure (vlanInterface) mode commands:
    ${file_name} =    build_mode_commands    ${IP}    ${HOSTNAME}    ${INTER_VLAN1_PROMPT}    VlanInterface interface configure (vlanInterface) mode commands:    show
    Compare Files     ${file_name}

Interface ethernet Commands
    ${file_name} =    build_mode_commands    ${IP}    ${HOSTNAME}    ${INTER_ETH1_PROMPT}    Ethernet interface configure (ethernet) mode commands:
    ${file_name} =    build_mode_commands    ${IP}    ${HOSTNAME}    ${INTER_ETH1_PROMPT}    Ethernet interface configure (ethernet) mode commands:    show
    Compare Files     ${file_name}

*** Keywords ***
Compare Files
    [Arguments]                   ${file_name}
    ${file1} =                    Get File        ${file_name}
    ${file_name2} =               Catenate        SEPARATOR=       resources/cmds/gpon/    ${file_name}
    ${file2} =                    Get File        ${file_name2}
    Should Be Equal As Strings    ${file1}        ${file2}


Logout with Sleep
    Telnet Logout
    BuiltIn.Sleep    3