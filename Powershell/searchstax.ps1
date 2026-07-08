param(
    [string]$ApiKey,
    [string]$SearchStaxUrl,
    [string]$Source = "education"
)

$Headers = @{
    Authorization = "Token $ApiKey"
}

$ErrorList = @()

#
# Get directory list
#
Write-Host "Loading directory..."

$directoryUrl = "https://directoryapi.wigg.illinois.edu/api/Directory/Search/$Source?take=999"

try {
    $directory = Invoke-RestMethod `
        -Uri $directoryUrl `
        -Method Get

    $NetIds = $directory.people.netId | Sort-Object
}
catch {
    throw "Unable to retrieve directory list: $_"
}

foreach ($NetId in $NetIds) {

    Write-Host ""
    Write-Host "NetID: $NetId"

    try {

        #
        # Load profile
        #
        $profileUrl = "https://directoryapi.wigg.illinois.edu/api/Directory/GetProfile/$Source/$NetId"

        $profile = Invoke-RestMethod `
            -Uri $profileUrl `
            -Method Get

        if ([string]::IsNullOrWhiteSpace($profile.profileUrl)) {
            Write-Warning "Missing profile URL"
            $ErrorList += $NetId
            continue
        }

        Write-Host "Profile URL: $($profile.profileUrl)"

        #
        # Build SearchStax document
        #
        $content = @(
            $profile.fullName
            $profile.primaryTitle
            $profile.primaryOffice
            "$($profile.roomNumber) $($profile.building)"
            "$($profile.addressLine1) $($profile.addressLine2)"
            $profile.biography
            $profile.researchStatement
            $profile.teachingStatement
        ) -join " "

        $title = "$($profile.fullName) | Illinois"

        $description = "$($profile.fullName) ($($profile.email)): $($profile.primaryTitle), $($profile.primaryOffice)"

        $doc = @{
            add = @{
                doc = @{
                    title             = $title
                    title_txt_en      = $title
                    category_news_s   = "People"
                    content           = $content
                    description       = $description
                    url               = $profile.profileUrl
                    url_t             = $profile.profileUrl
                    id                = $profile.profileUrl
                }
            }
        }

        $json = $doc | ConvertTo-Json -Depth 5

        #
        # Send to SearchStax
        #
        $result = Invoke-RestMethod `
            -Uri "$SearchStaxUrl?commit=true" `
            -Method Post `
            -Headers $Headers `
            -ContentType "application/json" `
            -Body $json

        Write-Host ($result | ConvertTo-Json -Depth 10)

    }
    catch {

        Write-Warning $_
        $ErrorList += $NetId
    }
}

Write-Host ""
Write-Host "Errors"

$ErrorList