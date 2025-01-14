<#
    .SYNOPSIS
    Start a devbox in AWS Service Catalog and open VS Code.

    .DESCRIPTION
    This script starts a devbox in AWS Service Catalog and opens VS Code.

    .PARAMETER AWSProfile
    The AWS profile to use for the AWS CLI.

    .PARAMETER BoxName
    The name of the devbox to start.

    .EXAMPLE
    PS> Start-Devbox -AWSProfile "teamspace" -BoxName "devbox"
#>

[cmdletbinding()]
param (
    [string]$AWSProfile = "bi-is-ideationspace-play-teamspace",
    [string]$BoxName = "play-devbox",
    [switch]$Help
)

function Get-TimeStamp {
    return Get-Date -Format "yyyy-MM-dd\THH:mm:ss"
}


function Start-DevBox {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$AWSProfile,
        [Parameter(Mandatory = $true)]
        [string]$BoxName,
        [switch]$Help
    )


    # check if we have a valid session
    try {
        $awsSession = & aws --profile $AWSProfile sts get-caller-identity
        if ($LASTEXITCODE -ne 0) {
            throw "Could not find a valid session for profile $AWSProfile."
        }
        Write-Debug "$(Get-TimeStamp) - AWS Session: $awsSession"
    }
    catch {
        # Login to AWS SSO
        Write-Verbose "$(Get-TimeStamp) - Could not find a valid session for profile $AWSProfile. Logging in to AWS SSO."
        & aws sso login --profile "$AWSProfile"
    }


    # & aws sso --profile "$AWSProfile" login
    $provisionedProducts = $(& aws --profile $AWSProfile servicecatalog list-provisioned-product-plans | ConvertFrom-Json)
    Write-Debug "$(Get-TimeStamp) - Provisioned Products: $provisionedProducts"


    if ($null -ne $provisionedProducts.ProvisionedProductPlans -and $provisionedProducts.ProvisionedProductPlans.Count -gt 0) {
        $provisionedProductId = $provisionedProducts.ProvisionedProductPlans[0].ProvisionProductId
        Write-Debug "$(Get-TimeStamp) - Provisioned Product Id: $provisionedProductId"

        $productDetails = $(& aws --profile $AWSProfile servicecatalog describe-provisioned-product --id $provisionedProductId | ConvertFrom-Json)
        $productId = $productDetails.ProvisionedProductDetail.ProductId
        Write-Debug "$(Get-TimeStamp) - Product Id: $productId"
    }
    else {
        Write-Error "$(Get-TimeStamp) - No provisioned product plans found."
        return
    }
    $provisionedProductId = $provisionedProducts.ProvisionedProductPlans[0].ProvisionProductId
    Write-Debug "$(Get-TimeStamp) - Provisioned Product Id: $provisionedProductId"
    $provisioningArtifactId = $provisionedProducts.ProvisionedProductPlans[0].ProvisioningArtifactId
    Write-Debug "$(Get-TimeStamp) - Provisioning Artifact Id: $provisioningArtifactId"

    $serviceCatalogActions = $(& aws --profile $AWSProfile servicecatalog list-service-actions-for-provisioning-artifact --product-id "$productId" --provisioning-artifact-id "$provisioningArtifactId" | ConvertFrom-Json)
    Write-Debug "$(Get-TimeStamp) - Service Catalog Action Id: $serviceCatalogActions"

    # get the service action id that starts the devbox, the name of the action is "Start-EC2"
    $serviceActionStartEc2Id = $serviceCatalogActions.ServiceActionSummaries | Where-Object { $_.Name -eq "Start-EC2" } | Select-Object -ExpandProperty Id
    Write-Debug "$(Get-TimeStamp) - Service Action Start EC2 Id: $serviceActionStartEc2Id"

    $executionResult = & aws --profile "$AWSProfile" servicecatalog execute-provisioned-product-service-action --provisioned-product-id $provisionedProductId --service-action-id $serviceActionStartEc2Id
    Write-Debug "$(Get-TimeStamp) - Execution Result: $executionResult"


    # busy polling of the status of the provisioned product for at most 30 seconds
    $waitPeriod = 300
    $timeout = [datetime]::Now.AddSeconds($waitPeriod)
    $desiredStatus = "AVAILABLE"
    Write-Output "$(Get-TimeStamp) - Triggering the start of the $BoxName ... "
    Write-Output "Starting $BoxName ... (wait for $waitPeriod seconds)"
    while ($status -ne "$desiredStatus" -and [datetime]::Now -lt $timeout) {
        Start-Sleep -Seconds 3
        $status = $(& aws --profile $AWSProfile servicecatalog describe-provisioned-product --id $provisionedProductId | ConvertFrom-Json).ProvisionedProductDetail.Status
        Write-Progress -Activity "Starting $BoxName" -Status "Status: $status" -PercentComplete (([datetime]::Now - [datetime]::Now.AddSeconds(-$waitPeriod)).TotalSeconds / $waitPeriod * 100)
    }
    write-progress -Activity "Starting $BoxName" -completed

    if ($status -ne "$desiredStatus") {
        Write-Error "$(Get-TimeStamp) -  xxx I don't know what to do! Send help! xxx"
        Write-Warning "$(Get-TimeStamp) - Timeout reached. The status is: $status."
        exit 1
    }
    else {
        Write-Debug "$(Get-TimeStamp) - The status has changed to $status."
    }

    try {
        # start a code instance in the devbox via remote tunnels
        & ssh -T play-devbox "echo 'Good day sir!'"
        # & code --new-window --remote "ssh-remote+$BoxName"
        Write-Output "$(Get-TimeStamp) - Open VS Code at will!"
        exit 0
    }
    catch {
        $errorMessage = $_
        Write-Error "$(Get-TimeStamp) -  xxx I don't know what to do! Send help! xxx"
        Write-Error "$(Get-TimeStamp) - Give them this message: $errorMessage"
        exit 1
    }
}

if ($Help) {
    Write-Output "$($MyInvocation.MyCommand.Name) - Start a devbox in AWS Service Catalog and open VS Code."
    exit 0
}

Start-DevBox -AWSProfile $AWSProfile -BoxName $BoxName
