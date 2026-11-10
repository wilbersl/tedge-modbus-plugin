*** Settings ***
Resource        ../resources/common.robot

Suite Setup     Setup Service
Suite Teardown  Teardown Device

*** Test Cases ***

Service managed object should support c8y_ServiceCommand
    [Documentation]    Verify that the tedge-modbus-plugin service declares c8y_ServiceCommand
    ...    as a supported operation in its managed object.
    Cumulocity.Should Contain Supported Operations    c8y_ServiceCommand

Service managed object should contain fragment c8y_SupportedServiceCommands
    [Documentation]    Verify that the tedge-modbus-plugin service contains c8y_SupportedServiceCommands
    ...    as a fragment in its managed object.
    Cumulocity.Device Should Have Fragments    c8y_SupportedServiceCommands

Stop Service via Operation
    ${operation}=    Use Service Command
    ...    command="stop"
    Cumulocity.Operation Should Be SUCCESSFUL    ${operation}

Service should be disabled
    Cumulocity.Managed Object Should Have Fragment Values   status\="down"

Start Service via Operation
    ${operation}=    Use Service Command
    ...    command="start"
    Cumulocity.Operation Should Be SUCCESSFUL    ${operation}

Service should be enabled
    Cumulocity.Managed Object Should Have Fragment Values   status\="up"

Restart Service via Operation
    ${operation}=    Use Service Command
    ...    command="restart"
    Cumulocity.Operation Should Be SUCCESSFUL    ${operation}

Disable Service via Operation
    ${operation}=    Use Service Command
    ...    command="disable"
    Cumulocity.Operation Should Be SUCCESSFUL    ${operation}

Enable Service via Operation
    ${operation}=    Use Service Command
    ...    command="enable"
    Cumulocity.Operation Should Be SUCCESSFUL    ${operation}


*** Keywords ***

Use Service Command
    [Arguments]    ${command}
    ${operation}=    Cumulocity.Create Operation
    ...    fragments={"c8y_ServiceCommand":{"serviceType":"service","serviceName":"tedge-modbus-plugin","command":${command}}}
    RETURN    ${operation}