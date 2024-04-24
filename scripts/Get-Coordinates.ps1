$uri = 'https://nominatim.openstreetmap.org/search?format=json&q='

$locations = Get-Content './locations.txt'

foreach ($location in $locations) {
    if ([string]::IsNullOrWhiteSpace($location)) {
        [pscustomobject]@{
            OriginalLocation = $location
            FixedLocation = $null
            Latitude = $null
            Longitude = $null
            PlaceId = $null
        }
    }
    
    $response = irm ($uri + $location)

    if ($response -is [Array]) {
        $response = $response[0]
    }

    [pscustomobject]@{
        OriginalLocation = $location
        FixedLocation = $response.display_name
        Latitude = $response.lat
        Longitude = $response.lon
        PlaceId = $response.place_id
    }
}
