' Found on https://github.com/td-adm/
'
' Lists members of local server group.
' See code for syntax.
'
if wscript.arguments.count > 0 then

Dim LocalAdminGroup
Set LocalAdminGroup = GetObject("WinNT://" & WScript.Arguments.Item(0) & "/" & WScript.Arguments.Item(1) & ",Group")

Dim WshNetwork, UserDomain
Set WshNetwork = CreateObject("WScript.Network")
UserDomain = WshNetwork.UserDomain
UserDomain = WScript.Arguments.Item(0)

Dim Argument, Group

  Set Group = GetObject("WinNT://" & UserDomain & "/" & WScript.Arguments.Item(1) & ",Group")
 If Group.PropertyCount > 0 Then
WScript.Echo WScript.Arguments.Item(0) & ": Listing " & WScript.Arguments.Item(1)
    For Each mem In Group.Members
      WScript.echo Right(mem.adsPath,Len(mem.adsPath) - 8)
    Next
  Else
    WScript.echo "** Connection failed!"
    WScript.Quit 1
  End If
'  If Not LocalAdminGroup.IsMember(Group.AdsPath) Then
'    LocalAdminGroup.Add(Group.AdsPath)
'  End If


Else
WScript.Echo "Syntax: cscript get_localgrp.vbs <Remote Server> <Local server group> <domain>"
WScript.Echo "Example: cscript get_localgrp.vbs SERVER01 ""Remote Desktop Users"" mydomain.com"
End if
