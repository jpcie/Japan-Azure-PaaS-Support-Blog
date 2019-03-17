$kuduUrl = "https://<webAppName>.scm.azurewebsites.net"
$dumpCount = 3
$dumpInterval = 10000
for ($i = 0; $i -lt $dumpCount; $i++)
{
    $outfile = "C:\Diagnostics\" + (Get-Date).ToString("yyyyMMddHHmmss") + ".zip"
    Invoke-RestMethod -Headers $authHeader -WebSession $cookieSession -Uri "$kuduUrl/api/processes/-1/dump?dumpType=2&amp&format=zip" -Method Get -OutFile $outfile
    Start-Sleep -m $dumpInterval
}{\rtf1}