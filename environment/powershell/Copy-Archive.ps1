function Copy-Archive() {
    Start-Sleep 10

    $myDocsPath = [Environment]::GetFolderPath('MyDocuments')
    $logFolderPath = Join-Path $myDocsPath 'RoboCopy\Logs'
    $LogFileName = "RoboCopyLog_$((Get-Date).ToString('yyyyMMdd-hhmmss')).log"
    $logFilePath = Join-Path $logFolderPath $logFileName

    <#
    RoboCopy configuration - https://www.pdq.com/blog/hitchhikers-guide-to-robocopy/
        Z: - Source Folder
        X: - Dest Folder
        /COPYALL - Copies Everything for files. Equivalent to /COPY:DATSOU.
        /DCOPY:DAT - Copies Everything for directories
        /MIR - Mirrors a directory tree (equivalent to running both /E and /PURGE).
        /R:5 - Specifies the number of retries on failed copies. (The default is 1 million.)
        /W:2 - Specifies the wait time between retries. (The default is 30 seconds.)
        /ZB - Tries to copy files in restartable mode, but if that fails with an "Access Denied" error, switches automatically to Backup mode.
        /XA:S - Excludes files with the specified attributes.  The following file attributes can be acted upon:
            S - System
        /XD - eXclude any directory with a name matching the listed patterns.
        /XF - eXclude any files with a name matching the listed patterns.
        /XJ - eXclude Junction points and symbolic links. (normally included by default).
        /LOG:file - Redirects output to the specified file, overwriting the file if it already exists.
        /V - Produces verbose output (including skipped files).
        /NP - Turns off copy progress indicator (% copied).
        /NDL - No Directory List - don't log directory names. (Full file paths are displayed instead)
    #>
    $command = "robocopy Z: X: /COPYALL /DCOPY:DAT /MIR /R:5 /W:2 /ZB /XA:S /XD '*RECYCLE.BIN' 'System Volume Information' /XF 'desktop.ini' /XJ /LOG:$logFilePath /V /NP /NDL"

    Start-Process -FilePath 'PowerShell' -Verb 'RunAs' -ArgumentList $Command -WindowStyle 'Hidden'

    while (-not (Test-Path $logFilePath)) {
        Start-Sleep -Milliseconds 100
    }
    Start-Process $logFilePath -WindowStyle Minimized
}

Copy-Archive
