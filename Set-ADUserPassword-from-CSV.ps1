# Skript zum ändern der User-Passwörter anhand einer CSV-Datei
# Stannek GmbH - v.1.1 - 24.10.2022 - E.Sauerbier

# Info
# Als CSV-Vorlage kann das Export-CSV vom Skript "Generate-RandomPassword-per-OU.ps1"
# Oder eine CSV mit folgenden Paramtern ""sAMAccountName","UPN,","Password"

# Parameter


# Skriptpfad auslesen
$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition

# CSV-Datei auswählen
$CSVFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$CSVFileDialog.initialDirectory = $PSScriptRoot
$CSVFileDialog.filter = "CSV (*.csv)| *.csv"
$CSVFileDialog.ShowDialog() | Out-Null


# Inhalt der CSV auslesen

$Users = Import-CSV -Path $CSVFileDialog.filename -Delimiter ","

# Passwort für alle Benutzer
foreach ($User in $Users) {
# Passwort generieren
Set-ADAccountPassword -Identity $User.sAMAccountName -NewPassword (ConvertTo-SecureString -String $User.Password -AsPlainText -Force) -PassThru -Reset
Write-Host "Passwort für $($User.UPN) wurde auf $($User.Password) gesetzt" -ForegroundColor Red
}