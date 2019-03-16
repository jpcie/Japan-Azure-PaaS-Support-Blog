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
$clientApplicationId = "3cd3551e-fc68-4510-b236-64c207b353fb"
 
# リダイレクト URI
$redirectUri = "https://jpciesample/MyNativeApp"
 
# シークレット キー
$secretKey = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
 
 
### トークン生成 ###
# ADAL の AuthenticationContext オブジェクト
$authContext = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext -ArgumentList $authority
 
# クライアント資格情報
$clientCredential = New-Object -TypeName Microsoft.IdentityModel.Clients.ActiveDirectory.ClientCredential ($clientApplicationId, $secretKey)
 
# トークン要求
$authResult = $authContext.AcquireTokenAsync($resourceApplicationId, $clientCredential)
 
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