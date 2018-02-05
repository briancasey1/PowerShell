function Set-Password {
    [CmdletBinding()]
    param(
        # UserPrincipalName parameter set
        [Parameter(Mandatory=$true, ParameterSetName="UserPrincipalName")]
        [ValidateNotNullOrEmpty()]
        [string]$UserPrincipalName,

        # SAM account name parameter set
        [Parameter(Mandatory=$true, ParameterSetName="SamAccountName")]
        [ValidateNotNullOrEmpty()]
        [string]$SamAccountName
    )

    process {
        
        # If the UPN parameter is set, we need to grab the AD user using that as the search criteria.
        # If the SAM name parameter is set, we need to grab the AD user using that as the search criteria.
        switch ($PSCmdlet.ParameterSetName) {
            UserPrincipalName { $ADUser = Get-ADUser (Get-User -UserPrincipalName $UserPrincipalName) -Properties CanonicalName,Enabled,pwdLastSet }
            SamAccountName { $ADUser = Get-ADUser (Get-User -SamAccountName $SamAccountName) -Properties CanonicalName,Enabled,pwdLastSet }
        }

        # We'll assign a few variables that we need.
        $FriendlyName = $ADUser.GivenName + " " + $ADUser.Surname

        $Domain = $ADUser.CanonicalName
        $Domain = $Domain.Substring(0, $Domain.IndexOf('/'))

        $PlainPassword = New-Password
        $SecurePassword = ConvertTo-SecureString $PlainPassword -AsPlainText -Force


        # If AD user is disabled, we also need to enable them.
        if (!($ADUser.Enabled)) {
            Set-ADUser $ADUser.SamAccountName -Enabled $true
        }

        # Change password
        Set-ADAccountPassword $ADUser.SamAccountName -NewPassword $SecurePassword -Server $Domain

        # We'll grab the user again, this time with the updated Enabled and pwdLastSet properties.
        $ADUser | Out-Null

        # We'll also create a custom object to format our output.
        $UserObject = [PSCustomObject] @{
            "Name" = $FriendlyName;
            "NewPassword" = $PlainPassword;
            "PasswordLastSet" = [datetime]::FromFileTime($ADUser.pwdLastSet)
            "Enabled" = $ADUser.Enabled
        }

        return $UserObject | Format-List

    }
}
