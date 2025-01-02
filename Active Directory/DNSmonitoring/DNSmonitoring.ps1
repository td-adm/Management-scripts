# Found on https://github.com/td-adm/
#
# DNZ Entry monitoring for Active Directory domain integrated DNS
#
#
# This will enable you to monitor DNS object entries existance (skips DNS cache) on your domain controller and will throw error event 32001 if one is missing or 32000 information even if run completed successfully
#
# How to:
# 1. Import a scheduled task DNSMonitoringTask.xml
# 2. Copy DNSmonitoring.ps1 and MonitoredHosts.txt to "C:\ScheduledScripts\DNSmonitoring" (or adjust location in scheduled task)
# 3. Fill out MonitoredHosts.txt with monitored hosts NETBIOS (w/o domain name) and adjust below config for your domain
# 4. Run following command in PowerShell: New-EventLog -Source "TestApp" -LogName Application
# 5. All done, monitoring will be done every 15 min after reboot or after midnight next day


#Config:
$DomainController="DC1.myDomain.net"
$MonitoredZone="myDomain.net"
$MonitoredPartition="DC=ForestDnsZones,DC=myDomain,DC=net"
# In case zone is stored in domain partition use something like "DC=DomainDnsZones,DC=myDomain,DC=net"

$MonitoredHosts=get-content C:\at\DNSmonitoring\MonitoredHosts.txt
$NotExist= $MonitoredHosts| % {if ( -not [ADSI]::Exists("LDAP://$DomainController/DC=$($_),DC=$MonitoredZone,CN=MicrosoftDNS,$MonitoredPartition")) {$_}}
$NotExist | % {Write-EventLog -ComputerName $DomainController -LogName Application -Source "DNS Monitoring" -EventID 32001 -Message "$($_).$MonitoredZone does not exist!" -EntryType Error}
if ($NotExist -eq $null) {Write-EventLog -ComputerName $DomainController -LogName Application -Source "DNS Monitoring" -EventID 32000 -Message "All monitored DNS entries are present." -EntryType Information}