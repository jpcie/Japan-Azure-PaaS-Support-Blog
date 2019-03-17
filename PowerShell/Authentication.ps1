$username = "<username>"
$password = "<password>"
$base64AuthInfo = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username, $password)))
$authHeader = @{Authorization=("Basic {0}" -f $base64AuthInfo)}