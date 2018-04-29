function Get-ContosoUser {
    [CmdletBinding()]
    param(
        # UPN we will be searching in the domains; this is mandatory.
        [Parameter(Mandatory=$true, ParameterSetName="UserPrincipalName")]
        [ValidateNotNullOrEmpty()]
        [string]$UserPrincipalName,

        # SAM name we will be searching in the domains; this is mandatory.
        [Parameter(Mandatory=$true, ParameterSetName="SamAccountName")]
        [ValidateNotNullOrEmpty()]
        [string]$SamAccountName
    )
    
    process {
        # You'll need to specify your own domains here!
        $Domains = @("CONTOSO1", "CONTOSO2")

        # Switch to determine how to perform search:
            # If we want to search by user principal name, we need to set that as the search criteria.
            # If we want to search by SAM account name, we need to set that as the search criteria.
        switch ($PSCmdlet.ParameterSetName) {
            UserPrincipalName {
                $SearchCriteria = "UserPrincipalName"
                $SearchSpace = $UserPrincipalName
            }

            SamAccountName {
                $SearchCriteria = "SamAccountName"
                $SearchSpace = $SamAccountName
            }
        }

        # For each of the domains listed, we'll get the user based on the search criteria.
        foreach ($Domain in $Domains) {
            $SearchResult = Get-ADUser -Filter {$SearchCriteria -eq $SearchSpace} -Server $Domain
            
            # If user is found, return object as $Output.
            if ($SearchResult) {
                $Output = Get-ADUser -Identity $SearchResult.SamAccountName -Server $Domain
                return $Output
            }
        }

        # If user cannot be found, write error to console.
        if ($Output -eq $null) {
            Write-Error "Cannot locate user '$SearchSpace' in '$($Domains[0])' or '$($Domains[1])' using criteria '$SearchCriteria'."
        }
    }
}
