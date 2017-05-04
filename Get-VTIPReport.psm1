<#
.Synopsis
   Get IP Address Report from Virus Total.
.DESCRIPTION
   This report will list domains that resolve to this IP Address
.EXAMPLE
   Get-VTIPReport -IPAddress 8.8.8.8
#>
function Get-VTIPReport
{
    [CmdletBinding()]
    Param
    (
        # IPAddress
        [Parameter(Mandatory=$true)]
        [string]$IPAddress,
        
        #APIKey You will need to register with Vurus Total to get one of these        
        [String]$APIKey,

        [Switch]$ShowRaw
    )
    if(!$APIKey)
    {
        $APIKey= Get-Content "$PSScriptRoot\VT-APIKey.txt"
    }

    #"[+] Get Virus Total IP Address Report: [$IPAddress]"
    log-Line -Type Main -msg "Get Virus Total IP Address Report: [$IPAddress]"
    $url = 'https://www.virustotal.com/vtapi/v2/ip-address/report'   
        
    $body = @{ 'ip' = $IPAddress ; 'apikey' = $APIKey}
    

    $RestMethod = Invoke-RestMethod -Uri $url -Body $body -Method Get -ErrorAction SilentlyContinue 
        
    if($RestMethod.response_code -ne 0)
    { 
        If($ShowRaw)
        {
            Log-Line -Type Main -msg "Raw [$IPAddress]"
            $RestMethod
        }    ""            
        Log-Line -Type Main -msg "Resolutions to [$IPAddress]"
        $RestMethod | select -ExpandProperty resolutions  | ft
        #$RestMethod | select -ExpandProperty resolutions | Out-GridView
        ""
               
        Log-Line -Type Main -msg "Detected URLs to [$IPAddress]" 
        $RestMethod | select -ExpandProperty detected_urls | Sort-Object Positives -Descending | ft
        #$RestMethod | select -ExpandProperty detected_urls | Out-GridView
        ""
        
        Log-Line -Type Main -msg "Detected Downloaded Samples [$IPAddress]"
        $RestMethod.detected_downloaded_samples| Sort-Object Positives -Descending | ft
    }
    Else 
    {
        Write-Warning "Virus Total Response Code: $($RestMethod.verbose_msg) [$($RestMethod.response_code)]"
    }

}

Export-ModuleMember Get-VTIPReport