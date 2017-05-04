<#
.Synopsis
   Returns Geo location, and WHOIS info for given IP address
.EXAMPLE
   Get-IPDomainInfo -IPAddress "8.8.8.8"
#>
function Get-IPDomainInfo
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # IP Address
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $IPAddress,

        [Switch]$ShowGeoIP
    )
        $Results = @()

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
            
       
            log-Line -Type Main -msg "Arin IP Lookup: $IPAddress"
            $ArinLookup = Invoke-RestMethod "http://whois.arin.net/rest/ip/$IPAddress" 
            $ArinLookup.net | select registrationDate,ref,endAddress,handle,name, netBlocks,resources, orgRef, parentNetRef,startAddress,updateDate, version         

                
            log-Line -Type Main -msg "Arin ASN Lookup: $($GEOLocate.as.Split(' ')[0])"
            try
            {
                $ASNLookUp = Invoke-RestMethod -UseBasicParsing "http://whois.arin.net/rest/asn/$($GEOLocate.as.Split(' ')[0])" 
                $ASNLookUp.ASN | Select registrationDate, ref, endAsNumber, handle, name, resources, orgRef, startAsNumber, updateDate
            }
            Catch{log-Line -Type Sub -msg "Arin ASN Lookup: Unable to Lookup"}
           
            if($ShowGeoIP)
            {            
                log-Line -Type Main -msg "Open GeoIP in Web Browser [$IPAddress]"
                start "http://ip-api.com/#$IPAddress"
            } 

}

Export-ModuleMember Get-IPDomainInfo
