# Posh-ThreatIntel

This is all very much in the Alpha stage right now. The basic idea is to build Threat Intelligence on source IP's and\or FQDN's.
You will need a virus Total api key. You can obtain one by registering with them for free at https://www.virustotal.com/

Install Instructions

	Download the files into their own directory
	Open Powershell 
	Run Get-IPThreatIntel.ps1 to load the Get-IPThreatIntel powershell function

	PS C:\Posh-ThreatIntel> Get-IPThreatIntel -IPAddress x.x.x.x 
	PS C:\Posh-ThreatIntel> Get-IPThreatIntel -IPAddress x.x.x.x -DispalayAllResults 
