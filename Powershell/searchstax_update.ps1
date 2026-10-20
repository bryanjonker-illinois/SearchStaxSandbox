param(
    [string]$ApiKey,
    [string]$Url,
    [string]$Title,
    [string]$Content,
    [string]$Category
)

if ([string]::IsNullOrWhiteSpace($ApiKey)) {
    throw "The -ApiKey parameter is required. Example: -ApiKey:xxxxxxxxxxxxxxxxxxxxxx"
}
if ([string]::IsNullOrWhiteSpace($Url)) {
    throw "The -Url parameter is required. Example: -Url:https://illinois.edu"
}
if ([string]::IsNullOrWhiteSpace($Title)) {
    throw "The -Title parameter is required. Example: -Title:'My Title'"
}
if ([string]::IsNullOrWhiteSpace($Content)) {
    throw "The -Content parameter is required. Example: -Content:'My Content'"
}

$Headers = @{
    Authorization = "Token $ApiKey"
}

$ErrorList = @()

Write-Host "Starting process..."

try {
    $doc = @{
        add = @{
            doc = @{
                title             = $Title
                title_txt_en      = $Title
                category_news_s   = $Category
                content           = $Content
                description       = $Content
                url               = $Url
                url_t             = $Url
                id                = $Url
            }
        }
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

Write-Host ""
Write-Host "Process completed."