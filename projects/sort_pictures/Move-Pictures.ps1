function Get-ShortDateTimeFormat() {
    # Setup DateTime format
    # Extract the default Date/Time formatting from the local computer's "Culture" settings, and then create the format to use when parsing the date/time information pull from AD.
    $CultureDateTimeFormat = (Get-Culture).DateTimeFormat
    $DateFormat = $CultureDateTimeFormat.ShortDatePattern
    $TimeFormat = $CultureDateTimeFormat.ShortTimePattern
    $DateTimeFormat = "$DateFormat $TimeFormat"

    Return $DateTimeFormat
}

function Move-Pictures() {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$True, Position=0)]
        [string]$sourceFoldPath,

        [Parameter(Mandatory=$True, Position=1)]
        [string]$destFoldPath
    )

    # Setup shell objects
    $objShell  = New-Object -ComObject Shell.Application
    $objFolder = $objShell.namespace($sourceFoldPath)

    # Get DateTimeFormat for interpreting system dates
    # $shortDatetimeFormat = Get-ShortDateTimeFormat

    # Set date format for filename dates
    $filenameDateFormat = 'yyyy-MM-dd'

    # Iterate over files
    ForEach($file in $objFolder.Items()) {
        # Reset date to null
        $date = $null

        # This is a magic number. 12 is the int value of the "date taken" property.
        $dateTaken = $objFolder.getDetailsOf($File, 12)


        if ($dateTaken) {
            # I do not know why but there are stupid characters in these dates. Remove them.
            $cleanDate = $dateTaken -Replace "(\u200F|\u200E)", ""

            # Convert date to datetime
            $date = [DateTime]::ParseExact(
                $CleanDate,
                $DateTimeFormat,
                [System.Globalization.DateTimeFormatInfo]::InvariantInfo
            )
        } else {
            $fileName = $objFolder.getDetailsOf($File, 0)
            $m = $fileName -Match "(?<date>\d{4}-\d{2}-\d{2})"
            if ($m) {
                $strDate = $matches.Date

                # Convert date to datetime
                $date = [DateTime]::ParseExact(
                    $strDate,
                    $filenameDateFormat,
                    [System.Globalization.DateTimeFormatInfo]::InvariantInfo
                )
            }
        }

        if (!$date) {
            continue
        }

        $newFoldPath = Join-Path $destFoldPath ("{0}_{1:00}" -f ($date.Year, $date.Month))

        if (!(Test-Path $newFoldPath)) {
            New-Item -Path $newFoldPath -ItemType Directory | Out-Null
        }

        Try {
            $file | Move-Item -Destination "$newFoldPath" -ErrorAction Stop
        } Catch {
            Write-Host "$($file.name) already exists in target location"
        }
    }
}

Move-Pictures @args
