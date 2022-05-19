# Dieses Skript zeigt den letzten Anmeldezeitpunkt alle AD-User an
# Stannek GmbH v.1.0 - 19.05.2022 - E.Sauerbier

Get-ADUser -Filter * -Properties lastLogon,Mail | Select Surname, Name, Enabled, samaccountname, Mail, @{Name="lastLogon";Expression={[datetime]::FromFileTime($_.'lastLogon')}} | Sort-Object lastLogon -Descending | Format-Table

Read-Host "Zum beenden beliebige Taste drücken"