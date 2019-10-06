########################################################################
### Modify according to your account application and method.
$AccountNumber = ""
$ApplicationID = ""
$Api_Key = ""
$Endpoint = "https://api.quickfile.co.uk/1_2/system/getaccountdetails"

########################################################################

$SubmissionNumber = [guid]::NewGuid().guid

$Creds = $AccountNumber + $Api_Key + $SubmissionNumber

$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
$utf8 = New-Object -TypeName System.Text.UTF8Encoding
$Hash = (([System.BitConverter]::ToString($md5.ComputeHash($utf8.GetBytes($Creds)))).replace("-","")).tolower()

$Payload = [ordered]@{
    "payload" = @{
        "Header" = @{
            "MessageType" = "Request"
            "SubmissionNumber" = $SubmissionNumber
            "Authentication" = @{
                "AccNumber" = $AccountNumber
                "MD5Value" = $Hash
                "ApplicationID" = $ApplicationID
            }
        }
        # Modify according to your method. See QuickFile documentation
        "Body" = @{
            "AccountDetails" = @{
                "AccountNumber" = $AccountNumber
                "ReturnVariables" = @{
                    "Variable" = @("CompanyName","CompanyNumber","Tel","VatRegNumber") #Add further attributes
                }
            }
        }
    }
}

$jsonPayload = $Payload| ConvertTo-Json -Depth 5

$Request = Invoke-WebRequest -Uri $Endpoint -Method Post -Body $jsonPayload
$oData = $Request.Content | ConvertFrom-Json

$oData.System_GetAccountDetails.Body.AccountDetails

$oData.System_GetAccountDetails.Body.AccountDetails.Tel