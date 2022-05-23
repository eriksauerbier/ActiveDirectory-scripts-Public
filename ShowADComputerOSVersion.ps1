# Skript zum Anzeigen der OS-Version von Domänen PC's
# Stannek GmbH - v.1.0 - 23.05.2022 -E.Sauerbier

# Organisationseinheit erfragen, bei Abbruch wird das gesamte AD abgefragt
$OrgUnit = Get-ADOrganizationalUnit -Filter * | Select-Object DistinguishedName | Out-GridView -Title "Bitte wünschte Organisationseinheit angeben, für alle PCs der Domäne Abbrechen-Button drücken" -OutPutMode Single

# Abfrage der AD-Computer
If ($OrgUnit -eq $Null) {$OrgUnit = $Output = Get-ADComputer -Property OperatingSystemVersion, LastLogonDate -Filter * |Select-Object DNSHostName, OperatingSystemVersion, LastLogonDate, DistinguishedName | Sort-Object OperatingSystemVersion -Descending}
Else  {$Output = Get-ADComputer -SearchBase $OrgUnit.DistinguishedName -SearchScope Subtree -Property OperatingSystemVersion, LastLogonDate -Filter * |Select-Object DNSHostName, OperatingSystemVersion, LastLogonDate, DistinguishedName | Sort-Object OperatingSystemVersion -Descending}

# Bildschirmausgabe leeren
Clear-Host

# Ergebnis ausgeben
If ($days -eq "") {"`nIm ActiveDirectory befinden sich folgende Geräte"}
Else {Write-Host "`nFolgende PCs haben sich seit $days Tagen nicht mehr am ActiveDirectory angemeldet`n"}
Write-Host ($Output | Format-Table | Out-String)
Read-Host "Zum beenden beliebige Taste drücken"