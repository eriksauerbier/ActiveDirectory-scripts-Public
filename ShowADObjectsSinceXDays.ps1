# Skript zum Abfragen von erstellen AD-Objekten der letzten X Tage
# Stannek GmbH - v.1.0 - E.Sauerbier

# Benutzer-Abfrage zum Alter in Tagen
Write-Host "`nAD-Objekte anzeigen, die innerhalb der letzten X Tage erstellt wurden"
$sincedays = Read-Host "X in Tage oder ENTER für alle Objekte"

If ($sincedays -eq "") {$sincedays = (((New-TimeSpan -Start ((Get-ADUser -Identity Administrator -Properties whenCreated).whenCreated) -End (Get-Date)).Days)+1)}

$OutputUser = Get-ADUser -Filter * -Properties whenCreated | Where-Object { $_.whenCreated -gt (Get-Date).AddDays(-$sinceDays) } | Select-Object Name, whenCreated, ObjectClass |Sort-Object whenCreated
$OutputComputer = Get-ADComputer -Filter * -Properties whenCreated | Where-Object { $_.whenCreated -gt (Get-Date).AddDays(-$sinceDays) } | Select-Object Name, whenCreated, ObjectClass |Sort-Object whenCreated
$OutputGroup = Get-ADGroup -Filter * -Properties whenCreated | Where-Object { $_.whenCreated -gt (Get-Date).AddDays(-$sinceDays) } | Select-Object Name, whenCreated, ObjectClass |Sort-Object whenCreated

# Bildschirmausgabe leeren
Clear-Host

# Ergebnis ausgeben
Write-Host "Folgende AD-Objekte sind innerhalb $sincedays Tagen erstellt wurden"
Write-Host ($OutputUser | Format-Table | Out-String)
Write-Host ($OutputComputer | Format-Table | Out-String)
Write-Host ($OutputGroup | Format-Table | Out-String)
Read-Host "Zum beenden beliebige Taste drücken"