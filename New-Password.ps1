function New-Password {
    <#
    .SYNOPSIS
        Generates a new password.
    .DESCRIPTION
        The New-Password cmdlet generates a unique, strong password using words sourced from a word list and then returns the generated password to the console.

        The word list is located at: C:\Path\To\Your\Word\List.csv
    .EXAMPLE
        New-Password
        This generates a unique, strong password and returns the result to the console.
    .EXAMPLE
        $Password = New-Password
        This generates a unique, strong password and assigns it to the $Password variable.
    .EXAMPLE
        $SecurePassword = ConvertTo-SecureString (New-Password) -AsPlainText -Force
        This generates a unique, strong password, converts it to a secure string, and assigns it to the $SecurePassword variable.
    #>

    $WordListPath = "C:\Path\To\Your\Word\List.csv"
    
    if (Test-Path $WordListPath) {
        $WordList = Import-Csv $WordListPath
    
        $pw1 = Get-Random $WordList.Word; $pw1 = $($pw1.Substring(0,1)).ToUpper() + $pw1.Substring(1)
        $pw2 = Get-Random $WordList.Word; $pw2 = $($pw2.Substring(0,1)).ToUpper() + $pw2.Substring(1)
        $pw3 = Get-Random $WordList.Word; $pw3 = $($pw3.Substring(0,1)).ToUpper() + $pw3.Substring(1)
        $pw4 = Get-Random -Minimum 0 -Maximum 999; $pw4 = $pw4.ToString("00#")
    
        $Password=$pw1+$pw2+$pw3+$pw4+"!"

        return $Password

    } else {
        Write-Error "Cannot find word list CSV! Cannot generate password."
    }
}
