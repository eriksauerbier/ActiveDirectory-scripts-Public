## PS-Skript zum Exportieren aller E-Mail-Adressen (Attribut: proxyAddresses) pro User
## Stannek GmbH v.1.0 - 01.07.2024 - E.Sauerbier

# Parameter
$ADAttribute = "userPrincipalName, proxyAddresses" # Name des AD-Attributs angeben
$FileOutputName = "ADAttribute-$ADAttribute-"+(Get-Date -Format dd-MM-yyyy)+".csv"

# ActiveDirectory PS-Modul laden
Import-Module ActiveDirectory

# Skriptpfad auslesen und Ausgabedatei erzeugen
$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
$FileOutput = $PSScriptRoot + "\" + $FileOutputName
"Name,$ADAttribute" | Out-File $FileOutput

# Organisationseinheit erfragen
$OrgUnit = Get-ADOrganizationalUnit -Filter * | Select-Object Name, DistinguishedName | Out-GridView -Title "Bitte wünschte Organisationseinheit angeben" -OutPutMode Single

# Attribut "ProxyAddresses" auslesen

$ADObjects = Get-ADObject -SearchBase $OrgUnit.DistinguishedName -Filter * -Properties userPrincipalName, proxyAddresses

# Werte in CSV schreiben und ausgeben
ForEach ($Object In $ADObjects) {
  #ForEach ($Attribute in $Object.$ADAttribute) {
    $Output = $Object.Name+ "," + $Object.userPrincipalName + "," + $Object.proxyAddresses
    # Zeile ausgeben
    Write-Host $Output
    # Wert in CSV schreiben
    $Output | Out-File $FileOutput -Append
  #}
}
