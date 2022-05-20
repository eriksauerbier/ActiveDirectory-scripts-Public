# Dieses Skript zeigt den letzten Anmeldezeitpunkt von AD-User an
# Stannek GmbH v.1.1 - 20.05.2022 - E.Sauerbier

# Benutzer-Abfrage zum Alter in Tagen
Write-Host "`nAD-Benutzer Anzeigen die seit X Tagen nicht mehr angemeldet waren."
$days = Read-Host "X in Tage oder ENTER für alle Benutzer"

# Abfrage Tag errechnen
$QueryDay = (Get-Date).addDays(-$days)

# Abfrage der AD-User
$Output = Get-ADUser -Filter {lastLogon -le $QueryDay} -Properties lastLogon,Mail | Select Surname, Name, Enabled, samaccountname, Mail, @{Name="lastLogon";Expression={[datetime]::FromFileTime($_.'lastLogon')}} | Sort-Object lastLogon -Descending | Format-Table

# Bildschirmausgabe leeren
Clear-Host

# Ergebnis ausgeben
If ($days -eq "") {"`nIm ActiveDirectory befinden sich folgende Benutzer"}
Else {Write-Host "`nFolgende AD-Benutzer haben sich seit $days Tagen nicht mehr am ActiveDirectory angemeldet`n"}
Write-Host ($Output | Format-Table | Out-String)
Read-Host "Zum beenden beliebige Taste drücken"
