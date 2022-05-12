# Skript zum anzeigen des Passwortalters aller Benutzer
# Stannek GmbH - v.1.01 - 12.05.2022 -E.Sauerbier

Get-ADUser -filter { Enabled -eq $True } –Properties PwdLastSet | select sAmAccountName, @{name ="pwdLastSet";expression={[datetime]::FromFileTime($_.pwdLastSet)}} | Sort-Object -Property sAmAccountName | FT -AutoSize 