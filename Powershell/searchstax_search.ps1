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

if (-not $IllinoisUrl.EndsWith("/")) { $IllinoisUrl += "/" }
$NewUrl = [System.Web.HttpUtility]::UrlEncode($IllinoisUrl)

Write-Host "Starting process..."

try {
    #
    # Send to SearchStax
    #
    $result = Invoke-RestMethod `
        -Uri "https://searchcloud-1-us-east-1.searchstax.com/29847/urbanachampaignmain-5466/emselect?q=url%3A%22$NewUrl%22&wt=json&indent=true" `
        -Method Get `
        -Headers $Headers `

    Write-Host "JSON result"
    Write-Host ($result | ConvertTo-Json -Depth 10)

    $numResults = $result.response.numFound
    Write-Host "Number of Results found: $numResults"

    Write-Host "https://searchcloud-1-us-east-1.searchstax.com/29847/urbanachampaignmain-5466/emselect?q=url%3A%22$NewUrl%22&wt=json&indent=true"
}
catch {
    Write-Warning $_
}
