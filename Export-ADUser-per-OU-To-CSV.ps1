# Dieses Skript exportiert alle AD-User aus einer OU in eine CSV
# Stannek GmbH v.1.0 - 02.08.2024 - E.Sauerbier

# Parameter
$FileOutputName = "AD-Benutzer-"+(Get-Date -Format dd-MM-yyyy)+".csv"

# Skriptpfad auslesen und Ausgabedatei erzeugen
$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
$FileOutput = $PSScriptRoot + "\" + $FileOutputName

# Organisationseinheit auswählen
$OU = Get-ADOrganizationalUnit -Filter * | Out-GridView -Title "Organisationseinheit auswählen" -PassThru

# Skript abbrechen wenn keine OU ausgewählt wurde
If ($OU -eq $Null) {Break}

# ADUser auslesen und in CSV exportiert
Get-ADUser -Filter * -SearchBase $Ou.DistinguishedName -Properties lastLogon,Mail,displayName,description | Select-Object Enabled, Surname, GivenName, samaccountname, Mail, displayName, @{Name="lastLogon";Expression={[datetime]::FromFileTime($_.'lastLogon')}}, description | Sort-Object -Property lastLogon | Export-Csv -Path $FileOutput -NoTypeInformation
