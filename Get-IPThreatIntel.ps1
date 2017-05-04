function log-Line
{
        [CmdletBinding()]
    Param
    (
        # Message
        $msg,
        #Type - Main, Sub,SubChild
        [ValidateSet('Main','Sub','SubChild')]
        $Type
    )
    
    #"[+] Importing Module: $Mod"
    switch ($Type)
    {
        'Main' 
        {
            Write-Host -ForegroundColor Green -NoNewline "[+] "
            Write-Host -ForegroundColor Yellow $msg    
        }        
        'Sub' 
        {
            Write-Host -ForegroundColor yellow -NoNewline "`t[○] "
            Write-Host -ForegroundColor Red $msg    
        }
        'SubChild'
        {
            Write-Host -ForegroundColor green -NoNewline "`t`t[☺] "
            Write-Host -ForegroundColor Red $msg    
        }
    }
}



<#
.Synopsis
   Short description
.DESCRIPTION
   Get Threat intel on a secified IP Address
.EXAMPLE
   Get-IPThreatIntel -IPAddress x.x.x.x 
.EXAMPLE
   Get-IPThreatIntel -IPAddress x.x.x.x -DispalayAllResults
#>
function Get-IPThreatIntel
{
    [CmdletBinding()]
    Param
    (
        # IPAddress
        [Parameter(Mandatory=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=0)]
        $IPAddress,
        [Switch]$DispalayAllResults
    )
        if(($APIKey = Get-Content "$PSScriptRoot\VT-APIKey.txt") -eq "YOUR_API_KEY_HERE")
        {
            Write-Warning "$("$PSScriptRoot\VT-APIKey.txt") does not contain a valid Virus Total api key."
            Write-Warning "Visit www.virusTotal.com and register to obtain a API Key"
            Write-Warning "API Key: $APIKey"
        }
        else
        {
            $split = $IPAddress.split('.')
            if ($split.Length -eq 4)        
            {
                write-verbose $IPAddress        
                foreach ($mod in (get-item  "$PSScriptRoot\*.psm1"))
                {   
                    Log-line -type Main -msg "Import Module: $mod"
                    Import-Module $mod -DisableNameChecking 
                }     
            
                write-host

                # You Will Need to Get An API KEY from Virus Total and put it in the VT-APIKey.Txt file
                $APIKey= Get-Content "$PSScriptRoot\VT-APIKey.txt"

                if($DispalayAllResults)
                {
                    Get-IPDomainInfo -IPAddress $IPAddress -ShowGeoIP
                    Start-Sleep -Seconds 2            
                    Get-VTIPResource -IPAddress $IPAddress -APIKey $APIKey -ShowVTWebsiteInfo
                    Get-VTIPReport -IPAddress $IPAddress -APIKey $APIKey 
                }
                else
                {
                    Get-IPDomainInfo -IPAddress $IPAddress 
                    #Get-DNSRecords -FQDN $IPAddress        
                    Get-VTIPResource -IPAddress $IPAddress -APIKey $APIKey      
                    Get-VTIPReport -IPAddress $IPAddress -APIKey $APIKey   
                }
            } 
            else 
            {
                Write-Error "Bad IP Address"
            }
        }        
}


