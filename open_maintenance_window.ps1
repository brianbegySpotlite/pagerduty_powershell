$mytoken= "[token here]"
$headers =  New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type","application/json")
$headers.Add("Authorization", "Token token=" + $mytoken)
$body =  @"
{
      "maintenance_window": 
      {
      "start_time": "$((Get-Date).ToString("s"))",
        "end_time":"$((Get-Date).Addminutes(15).ToString("s"))",
        "description": "[my desc]",
        "service_ids": [
          "[serviceid1]", "[serviceid2]"
        ]
      },
      "requester_id": "[my requesterid]"
    }
"@
cls 


echo $headers
    echo $body
   
   try{
   $response = Invoke-WebRequest -Method Post -Headers $headers -Body $body -Uri "https://[companyname].pagerduty.com/api/v1/maintenance_windows"
 }
 catch{
 Write-Error "Fail!"
 $result = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($result)
        $responseBody = $reader.ReadToEnd();
         Write-Error  $responseBody
 }
    
 
 