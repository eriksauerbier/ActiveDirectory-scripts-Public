## PS-Skript zum Anzeigen eines AD-Attributs pro User
## Stannek GmbH v.1.0 - 20.10.2022 - E.Sauerbier

# Parameter
$ADAttribute = "mail" # Name des AD-Attributs angeben

# ActiveDirectory PS-Modul laden
Import-Module ActiveDirectory

# Organisationseinheit erfragen
$OrgUnit = Get-ADOrganizationalUnit -Filter * | Select-Object Name, DistinguishedName | Out-GridView -Title "Bitte wünschte Organisationseinheit angeben" -OutPutMode Single

# Attribut "ProxyAddresses" auslesen

$ADObjects = Get-ADObject -SearchBase $OrgUnit.DistinguishedName -Filter * -Properties $ADAttribute

# Werte in CSV schreiben und ausgeben
ForEach ($Object In $ADObjects) {
  ForEach ($Attribute in $Object.$ADAttribute) {
    $Output = $Object.Name + "," + $Attribute
    # Zeile ausgeben
    Write-Host $Output
  }
}
