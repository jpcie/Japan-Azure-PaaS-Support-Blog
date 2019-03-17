$webAppName = "<webAppName>"
$resourceGroupName = "<resourceGroupName>"
$resource = Invoke-AzureRmResourceAction -ResourceGroupName $resourceGroupName -ResourceType Microsoft.Web/sites/config -ResourceName "$webAppName/publishingcredentials" -Action list -ApiVersion 2016-08-01 -Force
$username = $resource.properties.publishingUserName
$password = $resource.properties.publishingPassword