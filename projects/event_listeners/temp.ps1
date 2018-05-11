function main() {
    Get-EventSubscriber | Where-Object {$_.SourceIdentifier -eq "ResultsFileCreated"} | Unregister-Event; clear

    $watcher = New-Object IO.FileSystemWatcher
    $watcher.Path = ("C:\Users\Patrick\Dropbox\Automation\DocketRulesEngine\Results\History")
    $watcher.IncludeSubdirectories = $false
    $watcher.EnableRaisingEvents = $true

    Register-ObjectEvent $watcher Created -SourceIdentifier "ResultsFileCreated" -Action {
        $dest = "C:\Users\Patrick\Dropbox\Files for Steve\Results Files"
        $logFile = Join-Path $dest LogFile.txt
        $errorLog = Join-Path $dest ErrorLog.txt

        try {
            if ($EventArgs.Name -match "output(?<date>\d{8})-.*\.xlsx") {
                $newDest = Join-Path $dest $Matches.Date
                if (!(Test-Path $newDest)) { New-Item $newDest -ItemType Directory -Force }
                "$($event.TimeGenerated) - Copying $($EventArgs.Name)" >> $logFile
                Copy-Item -Path $eventArgs.FullPath -Destination "$newDest"
            }
        } catch {
            $Error >> $logFile
            $Error >> $errorLog
            $Error.Clear()
        }
    }
}

main
