$kuduUrl = "https://<webAppName>.scm.azurewebsites.net"
$endpoint = $kuduUrl + "/api/processes/-1"
Invoke-RestMethod -Headers $authHeader -WebSession $cookieSession -Uri $endpoint -Method Delete