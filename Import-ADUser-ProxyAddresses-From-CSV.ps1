## PS-Skript zum Import aller E-Mail-Adressen (Attribut: proxyAddresses) pro User
## Hinweis diese Skript überschreibt vorhandene Werten im Attribut proxyAddresses
## Stannek GmbH v.1.0 - 23.05.2025 - E.Sauerbier

# Parameter
$ADAttribute = "userPrincipalName, proxyAddresses" # Name des AD-Attributs angeben
$FileOutputName = "ADAttribute-$ADAttribute-"+(Get-Date -Format dd-MM-yyyy)+".csv"
$WorkPath = If($PSISE){Split-Path -Path $psISE.CurrentFile.FullPath}else{Split-Path -Path $MyInvocation.MyCommand.Path}
IF ($Null -eq $WorkPath) {$WorkPath = Split-Path $psEditor.GetEditorContext().CurrentFile.Path} #Falls Skript in VS Code ausgefuehrt wird


# ActiveDirectory PS-Modul laden
Import-Module ActiveDirectory

# Import CSV-Datei auswählen
$CSVFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$CSVFileDialog.initialDirectory = $WorkPath
$CSVFileDialog.filter = "CSV (*.csv)| *.csv"
$CSVFileDialog.ShowDialog() | Out-Null

# Inhalt der CSV auslesen
$FileImport  = Import-CSV -Path $CSVFileDialog.filename -Delimiter ","

# Attribut pro User pflegen
ForEach ($ImportUser In $FileImport) {
        # ProxyAddresses in Objekt aufteilen
        $NewproxyAddresses = $ImportUser.proxyAddresses.Split(" ")
        # User auslesen
        $User = Get-ADUser -Identity $ImportUser.Name -properties proxyAddresses
        # Attribut leeren
        $User.proxyAddresses = $Null
        # Leere Werte in User schreiben
        Set-ADUser -Instance $User
        # Importierte Attribute im User pflegen
        Foreach ($proxyAddress in $NewproxyAddresses) {          
             Set-ADUser -Identity $User -Add @{proxyAddresses=$proxyAddress}
             }
        }