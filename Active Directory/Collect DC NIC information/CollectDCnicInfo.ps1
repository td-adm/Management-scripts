# Found on https://github.com/td-adm/
#
# This script collects informaiton about all domain controllers network interfaces configuration across multiple domains into one semicolon separated file.
# Collected information includes: NIC Description, NIC Service Name, NIC IP, NIC Mac, NIC Enabled, NIC DNS Domain suffix, NIC DNS list, NIC DNS Registration Enabled, NIC Full DNS Registration Enabled, NIC Index
#
# Script may be used to ensure valid network configuraion in multiple non-trusted forests (please fill "domain_cred.txt" with domain list and credentials)
#
$domains= Get-Content ".\domain_cred.txt" | where {$_ -notmatch '^#'} | ConvertFrom-Csv -Header DomainFQDN,DNS_IP,FullLogin,Pwd;
$out='"Domain FQDN";"Domain Controller";"NIC Description";"NIC Service Name";"NIC IP";"NIC Mac";"NIC Enabled";"NIC DNS Domain suffix";"NIC DNS list";"NIC DNS Registration Enabled";"NIC Full DNS Registration Enabled";"NIC Index"'
ForEach ($domain in $domains) {

$domainFQDN = $domain.DomainFQDN
$domainFQDN
$ip = $domain.DNS_IP
$UserName = $domain.FullLogin
$Password = ConvertTo-SecureString -string $domain.Pwd -AsPlainText -Force;

if ($ip -eq "") {$ip=$domainFQDN}

$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $UserName , $Password

$dc_list= nslookup -type=SRV _ldap._tcp.dc._msdcs.$domainFQDN $ip | % {if ($_ -match "svr hostname" ) { $_.split(" ")[7]}}

$dc_list | % {
$_
$fqdn=$_
$host_ip=  (nslookup $_ $ip )[4].split(" ")[2] 2>$null
gwmi -Class Win32_NetworkAdapterConfiguration -ComputerName $_  -Filter 'MacAddress IS NOT NULL' -credential $Credential | % {$out+="`r`n"+'"'+$domainFQDN+'";"'+$FQDN+'";"'+$_.Description+'";"'+$_.ServiceName+'";"'+$_.IPAddress+'";"'+$_.MACAddress+'";"'+$_.IPEnabled+'";"'+$_.DNSDomain+'";"'+$_.DNSServerSearchOrder+'";"'+$_.DomainDNSRegistrationEnabled+'";"'+$_.FullDNSRegistrationEnabled+'";"'+$_.Index+'"';}
}

}
$out | out-file "nic_report.txt"


