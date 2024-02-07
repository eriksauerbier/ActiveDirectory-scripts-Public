# Skript zum hinzufügen einer weiteren E-Mail Domain im Attribut "proxyaddresses"
# Stannek GmbH - v.1.1 - 07.02.2024 - E.Sauerbier

# Parameter
$newdomain = "@newdomain.com"


# Organisationseinheit erfragen
$OrgUnit = Get-ADOrganizationalUnit -Filter * | Select-Object DistinguishedName | Out-GridView -Title "Bitte wünschte Organisationseinheit angeben, in der die Benutzerpasswörter geändert werden sollen" -OutPutMode Single

# Skript abbrechen wenn keine OU ausgewählt wurde
If ($OrgUnit -eq $Null) {Break}

# User auslesen
$Users = Get-ADUser -Filter * -SearchBase $OrgUnit.DistinguishedName -Properties proxyAddresses,mail,Surname,givenName | Select SamAccountName,proxyAddresses,mail,Surname,givenName

# weitere E-Mail-Adresse hinzufügen
foreach ($User in $Users) {
  # Hinweis für aktuellen Benutzer ausgegben
  Write-Host "Bearbeite Nutzer: "$User.SamAccountName
  # Hauptadresse setzen, falls dies noch nicht geschehen
  If ($user.proxyaddresses -notcontains "SMTP:$($User.mail)") {
  Set-ADUser -Identity $User.SamAccountName -Add @{proxyAddresses="SMTP:"+$User.mail}}
  # weitere Adresse mit neuer Domäne hinzufügen
  Set-ADUser -Identity $User.SamAccountName -Add @{proxyAddresses="smtp:"+$User.mail.Split("@")[0]+$newdomain}
  # Falls die neue Adresse abweichend ist. Auf Umlaute achten!
  #Set-ADUser -Identity $User.SamAccountName -Add @{proxyAddresses="smtp:"+$User.givenName+"."+$User.Surname+$newdomain}
  } 