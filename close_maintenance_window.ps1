$mytoken= "[token here]"
$headers =  New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type","application/json")
$headers.Add("Authorization", "Token token=" + $mytoken)
 
try{
   $response = Invoke-WebRequest -Method GET -Headers $headers  -Uri "https://[companyhere].pagerduty.com/api/v1/maintenance_windows/?filter=open"
 }
 catch{
 Write-Error "Fail!"
        $result = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($result)
        $responseBody = $reader.ReadToEnd();
         Write-Error  $responseBody
 }
    
 
$windows = ConvertFrom-Json $response.Content

foreach($window in $windows.maintenance_windows){
echo "starting $($window.start_time) ending $($window.end_time)"
    if (((Get-Date($window.start_time)) -lt (Get-Date)) -and ((Get-Date($window.end_time)) -gt (Get-Date))){
        Write-Warning "Canceling $($window.id)"
            Invoke-WebRequest -Method DELETE -Headers $headers  -Uri "https://[companyhere].pagerduty.com/api/v1/maintenance_windows/$($window.id)"
    }
}
 
