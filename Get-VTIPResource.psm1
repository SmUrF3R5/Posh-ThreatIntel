<#
.Synopsis
   Lookup the resource on Virus Total
.DESCRIPTION
   Lookup the resource on Virus Total
.EXAMPLE
   get-VTIPResource -ipaddress 8.8.8.8 -apikey $APIKey -verbose
.EXAMPLE
   get-VTIPResource -IPAddress 8.8.8.8 -APIKey $APIKey -ShowVTWebsiteInfo
#>
function Get-VTIPResource
{
    [CmdletBinding()]
    Param
    (
        # IPAddress
        [Parameter(Mandatory=$true)]
        [string]$IPAddress,
        
        #APIKey You will need to register with Vurus Total to get one of these
        [Parameter(Mandatory=$true)]
        [String]$APIKey,

        # ShowVTWebsiteInfo Open the Virus Total infor for this resource
        [switch]$ShowVTWebsiteInfo
    )

    log-Line -Type Main -msg "Get Virus Total info: [$IPAddress]"
    
    $url = 'https://www.virustotal.com/vtapi/v2/url/report'

    $Result = "" | Select ProcessName, Path, Fileversion, Algorithm, Hash, ResponseCode, ScanDate, Total, Positives, PermaLink
    $body = @{ resource = "http://$IPAddress" ; apikey = $APIKey}
    
    $RestMethod = Invoke-RestMethod -Uri $url -Body $body -Method Get -ErrorAction SilentlyContinue 
        
    if($RestMethod.response_code -ne 0)
    {
        $RestMethod | Select Resource,Url,ResponseCOde,Permalink,scan_date,verbose_msg,positives,totals -ExpandProperty scans 
        
        #Open Virus Total Website
        if($ShowVTWebsiteInfo)
        {
            log-Line -Type Main -msg "Open Virus Total info in Web Browser: [$IPAddress]"            
            start $RestMethod.permalink
        }
    }
    Else 
    {
        Write-Warning "Virus Total Response Code: $($RestMethod.verbose_msg) [$($RestMethod.response_code)]"
    }
}

Export-ModuleMember Get-VTIPResource