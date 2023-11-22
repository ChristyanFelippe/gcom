*** Settings ***
Library             Telnet
Library             String
Library             Collections
Variables           ../resources/variables.py  ${HOSTNAME}
Resource            ../resources/OLTUtils.robot
Resource            ../resources/OLTGPON.robot
Resource            ../resources/ONTUtils.robot
Suite Setup         Login And Load Standard Config
Suite Teardown      Login And Load Standard Config
Test Setup          Telnet Login
Test Teardown       Telnet Logout


*** Test Cases ***
Re-configure ONTs
    Enter profile rule mode
    Run show running config
    Delete All ONTs
    Wait Until Keyword Succeeds  10 sec  5 sec  Check All ONTs Were Deleted
    Run show running config
    Configure All ONTs
    Run show running config
    Wait Until Keyword Succeeds  2 min  10 sec  Check All ONTs Went Up
    Sleep  5

Read status ONTs
    Enter exec mode
    Wait Until Keyword Succeeds  2 min  10 sec  Get ETH Status All ONTs
    Wait Until Keyword Succeeds  2 min  10 sec  Get Optical Info All ONTs
    Sleep  10
    Telnet.Read

Resync ONTs
    Enter config mode
    Deactivate All ONTs
    Run show running config
    Wait Until Keyword Succeeds  2 min  5 sec  Check All ONTs Went Down
    Activate All ONTs
    Wait Until Keyword Succeeds  2 min  5 sec  Check All ONTs Went Up
    Run show running config

Change Profile DBA
    Enter profile dba mode
    Change Type 4 Max Profile DBA  1  100000
    Wait Until Keyword Succeeds  5 min  10 sec  Check All ONTs Went Up
    Run show running config

Change Profile VLAN
    Enter profile vlan mode
    Change Translate Profile VLAN  1  60  50
    Wait Until Keyword Succeeds  5 min  10 sec  Check All ONTs Went Up
    Run show running config

Change Profle Line
    Enter profile line mode
    Change VLAN Profile Line Bridge ETH 1  1  60
    Wait Until Keyword Succeeds  5 min  10 sec  Check All ONTs Went Up
    Run show running config
