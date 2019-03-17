$webAppName = "<webAppName>"
$resourceGroupName = "<resourceGroupName>"
$siteUrl = "https://$webAppName.azurewebsites.net"
$kuduUrl = "https://$webAppName.scm.azurewebsites.net"
$dumpCount = 3
$dumpInterval = 10000
 
# Azure PowerShell ログイン
Login-AzureRmAccount
 
# デプロイ資格情報を取得する
$resource = Invoke-AzureRmResourceAction -ResourceGroupName $resourceGroupName -ResourceType Microsoft.Web/sites/config -ResourceName "$webAppName/publishingcredentials" -Action list -ApiVersion 2016-08-01 -Force
$username = $resource.properties.publishingUserName
$password = $resource.properties.publishingPassword
 
# 基本認証情報を設定する
$base64AuthInfo = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username, $password)))
$authHeader = @{Authorization=("Basic {0}" -f $base64AuthInfo)}
 
# インスタンス一覧を取得する
$instances = Get-AzureRmResource -ResourceGroupName $resourceGroupName -ResourceType Microsoft.Web/sites/instances -ResourceName $webAppName -ApiVersion 2016-08-01
 
# 各インスタンスに対して処理を実行する
foreach($instance in $instances)
{
    # ARRAffinity クッキーを設定する
    $cookieSession = New-Object -TypeName Microsoft.PowerShell.Commands.WebRequestSession
    $myCookie = New-Object -TypeName System.Net.Cookie
    $myCookie.Name = "ARRAffinity"
    $myCookie.Value = $instance.Name
    $cookieSession.Cookies.Add($kuduUrl, $myCookie)
 
    # ヘルスチェックを実行する
    $result = Invoke-WebRequest -WebSession $cookieSession -Uri $siteUrl -Method Get
 
    if ($result.StatusCode -eq 200)
    {
        # 応答が HTTP 200 の場合
        echo "$($instance.Name) is Healthy"
    } else {
        # 応答が HTTP 200 以外の場合
        echo "$($instance.Name) is Unhealthy"
 
        # プロセス メモリ ダンプを取得する
        for ($i = 0; $i -lt $dumpCount; $i++)
        {
            $outfile = "C:\Diagnostics\" + (Get-Date).ToString("yyyyMMddHHmmss") + ".zip"
            Invoke-RestMethod -Headers $authHeader -WebSession $cookieSession -Uri "$kuduUrl/api/processes/-1/dump?dumpType=2&amp&format=zip" -Method Get -OutFile $outfile
            Start-Sleep -m $dumpInterval
        }
    }
}