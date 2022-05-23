# Dieses Skript zeigt den letzten Anmeldezeitpunkt von AD-User an
# Stannek GmbH v.1.2 - 23.05.2022 - E.Sauerbier

# Benutzer-Abfrage zum Alter in Tagen
Write-Host "`nAD-Benutzer Anzeigen die seit X Tagen nicht mehr angemeldet waren."
$days = Read-Host "X in Tage oder ENTER für alle Benutzer"

# Abfrage Tag errechnen
$QueryDay = (Get-Date).addDays(-$days)

# Organisationseinheit erfragen, bei Abbruch wird das gesamte AD abgefragt
$OrgUnit = Get-ADOrganizationalUnit -Filter * | Select-Object DistinguishedName | Out-GridView -Title "Bitte wünschte Organisationseinheit angeben, für alle User der Domäne Abbrechen-Button drücken" -OutPutMode Single

# Abfrage der AD-User
If ($OrgUnit -eq $Null) {$Output = Get-ADUser -Filter {lastLogon -le $QueryDay} -Properties lastLogon,Mail | Select-Object Surname, GivenName, Enabled, Mail, @{Name="lastLogon";Expression={[datetime]::FromFileTime($_.'lastLogon')}}, samaccountname | Sort-Object lastLogon}
Else  {$Output = Get-ADUser -SearchBase $OrgUnit.DistinguishedName -SearchScope Subtree -Filter {lastLogon -le $QueryDay} -Properties lastLogon,Mail | Select-Object Surname, GivenName, Enabled, Mail, @{Name="lastLogon";Expression={[datetime]::FromFileTime($_.'lastLogon')}}, samaccountname | Sort-Object lastLogon}

# Bildschirmausgabe leeren
#Clear-Host

# Ergebnis ausgeben
If ($days -eq "") {"`nIm ActiveDirectory befinden sich folgende Benutzer"}
Else {Write-Host "`nFolgende AD-Benutzer haben sich seit $days Tagen nicht mehr am ActiveDirectory angemeldet`n"}
$Output | Select-Object Surname, GivenName, Enabled, Mail, lastLogon, samaccountname | Format-Table -AutoSize
Read-Host "Zum beenden beliebige Taste drücken"