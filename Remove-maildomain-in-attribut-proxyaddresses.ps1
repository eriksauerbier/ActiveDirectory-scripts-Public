# Skript zum entfernen einer alten E-Mail Domain im Attribut "proxyaddresses"
# Stannek GmbH - v.1.0 - 28.01.2025 - E.Sauerbier

# Parameter
$olddomain = "@olddomain.com"

# Organisationseinheit erfragen
$OrgUnit = Get-ADOrganizationalUnit -Filter * | Select-Object DistinguishedName | Out-GridView -Title "Bitte wünschte Organisationseinheit angeben, in der die Benutzerpasswörter geändert werden sollen" -OutPutMode Single

# Skript abbrechen wenn keine OU ausgewählt wurde
If ($OrgUnit -eq $Null) {Break}

# User auslesen
$Users = Get-ADUser -Filter * -SearchBase $OrgUnit.DistinguishedName -Properties proxyAddresses,mail,Surname,givenName | Select SamAccountName,proxyAddresses,mail,Surname,givenName

# weitere E-Mail-Adresse hinzufügen
foreach ($User in $Users) {
  If ($User.proxyAddresses -like $("*"+$olddomain)) {
  # Hinweis für aktuellen Benutzer ausgegben
  Write-Host "Bearbeite Nutzer: "$User.SamAccountName
  # Wenn das Attribut die zu loeschende Domain enthaelt dann diese entfernen
        Foreach ($proxyAddress in $user.proxyaddresses) {
            If ($proxyAddress -like $("*"+$olddomain)) {$removedAddress = $proxyAddress}
            }
        Write-Host "entferne Adresse: " $removedAddress
        Set-ADUser -Identity $User.SamAccountName -Remove @{proxyAddresses=$removedAddress}
        }
  } 


# Gruppen auslesen
$Groups = Get-ADGroup -Filter * -SearchBase $OrgUnit.DistinguishedName -Properties proxyAddresses,mail | Select SamAccountName,proxyAddresses,mail

# weitere E-Mail-Adresse hinzufügen
foreach ($Group in $Groups) {
  If ($Group.proxyAddresses -like $("*"+$olddomain)) {
  # Hinweis für aktuellen Benutzer ausgegben
  Write-Host "Bearbeite Gruppe: "$Group.SamAccountName
  # Wenn das Attribut die zu loeschende Domain enthaelt dann diese entfernen
  Foreach ($GroupproxyAddress in $Group.proxyaddresses) {
            If ($GroupproxyAddress -like $("*"+$olddomain)) {$GroupremovedAddress = $GroupproxyAddress}
            }
  Write-Host "entferne Adresse: " $GroupremovedAddress
  Set-ADGroup -Identity $Group.SamAccountName -Remove @{proxyAddresses=$GroupremovedAddress}
  }
  } 