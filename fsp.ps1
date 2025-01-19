# Simulate processes of analysis, sandbox and VM software that some malware will try to evade.
# This just spawns ping.exe with different names (wireshark.exe, vboxtray.exe, ...)
#
# This is the updated version with no system load at all. I might also add some more fake processes in future updates.
# Maintained by NuclearPhoenixx, get updates and fixes on https://github.com/NuclearPhoenixx/fake-sandbox/
#
# Usage (CMD): Powershell -executionpolicy remotesigned -F "C:\Full\Path\To\File\fsp.ps1"

$action = read-host " What do you want to do? (start/stop)"

# Your processes come here:
$fakeProcesses = @("bdoesrv.exe", "kavpf.exe", "mantispm.exe", "avengine.exe", "fspex.exe", "mcshld9x.exe", "mgavrtcl.exe", "avguard.exe", "SavService.exe", "coreServiceShell.exe", "avgrsx.exe", "avgwdsvc.exe", "avgtray.exe", "avpgui.exe", "kavfs.exe", "kavfsrcn.exe", "kavtray.exe", "360rp.exe", "PccNTMon.exe", "avp.exe", "mcshield.exe", "ashServ.exe", "avgemc.exe", "navapsvc.exe", "avgagent.exe", "f-agnt95.exe", "f-prot.exe", "kav.exe", "nod32krn.exe", "ccSvcHst.exe", "SemSvc.exe", "mctray.exe", "MASVC.exe", "bdagent.exe", "avgcsrvx.exe", "fssm32.exe", "AvastSvc.exe", "vsserv.exe", "SysInspector.exe", "ekrn.exe", "ossec-agent.exe", "osqueryd.exe")

# If you type in "start" it will run this:
if ($action -ceq "start") {
    # We will store our renamed binaries into a temp folder
    $tmpdir = [System.Guid]::NewGuid().ToString()
    $binloc = Join-path $env:temp $tmpdir

    # Creating temp folder
    New-Item -Type Directory -Path $binloc
    $oldpwd = $pwd
    Set-Location $binloc

    foreach ($proc in $fakeProcesses) {
        # Copy ping.exe and rename binary to fake one
        Copy-Item c:\windows\system32\ping.exe "$binloc\$proc"

        # Start infinite ping process (invalid ip) that pings every 3600000 ms (1 hour)
        Start-Process ".\$proc" -WindowStyle Hidden -ArgumentList "-t -w 3600000 -4 1.1.1.1"
        write-host "[+] Spawned $proc"
    }

    Set-Location $oldpwd
    write-host ""
    write-host "Press any key to close..."
    cmd /c pause | out-null
}
# If you type in "stop" it will run this:
elseif ($action -ceq "stop") {
    write-host ""
    foreach ($proc in $fakeProcesses) {
        Stop-Process -processname "$proc".Split(".")[0]
        write-host "[+] Killed $proc"
    }
    write-host ""
    write-host "Press any key to close..."
    cmd /c pause | out-null
}
# Else print this:
else {
    write-host ""
    write-host "Bad usage: You need to use either 'start' or 'stop' for this to work!" -foregroundcolor Red
    write-host "Press any key to close..."
    cmd /c pause | out-null

}
