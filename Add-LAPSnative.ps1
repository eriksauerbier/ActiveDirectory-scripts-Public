# Dieses Skript bereitet die ActiveDirectory Domaene für LAPS native vor
# Stannek GmbH v.1.1 - 22.11.2023 - E.Sauerbier

# Parameter
$GPONameLAPS = "LAPS-native"
$GPODescription = "LAPS native - Stand: 21.11.2023`r`n-Anhebung der Kennworthistory`r`nLAPS native - Stand: 19.10.2023`r`n- Erste Version"
$PathADMXLaps = Join-Path -Path $env:SystemRoot -ChildPath "PolicyDefinitions\LAPS.ADMX"
$PathADMLLaps = Join-Path -Path $env:SystemRoot -ChildPath "PolicyDefinitions\de-DE\LAPS.ADML"
$PathCentralPD = Join-Path -Path $env:SystemRoot -ChildPath "SYSVOL\domain\Policies\PolicyDefinitions"

# Check ob LAPS native bereits eingerichtet ist, wenn ja Skript abbrechen
If ($(get-gpo -Name $GPONameLAPS -ErrorAction SilentlyContinue).Computer.Enabled -eq $True) {Throw "LAPS native bereits eingerichtet"}

# Check ob LAPS ADMX vorhanden, wenn nicht Skript abbrechen
If (!(Test-Path -Path $PathADMXLaps)) {Throw "LAPS Native ADMX-File fehlt, Update notwendig oder Server nicht 2019 oder neuer"}

# Check ob es einen CentralPolicy-Store gibt und auch ADMX/ADML-Files entsprechend kopieren
if (Test-Path $PathCentralPD) {
        Copy-Item -Path $PathADMXLaps -Destination $PathCentralPD -Force -Verbose
        Copy-Item -Path $PathADMLLaps -Destination $(Join-Path -Path $PathCentralPD -ChildPath "de-DE") -Force -Verbose
        }

# Root OU auslesen
$RootOU = Get-ADDomain | Select-Object -ExpandProperty DistinguishedName

# AD-Schema aktualisieren
Update-LapsADSchema -Confirm:$false -verbose

# Berechtigung fuer Computer-Objekte zum aktualisieren des Kennworts geben
# In diesem Fall auf die Root-OU
Set-LapsADComputerSelfPermission -Identity $RootOU

# leere GPO erstellen und verknuepfen
New-GPO -Name $GPONameLAPS
New-GPLink -Name $GPONameLAPS -LinkEnabled Yes -Target $RootOU

# GPO Status auf nur Computer stellen und Kommentar setzen
(Get-GPO -Name $GPONameLAPS).GPOStatus = "UserSettingsDisabled"
(Get-GPO -Name $GPONameLAPS).Description=$GPODescription

# GPO Einstellungen setzen
Set-GPRegistryValue -Name $GPONameLAPS -Key "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\LAPS" -ValueName "ADBackupDSRMPassword" -Value 1 -Type DWord | Out-Null
Set-GPRegistryValue -Name $GPONameLAPS -Key "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\LAPS" -ValueName "ADEncryptedPasswordHistorySize" -Value 7 -Type DWord | Out-Null
Set-GPRegistryValue -Name $GPONameLAPS -Key "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\LAPS" -ValueName "ADPasswordEncryptionEnabled" -Value 1 -Type DWord | Out-Null
Set-GPRegistryValue -Name $GPONameLAPS -Key "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\LAPS" -ValueName "BackupDirectory" -Value 2 -Type DWord | Out-Null
Set-GPRegistryValue -Name $GPONameLAPS -Key "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\LAPS" -ValueName "PasswordAgeDays" -Value 30 -Type DWord | Out-Null
Set-GPRegistryValue -Name $GPONameLAPS -Key "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\LAPS" -ValueName "PasswordComplexity" -Value 4 -Type DWord | Out-Null
Set-GPRegistryValue -Name $GPONameLAPS -Key "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\LAPS" -ValueName "PasswordLength" -Value 14 -Type DWord | Out-Null