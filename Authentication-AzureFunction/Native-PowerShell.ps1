### ADAL.NET をロード ###
$adal = "C:\ADAL\Microsoft.IdentityModel.Clients.ActiveDirectory.dll"
[System.Reflection.Assembly]::LoadFrom($adal)
 
 
### Azure AD テナントの設定 ###
# Azure AD テナントのディレクトリ ID
$adId = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
 
# トークン発行元
$authority = "https://login.microsoftonline.com/$adId"
 
 
### Function App で作成した AD アプリ ###
# クライアント ID
$resourceApplicationId = "11f15836-8e45-4fb9-b9f8-b66611b21f8b"
 
 
### クライアント用に作成した AD アプリ ###
# アプリケーション ID
$clientApplicationId = "dbcb7ba3-c667-4323-a310-a5e834b32675"
 
# リダイレクト URI
$redirectUri = "https://jpciesample/MyNativeApp"
 
 
### トークン生成 ###
# ADAL の AuthenticationContext オブジェクト
$authContext = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext -ArgumentList $authority
 
# トークン要求 (資格情報がキャッシュされていない場合、資格情報プロンプトが起動します)
$platformParameters = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.PlatformParameters" -ArgumentList "Auto"
$authResult = $authContext.AcquireTokenAsync($resourceApplicationId, $clientApplicationId, $redirectUri, $platformParameters)
 
# Bearer トークン
$bearerToken = $authResult.Result.CreateAuthorizationHeader()
 
 
### Function の呼び出し###
# Function の URL
$functionUri = "https://jpcieauthtest.azurewebsites.net/api/HttpTriggerCSharp1?code=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
 
# 要求 Body
$body="{'name': 'Azure'}"
 
# HTTP 要求ヘッダの Authorization ヘッダに Bearerトークンを設定
$requestHeader = @{
    "Authorization" = $bearerToken
}
 
# HTTPS のセキュリティ プロトコルを TLS 1.2 に設定
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
 
# Function に HTTP 要求を送信
try{
    $response = Invoke-RestMethod -Uri $functionUri -Method Post -Headers $requestHeader -Body $body -ContentType "application/json"
    echo $response
}catch{
    Write-Error($_.Exception);
}