# Skript zum installieren einer MSI
# Stannek GmbH - v.1.1 - 01.08.2022 - E.Sauerbier

# Parameter
$ProgName = "Name of Prog" # Use this Command to show the Names: Get-WmiObject -Class Win32_Product
$ProgMSI = "\\PATH-TO-MSI\WFBS-SVC_Agent_Installer.msi"

# Prüfen ob Programm installiert ist
If ((Get-WmiObject -Class Win32_Product |Where-Object Name -eq $ProgName) -eq $Null) {
        #Installieren des Programms
        $InstallArgs="/I $ProgMSI /quiet"
        Start-Process "msiexec.exe" -ArgumentList $InstallArgs -wait -nonewwindow 
        }