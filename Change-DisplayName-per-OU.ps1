# Skript zum Ändern des Anzeigenamens und bei Bedarf Firmenname + Homepage
# Stannek GmbH - v.1.0 - 03.04.2024 - E.Sauerbier

# Parameter
$NewCompanyName = "Now Kanzlei"
$NewDisplayNameSuffix = " - Now Kanzlei"
$NewHomePage = "www.now-kanzlei.de"

# Organisationseinheit erfragen
$OrgUnit = Get-ADOrganizationalUnit -Filter * | Select-Object DistinguishedName | Out-GridView -Title "Bitte wünschte Organisationseinheit angeben, in der der Anzeigename geändert werden sollen" -OutPutMode Single

# Skript abbrechen wenn keine OU ausgewählt wurde
If ($OrgUnit -eq $Null) {Break}

# User auslesen
$Users = Get-ADUser -Filter * -SearchBase $OrgUnit.DistinguishedName -Properties SamAccountName,sn,givenName,wWWHomePage,Company,displayName | Select SamAccountName,sn,givenName,wWWHomePage,Company,displayName

# Userdaten aktualisieren
foreach ($User in $Users) {
  # Hinweis für aktuellen Benutzer ausgegben
  Write-Host "Bearbeite Nutzer: "$User.SamAccountName
  Set-ADUser -Identity $User.SamAccountName -Company $NewCompanyName -DisplayName $($User.sn + $NewDisplayNameSuffix) -HomePage $NewHomePage
  }