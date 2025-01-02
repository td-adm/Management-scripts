' Found on https://github.com/td-adm/
'
' Adds group in domain to local group on server.
' See code for syntax.
'
if wscript.arguments.count > 0 then
WScript.Echo WScript.Arguments.Item(0) & ": Adding " & WScript.Arguments.Item(1) & " to " & WScript.Arguments.Item(2)
Dim LocalAdminGroup
Set LocalAdminGroup = GetObject("WinNT://" & WScript.Arguments.Item(0) & "/" & WScript.Arguments.Item(2) & ",Group")

Dim WshNetwork, UserDomain
Set WshNetwork = CreateObject("WScript.Network")
UserDomain = WshNetwork.UserDomain
UserDomain = WScript.Arguments.Item(3)

Dim Argument, Group

  Set Group = GetObject("WinNT://" & UserDomain & "/" & WScript.Arguments.Item(1) & ",Group")
  If Not LocalAdminGroup.IsMember(Group.AdsPath) Then
    LocalAdminGroup.Add(Group.AdsPath)
  End If


Else
WScript.Echo "Syntax: cscript add_localgrp.vbs <Remote Server> <Domain Group> <Local server group> <domain>"
WScript.Echo "Example: cscript add_localgrp.vbs SERVER01 DomainLocal-RDPusersSERVER01 ""Remote Desktop Users"" mydomain.com"
End if
