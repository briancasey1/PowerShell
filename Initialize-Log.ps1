function Initialize-Log () {
    [CmdletBinding()]

    param (
        # Log file path
        [Parameter()]
        [string] $LogPath = "$env:USERPROFILE\Logs",

        # Switch to suppress output to console
        [Parameter()]
        [switch] $SuppressOutput
    )

    process {

        $Date = (Get-Date -Format "yyyy-MM-dd HHmmss")

        $LogFile = "$LogPath\[$Date] - Script Log.log"
    
        if (!(Test-Path $LogFile)) {
            New-Item -Path $LogFile -Force | Out-Null
        }
    
        [string[]] $Header = @(
            "$("#" * 50)"
            ""
            "Executing script:  $($MyInvocation.ScriptName)"
            "Start time:  $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")"
            "Executing account:  $env:USERNAME"
            "Computer name:  $env:COMPUTERNAME"
            ""
            "$("#" * 50)"
        ) | Out-File -LiteralPath $LogFile -Append
    

        if (!($SuppressOutput)) {
            Write-Output "Created log file: $LogFile"
        }
    }
}
