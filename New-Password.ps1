function New-Password {

    [CmdletBinding()]

    param (
        # Amount of words to generate in password (default is 3).
        [Parameter()]
        [string] $WordCount = 3,

        # Amount of numbers to generate in password (default is 3).
        [Parameter()]
        [string] $NumberCount = 3,

        # Switch parameter that, when specified, will not append a special character to password.
        [Parameter()]
        [switch] $NoSpecialCharacter
    )

    process {
        # Path to the word list the function pulls from.
        $WordListPath = "C:\Users\Brian Casey\Projects\PowerShell\WordList.csv"

        # If word list cannot be found, break here.
        if (!(Test-Path $WordListPath)) {
            Write-Error "Word list not found."
            break
        }

        $WordList = Import-Csv -Path $WordListPath

        # Generates a random word and capitalizes the first letter.
        function RandomWord {
            $Word = Get-Random $WordList.Word; $Word = $($Word.Substring(0,1)).ToUpper() + $Word.Substring(1)

            return $Word
        }

        # We'll set up an array and define a few special characters in it.
        $Characters = @("!", "#", "?")

        # We'll use our RandomWord function while $x is less than or equal to the word count.
        $x = 1; while ($x -le $WordCount) {
            $Password += (RandomWord)
            $x++
        }

        # We'll add a random number (from 0-9) while $x is less than or equal to the number count.
        $x = 1; while ($x -le $NumberCount) {
            $Password += (Get-Random -Maximum 9 -Minimum 0).ToString()
            $x++
        }

        # If the NoSpecialCharacter parameter is not specified, add a random character from the $Characters array.
        if (!($NoSpecialCharacter)) {
            $Password += (Get-Random $Characters)
        }

        return $Password
    }
}
