# Dieses Skript zeigt das Erstelldatum von AD-Usern an
# Stannek GmbH v.1.0 - 23.05.2022 - E.Sauerbier

# Organisationseinheit auslesen
$OrgUnit = Get-ADOrganizationalUnit -Filter * | Select-Object DistinguishedName | Out-GridView -Title "Bitte wünschte Organisationseinheit angeben, für alle User der Domäne Abbrechen-Button drücken" -OutPutMode Single

# AD-User auslesen
$Output = Get-ADUser -SearchBase $OrgUnit.DistinguishedName -SearchScope Subtree -Filter * -Properties whenCreated | Sort-Object whenCreated

Write-Host ($Output | Select-Object Name, whenCreated | Format-Table | Out-String)
Read-Host "Zum beenden beliebige Taste drücken"