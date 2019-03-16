### ADAL.NET �����[�h ###
$adal = "C:\ADAL\Microsoft.IdentityModel.Clients.ActiveDirectory.dll"
[System.Reflection.Assembly]::LoadFrom($adal)
 
 
### Azure AD �e�i���g�̐ݒ� ###
# Azure AD �e�i���g�̃f�B���N�g�� ID
$adId = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
 
# �g�[�N�����s��
$authority = "https://login.microsoftonline.com/$adId"
 
 
### Function App �ō쐬���� AD �A�v�� ###
# �N���C�A���g ID
$resourceApplicationId = "11f15836-8e45-4fb9-b9f8-b66611b21f8b"
 
 
### �N���C�A���g�p�ɍ쐬���� AD �A�v�� ###
# �A�v���P�[�V���� ID
$clientApplicationId = "dbcb7ba3-c667-4323-a310-a5e834b32675"
 
# ���_�C���N�g URI
$redirectUri = "https://jpciesample/MyNativeApp"
 
 
### �g�[�N������ ###
# ADAL �� AuthenticationContext �I�u�W�F�N�g
$authContext = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext -ArgumentList $authority
 
# �g�[�N���v�� (���i��񂪃L���b�V������Ă��Ȃ��ꍇ�A���i���v�����v�g���N�����܂�)
$platformParameters = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.PlatformParameters" -ArgumentList "Auto"
$authResult = $authContext.AcquireTokenAsync($resourceApplicationId, $clientApplicationId, $redirectUri, $platformParameters)
 
# Bearer �g�[�N��
$bearerToken = $authResult.Result.CreateAuthorizationHeader()
 
 
### Function �̌Ăяo��###
# Function �� URL
$functionUri = "https://jpcieauthtest.azurewebsites.net/api/HttpTriggerCSharp1?code=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
 
# �v�� Body
$body="{'name': 'Azure'}"
 
# HTTP �v���w�b�_�� Authorization �w�b�_�� Bearer�g�[�N����ݒ�
$requestHeader = @{
    "Authorization" = $bearerToken
}
 
# HTTPS �̃Z�L�����e�B �v���g�R���� TLS 1.2 �ɐݒ�
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
 
# Function �� HTTP �v���𑗐M
try{
    $response = Invoke-RestMethod -Uri $functionUri -Method Post -Headers $requestHeader -Body $body -ContentType "application/json"
    echo $response
}catch{
    Write-Error($_.Exception);
}