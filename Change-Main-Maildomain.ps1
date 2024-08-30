# Skript zum Tauschen der primaeren E-Mail Adresse, der Proxy-Adressen und des UPN
# Stannek GmbH - v.0.9 - 30.08.2024 - E.Sauerbier - BETA

# Es gibt noch Probleme, wenn ein User mehr als eine Adresse für die neue Hauptdomain hat

# Organisationseinheit erfragen
$OrgUnit = Get-ADOrganizationalUnit -Filter * | Select-Object DistinguishedName | Out-GridView -Title "Bitte wünschte Organisationseinheit angeben" -OutPutMode Single

# Skript abbrechen wenn keine OU ausgewählt wurde
If ($OrgUnit -eq $Null) {Break}

# User auslesen
$Users = Get-ADUser -SearchBase $OrgUnit.DistinguishedName -Filter 'Name -like "*"' -Properties EmailAddress,ProxyAddresses | select Name,EmailAddress, ProxyAddresses

# neue Domain auslesen
$NewDomain = Get-ADForest | Select-Object -ExpandProperty UPNSuffixes | Out-GridView -Title "Bitte neue Standard E-Mail-Domain auswaehlen" -OutputMode Single

# einzelne User anpassen
foreach ($User in $Users) {
    # Info zum bearbeitende User ausgeben
    write-host "`n`rBenutzer" $User.name "wird angepasst" -ForegroundColor Cyan
    Write-Host "Der Benutzer hat folgende ProxyAddresses:" $User.proxyaddresses -ForegroundColor Yellow

    foreach ($ProxyAddress in $User.proxyaddresses) {
            # Adresse trennen
            $Prot=$ProxyAddress.split(":")
            If (($Prot[0] -ceq "SMTP") -and ($Prot[1] -like $("*"+$NewDomain))) {
                Write-Host "Es muss nichts fuer $ProxyAddress angepasst werden" -ForegroundColor Green
                break
                }
                                
             # Wenn das SMTP-Protokoll groß geschrieben ist, dann aendern
                if ($Prot[0] -ceq "SMTP") {
                    $NewOldAdress="smtp:" + $Prot[1]
                
                    # Info ausgeben
                    Write-Host "bearbeite" $ProxyAddress -ForegroundColor Red
                
                    # Alte Haupt-Adresse entfernen
                    Set-ADUser -Identity $User.Name -Remove @{ProxyAddresses=$ProxyAddress}
                
                    # alte Hauptadresse als weitere hinzufuegen
                    Set-ADUser -Identity $User.Name -Add @{ProxyAddresses=$NewOldAdress}    
                    }

                # neue Domain zur Hauptadresse machen
                if ($Prot[1] -like $("*"+$NewDomain)) {
                   # neue Adresse erzeugen                    
                   $NewAdress="SMTP:" + $Prot[1]
                   # Info ausgeben
                   Write-Host "bearbeite neue Haupt-Adresse" $ProxyAddress -ForegroundColor Magenta
                   # Alte Adresse entfernen
                   Set-ADUser -Identity $User.Name -Remove @{ProxyAddresses=$ProxyAddress}
                   
                   # alte Adresse als Hauptadresse hinzufuegen
                   Set-ADUser -Identity $User.Name -Add @{ProxyAddresses=$NewAdress}  
                
                   # Attribut Mail aktualisieren
                   Set-ADUser -Identity $User.Name -EmailAddress $($NewAdress.split(":"))[1]

                   # UPN anpassen
                   Set-ADUser -Identity $User.Name -UserPrincipalName $($NewAdress.split(":"))[1]
                
                   # Info ausgeben
                   Write-Host "Der User $($User.Name) hat nun die Haupt-Adresse $($($NewAdress.split(":"))[1])" -ForegroundColor DarkGreen
                }
                }
}


