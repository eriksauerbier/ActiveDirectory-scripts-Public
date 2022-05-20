# Skript zum Anzeigen alter Domänen PC's
# Stannek GmbH - v.1.0 - 20.05.2022 -E.Sauerbier

# Benutzer-Abfrage zum Alter in Tagen
Write-Host "`nGeräte Anzeigen die seit X Tagen nicht mehr angemeldet waren."
$Days = Read-Host "X in Tage oder ENTER für alle Geräte"

# Organisationseinheit erfragen
$OrgUnit = Get-ADOrganizationalUnit -Filter * | Select-Object DistinguishedName | Out-GridView -Title "Bitte wünschte Organisationseinheit angeben, Abbrechen für alle PCs" -PassThru
If ($OrgUnit -eq $Null) {$OrgUnit = "*"}

# Abfrage Tag errechnen
$QueryDay = (Get-Date).addDays(-$Days)

# Abfrage der AD-Computer
$Output = Get-ADComputer -SearchBase $OrgUnit.DistinguishedName -Property LastLogonDate -Filter {lastLogonDate -lt $QueryDay} |Select-Object DNSHostName, LastLogonDate, DistinguishedName | Sort-Object LastLogonDate

# Bildschirmausgabe leeren
Clear-Host

# Ergebnis ausgeben
If ($days -eq "") {"`nIm ActiveDirectory befinden sich folgende Geräte"}
Else {Write-Host "`nFolgende PCs haben sich seit $days Tagen nicht mehr am ActiveDirectory angemeldet`n"}
Write-Host ($Output | Format-Table | Out-String)
Read-Host "Zum beenden beliebige Taste drücken"