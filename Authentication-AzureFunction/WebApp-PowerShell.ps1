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
$clientApplicationId = "3cd3551e-fc68-4510-b236-64c207b353fb"
 
# ���_�C���N�g URI
$redirectUri = "https://jpciesample/MyNativeApp"
 
# �V�[�N���b�g �L�[
$secretKey = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
 
 
### �g�[�N������ ###
# ADAL �� AuthenticationContext �I�u�W�F�N�g
$authContext = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext -ArgumentList $authority
 
# �N���C�A���g���i���
$clientCredential = New-Object -TypeName Microsoft.IdentityModel.Clients.ActiveDirectory.ClientCredential ($clientApplicationId, $secretKey)
 
# �g�[�N���v��
$authResult = $authContext.AcquireTokenAsync($resourceApplicationId, $clientCredential)
 
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