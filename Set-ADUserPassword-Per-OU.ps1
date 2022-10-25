# Dieses Skript setzt für alle User innerhalb der gewählte OU das User-Passwort
# Stannek GmbH v.1.1 - 20.10.2022 - E.Sauerbier

# Organisationseinheit auswählen
$OU = Get-ADOrganizationalUnit -Filter * | Out-GridView -Title "Organisationseinheit auswählen" -PassThru

# Skript abbrechen wenn keine OU ausgewählt wurde
If ($OU -eq $Null) {Break}

# Passwort auslsen
$Password = Get-Credential -UserName UserName -Message "Bitte das gewünschte Passwort eingeben"

# Skript abbrechen wenn Eingabe abgebrochen wurde
If ($Password -eq $Null) {Break}

# AD-Benutzer innerhalb der OU auslesen
$Users = Get-ADUser -Filter * -SearchBase $Ou.DistinguishedName

# Passwort für alle Benutzer der OU ändern
foreach ($User in $Users) {
        Set-ADAccountPassword -Identity $User -Reset -NewPassword $Password.Password -PassThru
        Write-Host "Passwort für $($User.Name) wurde gesetzt" -ForegroundColor Red
        }