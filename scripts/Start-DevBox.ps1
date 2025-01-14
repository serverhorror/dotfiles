<#
    .SYNOPSIS
    Start a devbox in AWS Service Catalog and open VS Code.

    .DESCRIPTION
    This script starts a devbox in AWS Service Catalog and opens VS Code.

    .PARAMETER AWSProfile
    The AWS profile to use for the AWS CLI. (Default: $Env:USERNAME-teamspace)

    .PARAMETER DevBox
    The name of the devbox to start. (Default: First devbox found)

    .PARAMETER StartVSCode
    Start VS Code after starting the devbox. (Default: do not start VS Code)

    .EXAMPLE
    PS> Start-Devbox -AWSProfile "teamspace" -DevBox "devbox"
#>

[cmdletbinding()]
param (
    [string]$AWSProfile = "teamspace",
    [string]$DevBox,
    [switch]$StartVSCode,
    [switch]$Help
)

$ErrorActionPreference = "Stop"

if ($Debug) {
    $VerbosePreference = "Continue"
    $DebugPreference = "Continue"
}

function Get-TimeStamp {
    return Get-Date -Format "yyyy-MM-dd\THH:mm:ss"
}


function Start-DevBox {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$AWSProfile,
        [string]$DevBox,
        [switch]$StartVSCode,
        [switch]$Help
    )

    try {
        # check if aws knows about hte profile
        $discoveredAwsProfile = & aws configure list-profiles | Select-String -Pattern $AWSProfile
        if ($null -eq $discoveredAwsProfile) {
            Write-Warning -Message "$(Get-TimeStamp) - Profile ``$AWSProfile' not found." -fo
            return
        }

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
            if ($LASTEXITCODE -ne 0) {
                throw "Could not find a valid profile $AWSProfile."
            }
            throw
        }


        # & aws sso --profile "$AWSProfile" login
        $provisionedProducts = $(& aws --profile $AWSProfile servicecatalog list-provisioned-product-plans | ConvertFrom-Json)
        Write-Debug "$(Get-TimeStamp) - Provisioned Products: $provisionedProducts"

        # check if provisionedProducts has a key ProvisionedProductPlans and if it has at least one element
        if ($null -eq $provisionedProducts.ProvisionedProductPlans) {
            Write-Error "$(Get-TimeStamp) - No provisioned product plans found."
            return
        }

        if ($null -ne $provisionedProducts.ProvisionedProductPlans -and $provisionedProducts.ProvisionedProductPlans.Count -gt 0) {
            $provisionedProductId = $provisionedProducts.ProvisionedProductPlans[0].ProvisionProductId
            Write-Debug "$(Get-TimeStamp) - Provisioned Product Id: $provisionedProductId"

            $productDetails = $(& aws --profile $AWSProfile servicecatalog describe-provisioned-product --id $provisionedProductId | ConvertFrom-Json)
            if ($LASTEXITCODE -ne 0) {
                throw "Could not describe provisioned product: $provisionedProductId."
                exit 1
            }
            $productId = $productDetails.ProvisionedProductDetail.ProductId
            Write-Debug "$(Get-TimeStamp) - Product Id: $productId"
        }
        else {
            Write-Error "$(Get-TimeStamp) - No provisioned product plans found."
            return
        }
        $provisioningArtifactId = $provisionedProducts.ProvisionedProductPlans[0].ProvisioningArtifactId
        Write-Debug "$(Get-TimeStamp) - Provisioning Artifact Id: $provisioningArtifactId"

        if (-Not $DevBox) {
            # get the provisioned product outputs
            Write-Debug "$(Get-TimeStamp) - Getting the provisioned product outputs."
            $provisionedProductOutputs = aws servicecatalog get-provisioned-product-outputs --profile $AWSProfile --provisioned-product-id $provisionedProductId
            $DevBox = ($($provisionedProductOutputs | ConvertFrom-Json).Outputs | Where-Object { $_.OutputKey -eq 'Instance' }).OutputValue
            Write-Debug "$(Get-TimeStamp) - Found DevBox: $DevBox"
        }

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
        Write-Output "$(Get-TimeStamp) - Triggering the start of the $DevBox ... "
        Write-Output "Starting $DevBox ... (wait for $waitPeriod seconds)"
        while ($status -ne "$desiredStatus" -or [datetime]::Now -ge $timeout) {
            Start-Sleep -Seconds 3
            $status = $(& aws --profile $AWSProfile servicecatalog describe-provisioned-product --id $provisionedProductId | ConvertFrom-Json).ProvisionedProductDetail.Status
            Write-Progress -Activity "Starting DevBox: $DevBox" -Status "Status: $status" -SecondsRemaining ($timeout - [datetime]::Now).TotalSeconds
        }
        write-progress -Activity "Starting DevBox: $DevBox" -completed

        if ($status -ne "$desiredStatus") {
            Write-Error "$(Get-TimeStamp) -  xxx I don't know what to do! Send help! xxx"
            Write-Warning "$(Get-TimeStamp) - Timeout reached. The status is: $status."
            exit 1
        }
        else {
            Write-Debug "$(Get-TimeStamp) - The status has changed to $status."
        }
    }
    catch {
        # Write-Error $_.Exception.Message
        Write-Error $_.ScriptStackTrace
        Write-Error "$(Get-TimeStamp) -  xxx I don't know what to do! Send help! xxx"
        Write-Error "$(Get-TimeStamp) - Give them this message: $errorMessage"
        exit 1
    }

    try {
        # start a code instance in the devbox via remote tunnels
        & ssh -T $DevBox "echo 'Good day sir!'"
        Write-Information "Open VS Code at will!"
        $msg = (
            "Open VS Code at will!" + "`n" +
            "`n" +
            "* code --new-window --remote ssh-remote+$DevBox" + "`n" +
            "* Start VS Code and use the Remote-SSH extension to connect to the $DevBox." + "`n" +
            ""
        )
        Write-Output $msg
        if ($StartVSCode) {
            Write-Information "$(Get-TimeStamp) - Starting VS Code..."
            & code --new-window --remote "ssh-remote+$DevBox"
        }


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

$ErrorActionPreference = "Stop"
# Set-PSDebug -Trace 1

Start-DevBox -AWSProfile $AWSProfile -DevBox $DevBox -StartVSCode:$StartVSCode
