# Dieses Skript exportiert alle AD-User in eine CSV
# Stannek GmbH v.1.0 - 23.05.2022 - E.Sauerbier

# Parameter
$FileOutputName = "AD-Benutzer-"+(Get-Date -Format dd-MM-yyyy)+".csv"

# Skriptpfad auslesen und Ausgabedatei erzeugen
$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
$FileOutput = $PSScriptRoot + "\" + $FileOutputName

# ADUser auslesen und in CSV exportiert
Get-ADUser -Filter * -Properties lastLogon,Mail,displayName,description | Select-Object Enabled, Surname, GivenName, samaccountname, Mail, displayName, @{Name="lastLogon";Expression={[datetime]::FromFileTime($_.'lastLogon')}}, description | Sort-Object -Property lastLogon | Export-Csv -Path $FileOutput -NoTypeInformation
