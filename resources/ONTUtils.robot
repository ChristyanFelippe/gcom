*** Keywords ***
ONT Is Up
    [Arguments]  ${line}
    Should Contain  ${line}  online
    Should Contain  ${line}  working

ONT Is Down
    [Arguments]  ${line}
    Should Contain  ${line}  offline
    Should Contain  ${line}  working

Check ONT Optical Info
    [Arguments]  ${lines}  ${cpe}
    ${return} =  Get Lines Containing String  ${lines}  Voltage
    ${return} =  Split String  ${return}
    ${voltage} =  Get From List  ${return}  4
    Should Be True  ${voltage} >= 1
    Should Be True  ${voltage} <= 5
    ${return} =  Get Lines Containing String  ${lines}  RX Optical
    ${return} =  Split String  ${return}
    ${rx} =  Get From List  ${return}  4
    Should Be True  ${rx} >= -30
    Should Be True  ${rx} <= 0
#    R1 model does not send TX power
    Run Keyword If  'R1' != '${cpe}[model]'
    ...  Check TX power  ${lines}
    ${return} =  Get Lines Containing String  ${lines}  Laser Bias
    ${return} =  Split String  ${return}
    ${bias} =  Get From List  ${return}  4
    Should Be True  ${bias} >= 1
    Should Be True  ${bias} <= 50


Check TX power
    [Arguments]  ${lines}
    ${return} =  Get Lines Containing String  ${lines}  TX Optical
    ${return} =  Split String  ${return}
    ${tx} =  Get From List  ${return}  4
    Should Be True  ${tx} >= 0
    Should Be True  ${tx} <= 10

Configure All ONTs
        FOR  ${cpe}  IN  @{CPEs}
            Telnet.Write  aim ${cpe}[index]
            ${cmd} =  Set Variable  permit sn string-hex ${cpe}[sn] line ${cpe}[line] default line ${cpe}[line]
            Log  ${cmd}
            Telnet.Write  ${cmd}
            ${return} =  Telnet.Read
            Log  ${return}
            Telnet.Write  active
            Telnet.Write  exit
            Sleep  2
            ${return} =  Telnet.Read
            Log  ${return}
        END

Delete All ONTs
        FOR  ${cpe}  IN  @{CPEs}
            Telnet.Write  delete aim ${cpe}[index]
            Telnet.Write  y
            Sleep  2
            ${return} =  Telnet.Read
            Log  ${return}
        END

Check All ONTs Were Deleted
        FOR  ${cpe}  IN  @{CPEs}
            Telnet.Write  show ont brief ${cpe}[index]
            ${return} =  Telnet.Read Until Prompt
            Log  ${return}
            Should Contain  ${return}  Total entries: 0.
        END

Check All ONTs Went Up
        FOR  ${cpe}  IN  @{CPEs}
            Telnet.Write  show ont brief ${cpe}[index]
            ${return} =  Telnet.Read
            ${ont_line} =  Get Lines Containing String  ${return}  ${cpe}[sn]
            Ont Is Up  ${ont_line}
        END


Check All ONTs Went Down
        FOR  ${cpe}  IN  @{CPEs}
            Telnet.Write  show ont brief ${cpe}[index]
            ${return} =  Telnet.Read
            ${ont_line} =  Get Lines Containing String  ${return}  ${cpe}[sn]
            Ont Is Down  ${ont_line}
        END


Get Optical Info All ONTs
        ${return} =  Telnet.Read
        FOR  ${cpe}  IN  @{CPEs}
            Telnet.Write  show ont optical-info ${cpe}[index]
            ${return} =  Telnet.Read
            Check ONT Optical Info  ${return}  ${cpe}
        END

Get ETH Status All ONTs
        ${return} =  Telnet.Read
        FOR  ${cpe}  IN  @{CPEs}
            Telnet.Write  show ont port-status ${cpe}[index] port 1
            ${return} =  Telnet.Read
            Should Contain  ${return}  Port status is Enable
        END

Deactivate All ONTs
    FOR  ${cpe}  IN  @{CPEs}
        Telnet.Write  ont deactive ${cpe}[index]
        ${return} =  Telnet.Read
        Log  ${return}
    END

Activate All ONTs
    FOR  ${cpe}  IN  @{CPEs}
        Telnet.Write  ont active ${cpe}[index]
        ${return} =  Telnet.Read
        Log  ${return}
    END