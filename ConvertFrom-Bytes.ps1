function ConvertFrom-Bytes {
    [CmdletBinding()]
    param(
        # Input file size in bytes
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [int64]$Bytes
    )

    process {
        switch ($Bytes) {
            {$Bytes -gt 1tb} {$Result = "$([math]::Round(($Bytes / 1tb),2)) TB"; break}
            {$Bytes -gt 1gb} {$Result = "$([math]::Round(($Bytes / 1gb),2)) GB"; break}
            {$Bytes -gt 1mb} {$Result = "$([math]::Round(($Bytes / 1mb),2)) MB"; break}
            {$Bytes -gt 1kb} {$Result = "$([math]::Round(($Bytes / 1kb),2)) KB"; break}
            default {$Result = "$($Bytes) B"}
        }

        return $Result
    }
}
