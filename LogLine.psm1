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
            Write-Host -ForegroundColor green $msg    
        }
        'SubChild'
        {
            Write-Host -ForegroundColor green -NoNewline "`t`t[☺] "
            Write-Host -ForegroundColor Cyan $msg    
        }
    }
}

Export-ModuleMember log-line