<#
.SYNOPSIS
    Manages AWS DevBox provisioning and connection.

.DESCRIPTION
    This script handles AWS DevBox provisioning through Service Catalog and establishes
    remote connections. It manages AWS profiles and SSO authentication.

.PARAMETER AWSProfile
    AWS profile to use. Defaults to AWS_DEFAULT_PROFILE environment variable or "default".

.PARAMETER ProductId
    Service Catalog provisioned product ID. Defaults to "pp-yqvktpc4xttmo".

.PARAMETER ActionId
    Service action ID for the provisioned product. Defaults to "act-ellycofvnakji".

.EXAMPLE
    .\devbox.ps1 -Profile "dev" -ProductId "pp-abc123"

.NOTES
    Version: 1.0
    Author: You will never find out!
    Last Modified: 2024-03-20
#>

[CmdletBinding()]
param (
    [Parameter(Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]$AWSProfile = $env:AWS_DEFAULT_PROFILE ?? "default",

    [Parameter(Position = 1)]
    [ValidatePattern('^pp-[a-z0-9]+$')]
    [string]$ProductId = "pp-yqvktpc4xttmo",

    [Parameter(Position = 2)]
    [ValidatePattern('^act-[a-z0-9]+$')]
    [string]$ActionId = "act-ellycofvnakji"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Verify AWS CLI installation
if (-not (Get-Command aws -ErrorAction SilentlyContinue)) {
    throw "AWS CLI is not installed. Please install it before running this script."
}

Write-Verbose "Using AWS Profile: $AWSProfile"
Write-Verbose "Using Product ID: $ProductId"
Write-Verbose "Using Action ID: $ActionId"

try {
    # Execute AWS commands
    $output = & aws --profile $AWSProfile sso login
    if ($LASTEXITCODE -ne 0) {
        # Write-Error -Message $output
        throw "$output"
    }
    $output = & aws --profile $AWSProfile servicecatalog execute-provisioned-product-service-action `
        --provisioned-product-id $ProductId `
        --service-action-id $ActionId
    if ($LASTEXITCODE -ne 0) {
        # Write-Error -Message $output
        throw "$output"
    }

    # # BUG: we do not have the permissions to call servicecatalog:DescribeRecord
    # # wait for the service action to complete by polling the status
    # $output = & aws --profile $AWSProfile servicecatalog describe-record --id $ProductId
    # $actionStatus = $output | ConvertFrom-Json | Select-Object -ExpandProperty RecordDetail | Select-Object -ExpandProperty Status
    # while ($actionStatus -ne "SUCCEEDED") {
    #     Write-Host "Service action status: $status" -ForegroundColor Yellow
    #     Start-Sleep -Seconds 30
    #     $output = & aws --profile $AWSProfile servicecatalog describe-record --id $ProductId
    #     $status = $output | ConvertFrom-Json | Select-Object -ExpandProperty RecordDetail | Select-Object -ExpandProperty Status
    # }

    Write-Host "Waiting for service action to complete..." -ForegroundColor Yellow -NoNewline
    for ($i = 0; $i -lt 10; $i++) {
        Write-Host "." -ForegroundColor Yellow -NoNewline
        Start-Sleep -Seconds 3
    }
    Write-Host "(done, or ... likely done!)"  # Add newline at end

    Write-Host "DevBox started. Ready to go!" -ForegroundColor Green
}
catch {
    Write-Error "Failed to execute AWS commands: $_"
    exit 1
}
