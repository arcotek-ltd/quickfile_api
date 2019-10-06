# QuickFile PowerShell API example:

  
## Register your App
1. Register for an API key by creating an App: QuickFile > Account Settings > 3rd Party Integration > API
2. Click **Create a new App**.
3. Give your application a name and a description.
4. Select which method(s) you want to use (Ctrl+click for multiple selection) and click **Add selected**.
5. Click **Save Application**.
6. Make a note of your "AccNumber" and "ApplicationID".
7. Click **Click here to return to the App Overview screen**.

## Gather your account details
In order to authenticate, you'll need some details. If you didn't make a note of these details when you created the app, follow:
1. Navigate to Account Settings > 3rd Party Integration > API
2. At the top, to the right of the "Create a new App" button will be your "Account API KEY".
    ![API KEY](https://github.com/arcotek-ltd/quickfile_api/blob/master/images/API_KEY.png)
3. Find your application in the list (probably only one) and to the right click the blue question mark.
4. Make a note of your AppID. **NOTE: THIS IS DIFFERENT TO YOUR ACCOUNT API KEY**.
    ![AppID](https://github.com/arcotek-ltd/quickfile_api/blob/master/images/AppID.png)
5. Get your account number from the top right of the QuickFile browser window (below your company name).

## Authenticating.
1. Copy the contents of `QuickFile_Example.ps1` into a new PowerShell editor session (e.g. ISE or VS Code) or clone the repo to your computer.
2. Complete your details for `$AccountNumber`, `$ApplicationID` and `$Api_Key`. 
      For example:
      ```
      $AccountNumber  =  "123456789"
      $ApplicationID  =  "de3aab49-22e4-14e2-3ef2-a4ef88da81d0"
      $Api_Key  =  "9A22339C-622F-AF2A-D"
      ```
3.  Modify the `Endpoint` parameter according to the QuickFile API [Endpoint documentation][1].
    For example: `$Endpoint  =  "https://api.quickfile.co.uk/1_2/system/getaccountdetails"`
4. Modify the `$Payload`'s `Body` data according to the method you are using.

## Execute
Try running the script.

---
###### Note
<span style="color:grey; font-size:0.1em;">The API KEY and ApplicationID are fictitious.</span>


[1]: https://api.quickfile.co.uk/#2