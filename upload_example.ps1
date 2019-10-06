#Receipt file to upload
$File = "$($env:USERPROFILE)\Dropbox\Apps\Quick File Receipts\viewInvoicePDF.pdf"

#API endpoint as per documentation
$Endpoint = "https://api.quickfile.co.uk/1_2/document/upload"

$CredsFile = Join-Path $PSScriptRoot "quickfile_creds.psd1"
$CredsData = Import-PowerShellDataFile -Path $CredsFile

#Generate unique sumbission number
$SubmissionNumber = [guid]::NewGuid().guid 

#Concatenate required values
$Creds = $CredsData.account_number + $CredsData.api_key + $SubmissionNumber

#Generate MD5 checksum of credentials
$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
$utf8 = New-Object -TypeName System.Text.UTF8Encoding
$Hash = (([System.BitConverter]::ToString($md5.ComputeHash($utf8.GetBytes($Creds)))).replace("-","")).tolower()

#Convert file to a Base64 string.
$oFile = Get-ChildItem -Path $File
$base64string = [Convert]::ToBase64String([IO.File]::ReadAllBytes($oFile.FullName))

#Create header hash
$Header = @{
   "MessageType" = "Request"
   "SubmissionNumber" = $SubmissionNumber
    "Authentication" = @{
        "AccNumber" = $CredsData.account_number
        "MD5Value" = $Hash
        "ApplicationID" = $CredsData.application_id
    }
}
<#
#Example of body for getting Quickfile account details.
$BodyAccount = @{
    "AccountDetails" = @{
        "AccountNumber" = $AccountNumber
        "ReturnVariables" = @{
            "Variable" = @("CompanyName","CompanyNumber","Tel","VatRegNumber")
        }
    }
}
#>

#Generate time stamp
$TimeStamp = [DateTime]::UtcNow | Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"

#Create body hash with arributes and values as per documentation.
#The QuickFile API sandbox is useful in getting these right.
$Body = @{
    "DocumentDetails" = @{
        "FileName" = $oFile.Name
        "EmbeddedFileBinaryObject" = $base64string
        "Type" = @{
            "Receipt" = @{
                "CaptureDateTime" = $TimeStamp
                "ReceiptName" = "Demo"
            }
        }
    }
}

#Merge header and body hashes
$Payload = @{}
$Payload = @{
    "payload" = @{"Header" = $Header; "Body" = $Body }
}

#Convert to JSON
$jsonPayload = $Payload | ConvertTo-Json -Depth 5
#$jsonPayload

#Perform request
$Request = Invoke-WebRequest -Uri $Endpoint -Method Post -Body $jsonPayload

#Convert request into PowerShell custom object.
$oData = $Request.Content | ConvertFrom-Json
$oData

<##>