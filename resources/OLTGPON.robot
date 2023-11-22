*** Settings ***
Resource            OLTUtils.robot

*** Keywords ***
Enter profile line mode
    Enter config mode
    Telnet.Write  deploy profile line
    Telnet.Set Prompt  ${PROFILE_LINE_PROMPT}

Enter profile vlan mode
    Enter config mode
    Telnet.Write  deploy profile vlan
    Telnet.Set Prompt  ${PROFILE_VLAN_PROMPT}

Enter profile dba mode
    Enter config mode
    Telnet.Write  deploy profile dba
    Telnet.Set Prompt  ${PROFILE_DBA_PROMPT}

Enter profile rule mode
    Enter config mode
    Telnet.Write  deploy profile rule
    Telnet.Set Prompt  ${PROFILE_RULE_PROMPT}


Change VLAN Profile Line Bridge ETH 1
    [Arguments]  ${aim}  ${new-vlan}
    Telnet.Write  aim ${aim}
    Telnet.Write  no flow 1
    Telnet.Write  no mapping 1
    Telnet.Write  mapping 1 port eth 1 vlan ${new-vlan} gemport 1
    Telnet.Write  flow 1 port eth 1 default vlan ${new-vlan}
    Telnet.Write  active
    Telnet.Write  y
    ${return} =  Telnet.Read
    Log  ${return}

Change Translate Profile VLAN
    [Arguments]  ${aim}  ${old-vlan}  ${new-vlan}
    Telnet.Write  aim ${aim}
    Telnet.Write  no translate old-vlan ${old-vlan}
    Telnet.Write  translate old-vlan ${old-vlan} new-vlan ${new-vlan}
    Telnet.Write  active
    Telnet.Write  y
    ${return} =  Telnet.Read
    Log  ${return}

Change Type 4 Max Profile DBA
    [Arguments]  ${aim}  ${new-max}
    Telnet.Write  aim ${aim}
    Telnet.Write  type 4 max ${new-max}
    Sleep  2
    ${return} =  Telnet.Read
    Log  ${return}
    Telnet.Write  active
    Telnet.Write  y
    ${return} =  Telnet.Read
    Log  ${return}
