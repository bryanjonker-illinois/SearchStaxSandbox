param(
    [string]$ApiKey,
    [string]$IllinoisUrl
)

if ([string]::IsNullOrWhiteSpace($ApiKey)) {
    throw "The -ApiKey parameter is required. Example: -ApiKey:xxxxxxxxxxxxxxxxxxxxxx"
}
if ([string]::IsNullOrWhiteSpace($IllinoisUrl)) {
    throw "The -IllinoisUrl parameter is required. Example: -IllinoisUrl:https://illinois.edu"
}

$Headers = @{
    Authorization = "Token $ApiKey"
}

Write-Host "Starting process..."

try {
    #
    # Build SearchStax document
    #
    $doc = @{
        delete = $IllinoisUrl
    }
    $json = $doc | ConvertTo-Json -Depth 5
    Write-Host "JSON being sent"
    Write-Host $json

    #
    # Send to SearchStax
    #
    $result = Invoke-RestMethod `
        -Uri "https://searchcloud-1-us-east-1.searchstax.com/29847/urbanachampaignmain-5466/update?commit=true" `
        -Method Post `
        -Headers $Headers `
        -ContentType "application/json" `
        -Body $json

    Write-Host "JSON result"
    Write-Host ($result | ConvertTo-Json -Depth 10)
}
catch {
    Write-Warning $_
}
