<#
.Synopsis
   Gets the geo location for a given IP address
.DESCRIPTION
   Gets the geo location for a given IP address using http://ip-api.com. No Api key needed for small request batches
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Get-GeoLocation
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $IPAddress,

        [Switch]$ShowGeoIP
    )

    if (!$IPAddress)
        {
            #$IPAddress = "?callback=yourfunction"
            $CallBack = $true
        }
            If($Callback)
            {
                "[+] IP Address: CallBack"
                    $uri = "http://ip-api.com/json/$IPAddress"
                "[+] URI: $uri"
                ""
                    $GeoLocate = Invoke-WebRequest -uri $uri | ConvertFrom-Json
                "[+] GeoLocating: $uri"
                    $GeoLocate 
                ""
                $IPAddress = $GeoLocate.query
            }
            else
            {                
                Log-line -type Main -msg "Get-IPDomainInfo"                
                Log-line -type Sub -msg "IP Address: $IPAddress"                
                $uri = "http://ip-api.com/json/$IPAddress"
                
                log-Line -Type Sub -msg "URI: $uri"
                ""
                $GeoLocate = Invoke-WebRequest -uri $uri | ConvertFrom-Json
                
                log-Line -Type Main -msg "GeoLocating: $uri"
                $GeoLocate                              
            }
        if($ShowGeoIP)
        {            
            log-Line -Type Main -msg "Open GeoIP in Web Browser [$IPAddress]"
            start "http://ip-api.com/#$IPAddress"
        } 
}