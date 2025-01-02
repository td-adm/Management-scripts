#
# Starts or re-connects to PSsession
#
# Syntax: GoTo-PSSession.ps1 HOSTNAME [LOGIN] [PASSWORD]
# 
#
# Replace the defaults with your preferred credentials
#
param([string] $endpoint, 
      [string] $login = "domain\login",
      [string] $Password = "defaultPassword")

$pass = ConvertTo-SecureString -AsPlainText $Password -Force
$Cred = New-Object System.Management.Automation.PSCredential -ArgumentList $login,$pass

$sess=get-pssession -ComputerName $endpoint -credential $cred


if ($sess -eq $null)
{
"New Session!"
$sess = New-PSSession -ComputerName $endpoint -credential $cred
$sess | Enter-pssession
} else {
"Found $($sess.length) session(s). Reconnecting..."
($sess | disconnect-pssession) | Out-null
($sess[0] |Connect-PSSession)  | ft ID,Name,State,InstanceId
$sess=$sess[0] | Enter-pssession

}
