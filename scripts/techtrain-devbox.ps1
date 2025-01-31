# Enable ANSI escape sequences
$esc = [char]27

# Set AWS profile
$awsProfile = "bi-is-ideationspace-techtrain-teamspace"
Write-Host -ForegroundColor Red "Using AWS profile: $esc[1m$awsProfile$esc[0m"
aws --profile "$awsProfile" sso login
ssh techtrain-devbox
