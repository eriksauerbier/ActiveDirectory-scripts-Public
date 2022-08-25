 # Skript zum ändern der User-Passwörter auf OU-Ebene
# Stannek GmbH - v.1.0 - 25.08.2022 - E.Sauerbier
 
 # Organisationseinheit erfragen
$OrgUnit = Get-ADOrganizationalUnit -Filter * | Select-Object DistinguishedName | Out-GridView -Title "Bitte wünschte Organisationseinheit angeben, in der die Benutzerpasswörter geändert werden sollen" -OutPutMode Single

# Zukünftiges Passwort abfragen
$Password = read-host "Neues Benutzerpasswort eingeben" -asSecureString

# Passwortänderung durchführen
Get-ADUser -SearchBase $OrgUnit.DistinguishedName -Filter "*" | Set-ADAccountPassword -NewPassword $Password -Reset -PassThru 