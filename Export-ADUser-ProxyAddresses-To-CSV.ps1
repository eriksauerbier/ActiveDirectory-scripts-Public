## PS-Skript zum Exportieren aller E-Mail-Adressen (Attribut: proxyAddresses) pro User
## Stannek GmbH v.1.1 - 03.04.2025 - E.Sauerbier

# Parameter
$ADAttribute = "userPrincipalName, proxyAddresses" # Name des AD-Attributs angeben
$FileOutputName = "ADAttribute-$ADAttribute-"+(Get-Date -Format dd-MM-yyyy)+".csv"
$internalDomain = "dom.local" # Lokale Domain

# ActiveDirectory PS-Modul laden
Import-Module ActiveDirectory

# Skriptpfad auslesen und Ausgabedatei erzeugen
$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
$FileOutput = $PSScriptRoot + "\" + $FileOutputName
"Name,$ADAttribute" | Out-File $FileOutput

# Organisationseinheit erfragen
$OrgUnit = Get-ADOrganizationalUnit -Filter * | Select-Object Name, DistinguishedName | Out-GridView -Title "Bitte wünschte Organisationseinheit angeben" -OutPutMode Single

# Attribut "ProxyAddresses" auslesen

$ADObjects = Get-ADObject -SearchBase $OrgUnit.DistinguishedName -Filter "Mail -like '*@*'" -Properties userPrincipalName, proxyAddresses

# Werte in CSV schreiben und ausgeben
ForEach ($Object In $ADObjects) {
        # Proxy-Adressen nullen
        $proxyAddresses = $Null
        # Proxy-Adressen auslesen
        Foreach ($proxyAddress in $Object.proxyAddresses) {
         # X500- und interne Domain-Adressen ausschliessen
         If (($proxyAddress -notlike "x500:/*") -and ($proxyAddress -notlike "*@$internalDomain")) {
                $proxyAddresses += @($proxyAddress)
                }
         }
       # Ausgabe erstellen
       $Output = $Object.Name+ "," + $Object.userPrincipalName + "," + $proxyAddresses
       # Zeile zur Info ausgeben
       Write-Host $Output
       # Wert in CSV schreiben
       $Output | Out-File $FileOutput -Append
   }
