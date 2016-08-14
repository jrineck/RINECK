<#Introduction#>
Write-Host “
 SCAP 4.1 - Windows 10 U.S. Government Secure Host Baseline (SHB)” @TitleFont

<#Gather System Information#>
    <#Date#>
        $Date = Get-Date
    <#Hostname#>
        $Hostname = $Env:computername
    <#Network#>
        $Network = Get-WmiObject win32_networkadapterconfiguration -computername $Hostname | where {$_.ipenabled -eq "true" -and $_.IPAddress -ne "0.0.0.0"}
        $IPv4 = (Test-Connection -ComputerName $Hostname -Count 1).IPV4Address.IPAddressToString
        $IPv6 = (Test-Connection -ComputerName $Hostname -Count 1).IPV6Address.IPAddressToString
        $MAC = $Network.MACAddress

Write-Host "
     Executed:         $Date 
     Hostname:       $Hostname
     IPv4:                 $IPv4
     IPv6:                 $IPv6
     MAC:                $MAC" @SystemFont

<#Definitions#>
    <#Applications#>
        <#EMET#>
            $EMETadml = "C:\Program Files (x86)\EMET 5.5\Deployment\Group Policy Files\EMET.adml"
            $EMETadmx = "C:\Program Files (x86)\EMET 5.5\Deployment\Group Policy Files\EMET.admx"
        <##>
    <#Font Variables#>
        <#Title#>
            $TitleFont = @{ForegroundColor = "Blue"}
        <#System - Timestamp and Hostname#>
            $SystemFont = @{ForegroundColor = "White"}
         <#Success - Text formatting if the operation is successful#>
            $SuccessFont = @{ForegroundColor = "Green"}
         <#Failure - Text formatting if the operation is not successful#>
            $FailureFont = @{ForegroundColor = "Red"}
         <#Warning - Text formatting for informational items#>
            $WarningFont = @{ForegroundColor = "Yellow"}

<#Check whether the EMET 5.5 Administrative Template Markup language-specific (.adml) resources exist #>
$FileExistsEMETadml = Test-Path $EMETadml 
If ($FileExistsEMETadml -eq $True) {
Write-Host "
EMET.adml exists" @WarningFont
<#Move EMET.adml file to %SystemRoot% Policy Definitions (en-US) to enable EMET Templates in GPO#>
Copy-Item $EMETadml $Env:windir\PolicyDefinitions\en-US -Force
    Write-Host "     EMET.adml successfully moved" @SuccessFont}
    Else {Write-Host "EMET.adml file does not exist.  Check if EMET is installed or located in a directory other than $EMETadml" @FailureFont}

<#Check whether the EMET 5.5 Administrative Template Markup language-neutral (.admx) resources exist and#>
$FileExistsEMETadmx = Test-Path $EMETadmx 
If ($FileExistsEMETadmx -eq $True) {
Write-Host "
EMET.admx exists" @WarningFont
<#Move EMET.admx file to %SystemRoot% Policy Definitions to enable EMET Templates in GPO#>
Copy-Item $EMETadmx $Env:windir\PolicyDefinitions -Force
    Write-Host "     EMET.admx successfully moved" @SuccessFont}
        Else {Write-Host "EMET.admx file does not exist.  Check if EMET is installed or located in a directory other than $EMETadmx" @FailureFont}

 If ($RequirementsMet -eq $True) {
    Write-Host "
    Configuration in Progress..." @SystemFont}
        Else {Write-Host "
        Configuration requirements have not been met." @FailureFont}
