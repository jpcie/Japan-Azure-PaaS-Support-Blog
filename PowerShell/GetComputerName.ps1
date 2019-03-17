$kuduUrl = "https://<webAppName>.scm.azurewebsites.net"
$endpoint = $kuduUrl + "/api/processes/-1"
$result = Invoke-RestMethod -Headers $authHeader -WebSession $cookieSession -Uri $endpoint -Method Get
$computerName = $result.environment_variables.COMPUTERNAME;