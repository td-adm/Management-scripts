# Found on https://github.com/td-adm/
#
# Show in window title (can be minimalized) remaining battery life and if machine will be able to work until time set below

# Enter here until what hour you need battery to last (currently 17:00 or 5pm)
$work_until=17;

while ($true) {
$x=[Int]((Get-WmiObject win32_battery).estimatedRunTime);
$d=Get-Date;
$cm=$d.minute+($d.hour*60);
$r=$cm-($work_until*60)+$x;
$h=[Math]::Floor($x /60);
$m=$x % 60;
$rh=[Math]::Floor($r /60);
$rm=[math]::abs($r % 60);
$host.ui.RawUI.WindowTitle=([string]($h) + ":" + "{0:D2}" -f ($m) + " (" + [string]($rh) + ":" + "{0:D2}" -f ($rm) + ")" );
Sleep 3;
}
