$uri = 'https://nominatim.openstreetmap.org/details?format=json&addressdetails=1&place_id='

$locations = Import-Csv './fixed-locations.csv'

# $locations | select -firs 3 | select *, @{l='FriendlyName';e={
#     $res = irm ($uri + $_.PlaceId)
#     $locale = $res.address[0].localname
#     $state = $res.address | ? admin_level -eq 4 | select -expand localname

#     "$locale, $state"
# }}


$locations | select -first 1 | % {
    $res = irm ($uri + $_.PlaceId) -UserAgent 'org.gracebomb.data-analysis'
    $locale = $res.address[0].localname
    $state = $res.address | ? admin_level -eq 4 | select -expand localname

    "$locale, $state"
}

