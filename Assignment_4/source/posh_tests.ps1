# PowerShell function to generate the 'tests' portion
function New-TestCase {
    param (
        [Parameter(Mandatory=$true)][string]$Name,
        [Parameter(Mandatory=$true)][string]$Output,
        [Parameter(Mandatory=$true)][double]$Score,
        [double]$MaxScore,
        [string]$Visibility,
        [string]$Status,
        [string]$Number,
        [string[]]$Tags,
        [hashtable]$ExtraData
    )

    # Create a test case object
    $testCase = @{
        name       = $Name
        output     = $Output
        score      = $Score
    }

    if ($MaxScore) { $testCase["max_score"] = $MaxScore }
    if ($Status) { $testCase["status"] = $Status }
    if ($Visibility) { $testCase["visibility"] = $Visibility }
    if ($Number) { $testCase["number"] = $Number }
    if ($Tags) { $testCase["tags"] = $Tags }
    if ($ExtraData) { $testCase["extra_data"] = $ExtraData }

    # Return the test case object
    return $testCase
}

$testsArray = @()

## ** Test 1 - Proper Filename ** 
$submissionFolder = '/autograder/submission/*'
$submission = get-childitem $submissionFolder

if($submission.length -gt 1){
    $testsArray += New-TestCase -Name "Count submissions" -Output "Too many files submitted" -Score -5.0 -Status 'failed'
}

if($submission[0].Name -like "assignment_4.ps1"){
    $testsArray += New-TestCase -Name "Correct Filename" -Output "Your submission contains the correct filename" -Status 'passed'
}

try{
    $testLaunch = . $submission[0].FullName '/autograder/source/data/'
    $testLaunch_notrail = . $submission[0].FullName '/autograder/source/data'

        if($testLaunch -ne $testLaunch_notrail){
            $testsArray += New-TestCase -Name "Trailing slash test" -Output "Your submission produces different results with or without a trailing slash." -Score -5.0 -Status 'failed'

        }

    }catch{
        $testsArray += New-TestCase -Name "**FAIL** - Script Execution" -Output "Your submission did not successfully execute with or without a trailing slash.  This means it cannot be graded and results in a grade of 0." -Score -50.0 -Status 'failed'

    }

if($null -eq $search_directory){
$testsArray = New-TestCase -Name "Search Directory" -Output "No Search Directory variable detected" -Visibility "visible" -Score -5.0 -status 'failed'
}

if($null -eq $email_rows){
$testsArray = New-TestCase -Name "Email Rows" -Output "No email_rows variable detected" -Visibility "visible" -Score -5.0 -status 'failed'

}

$expectedresult = . ./Find-EmailSolution.ps1 '/autograder/source/data/'

if($testLaunch -ne $expectedresult){
    $testsArray = New-TestCase -Name "Output Mismatch" -Output "Test output: $expectedresult\n\nYour Output: $testLaunch" -Visibility "visible" -Score -10.0 -status 'failed'

}
# Combine the test's into an array

# Create the main JSON structure
$results = @{
    #score              = 44.0
    #execution_time     = 136
    output             = "Thank you for your submission."
    output_format      = "simple_format"
    test_output_format = "simple_format"
    test_name_format   = "simple_format"
    visibility         = "visible"
    stdout_visibility  = "visible"
    extra_data         = @{}
    tests              = $testsArray
}

# Convert the results to JSON format
$jsonData = $results | ConvertTo-Json -Depth 4

# Save the JSON data to results.json
#$jsonData | Out-File -Path "results.json" -Encoding utf8
$jsonData