## PS-Skript zum Exportieren aller E-Mail-Adressen (Attribut: mail) pro User
## Stannek GmbH v.1.0 - 03.04.2025 - E.Sauerbier

# Parameter
$ADAttribut = 'mail' # Name des AD-Attributs angeben
$FileOutputName = "ADAttribute-$ADAttribut-"+(Get-Date -Format dd-MM-yyyy)+".csv"

# ActiveDirectory PS-Modul laden
Import-Module ActiveDirectory

# Skriptpfad auslesen und Ausgabedatei erzeugen
$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
$FileOutput = $PSScriptRoot + "\" + $FileOutputName
"Name,userPrincipalName,$ADAttribut" | Out-File $FileOutput

# Organisationseinheit erfragen
$OrgUnit = Get-ADOrganizationalUnit -Filter * | Select-Object Name, DistinguishedName | Out-GridView -Title "Bitte wünschte Organisationseinheit angeben" -OutPutMode Single

# Attribute auslesen
$ADObjects = Get-ADObject -SearchBase $OrgUnit.DistinguishedName -Filter "Mail -like '*@*'" -Properties userPrincipalName, mail

# Werte in CSV schreiben und ausgeben
ForEach ($Object In $ADObjects) {
  #ForEach ($Attribute in $Object.$ADAttribute) {
    $Output = $Object.Name + "," + $Object.userPrincipalName + "," + $Object.mail
    # Zeile ausgeben
    Write-Host $Output
    # Wert in CSV schreiben
    $Output | Out-File $FileOutput -Append
  #}
}
