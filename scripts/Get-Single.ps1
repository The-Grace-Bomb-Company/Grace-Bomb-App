$uri = 'https://nominatim.openstreetmap.org/search?format=json&q='

$search = Get-Clipboard

$response = irm ($uri + $search)

if ($response -is [Array]) {
    $response = $response[0]
}

$dat = [pscustomobject]@{
    OriginalLocation = $search
    FixedLocation = $response.display_name
    Latitude = $response.lat
    Longitude = $response.lon
    PlaceId = $response.place_id
}

ConvertTo-Csv $dat -NoHeader | Set-Clipboard