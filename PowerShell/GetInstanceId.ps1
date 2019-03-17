$webAppName = "<webAppName>"
$resourceGroupName = "<resourceGroupName>"
$instances = Get-AzureRmResource -ResourceGroupName $resourceGroupName -ResourceType Microsoft.Web/sites/instances -ResourceName $webAppName -ApiVersion 2016-08-01
$instanceIds = @()
foreach($instance in $instances)
{
 $instanceIds += $instance.Name
}