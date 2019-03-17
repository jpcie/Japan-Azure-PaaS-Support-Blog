$instanceId = "a4951240a2a973f8aa3fb4a433eabf17c8d5b37bb6f444edb7d6e21bd160d35e"
$kuduUrl = "https://<webAppName>.scm.azurewebsites.net"
$cookieSession = New-Object -TypeName Microsoft.PowerShell.Commands.WebRequestSession
$myCookie = New-Object -TypeName System.Net.Cookie
$myCookie.Name = "ARRAffinity"
$myCookie.Value = $instanceId
$cookieSession.Cookies.Add($kuduUrl, $myCookie)