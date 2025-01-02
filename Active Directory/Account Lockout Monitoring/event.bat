@echo off
rem Found on https://github.com/td-adm/
rem 
rem ##################################################
rem
rem Active Directory User Account Lockout monitoring
rem
rem ##################################################
rem 
rem This script logs all account lockouts and is triggered by event 4740.
rem 
rem Schedule this on PDC in your domain (logs all lockouts) by importing Lockout monitoring.xml and placing C:\ScheduledScripts\Account Lockout Monitoring\event.bat (change path in here and xml if needed)
rem 
rem This runs in context of SYSTEM on PDC, so ensure that "Domain Controllers" group have:
rem READ for "C:\ScheduledScripts\Account Lockout Monitoring\event.bat"
rem MODIFY for "C:\ScheduledScripts\Account Lockout Monitoring\ev.txt"
rem MODIFY for "C:\ScheduledScripts\Account Lockout Monitoring\LOG\" (whole directory)
rem 
rem Lockout events are stored in format "DATE TIME;USERNAME;COMPUTERNAME" in file ""C:\ScheduledScripts\Account Lockout Monitoring\LOG\accountlockout-YEAR-MONTH.log"
rem 
rem 
WEVTUtil query-events Security "/q:*[System [(EventID=4740)]]" /f:text /rd:true /c:1 > C:\ScheduledScripts\Account Lockout Monitoring\ev.txt
FOR /F "tokens=2" %%G IN ('type C:\ScheduledScripts\Account Lockout Monitoring\ev.txt ^| find /I ^"Date:^"') DO set timestamp=%%G
FOR /F "tokens=4" %%G IN ('type C:\ScheduledScripts\Account Lockout Monitoring\ev.txt ^| find /I ^"Caller Computer Name:^"') DO set e_comp=%%G
FOR /F "tokens=3" %%G IN ('type C:\ScheduledScripts\Account Lockout Monitoring\ev.txt ^| find /I ^"Account Name:^"') DO set e_user=%%G
set e_date=%timestamp:~0,10%
set e_time=%timestamp:~11,8%

echo %e_date% %e_time%;%e_user:	=%;%e_comp% >> C:\ScheduledScripts\Account Lockout Monitoring\Log\accountlockout-%e_date:~0,7%.log
rem echo %time%
