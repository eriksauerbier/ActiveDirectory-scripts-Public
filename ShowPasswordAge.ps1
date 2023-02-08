# Skript zum anzeigen des Passwortalters aller Benutzer
# Stannek GmbH - v.1.02 - 08.02.2023 -E.Sauerbier

# Passwortalter auslesen
Get-ADUser -filter { Enabled -eq $True } –Properties PwdLastSet | Select-Object sAmAccountName, @{name ="pwdLastSet";expression={[datetime]::FromFileTime($_.pwdLastSet)}} | Sort-Object -Property PwdLastSet,sAmAccountName | FT -AutoSize 

Read-Host "Zum beenden beliebige Taste drücken"