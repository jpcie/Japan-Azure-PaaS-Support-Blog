$webAppName = "<webAppName>"
$resourceGroupName = "<resourceGroupName>"
$siteUrl = "https://$webAppName.azurewebsites.net"
$kuduUrl = "https://$webAppName.scm.azurewebsites.net"
$dumpCount = 3
$dumpInterval = 10000
 
# Azure PowerShell ���O�C��
Login-AzureRmAccount
 
# �f�v���C���i�����擾����
$resource = Invoke-AzureRmResourceAction -ResourceGroupName $resourceGroupName -ResourceType Microsoft.Web/sites/config -ResourceName "$webAppName/publishingcredentials" -Action list -ApiVersion 2016-08-01 -Force
$username = $resource.properties.publishingUserName
$password = $resource.properties.publishingPassword
 
# ��{�F�؏���ݒ肷��
$base64AuthInfo = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username, $password)))
$authHeader = @{Authorization=("Basic {0}" -f $base64AuthInfo)}
 
# �C���X�^���X�ꗗ���擾����
$instances = Get-AzureRmResource -ResourceGroupName $resourceGroupName -ResourceType Microsoft.Web/sites/instances -ResourceName $webAppName -ApiVersion 2016-08-01
 
# �e�C���X�^���X�ɑ΂��ď��������s����
foreach($instance in $instances)
{
    # ARRAffinity �N�b�L�[��ݒ肷��
    $cookieSession = New-Object -TypeName Microsoft.PowerShell.Commands.WebRequestSession
    $myCookie = New-Object -TypeName System.Net.Cookie
    $myCookie.Name = "ARRAffinity"
    $myCookie.Value = $instance.Name
    $cookieSession.Cookies.Add($kuduUrl, $myCookie)
 
    # �w���X�`�F�b�N�����s����
    $result = Invoke-WebRequest -WebSession $cookieSession -Uri $siteUrl -Method Get
 
    if ($result.StatusCode -eq 200)
    {
        # ������ HTTP 200 �̏ꍇ
        echo "$($instance.Name) is Healthy"
    } else {
        # ������ HTTP 200 �ȊO�̏ꍇ
        echo "$($instance.Name) is Unhealthy"
 
        # �v���Z�X ������ �_���v���擾����
        for ($i = 0; $i -lt $dumpCount; $i++)
        {
            $outfile = "C:\Diagnostics\" + (Get-Date).ToString("yyyyMMddHHmmss") + ".zip"
            Invoke-RestMethod -Headers $authHeader -WebSession $cookieSession -Uri "$kuduUrl/api/processes/-1/dump?dumpType=2&amp&format=zip" -Method Get -OutFile $outfile
            Start-Sleep -m $dumpInterval
        }
    }
}