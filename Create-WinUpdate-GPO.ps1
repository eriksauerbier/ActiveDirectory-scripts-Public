# Dieses Skript erstellen und verlinkt ein WindowsUpdate GPO
# Stannek GmbH v.1.01 - 29.04.2022 - E.Sauerbier

#Parameter
$GPOName = "WinUpdate"

# Prüfen ob GPO bereits vorhanden ist
If ((Get-GPO -Name $GPOName -ErrorAction SilentlyContinue) -ne $Null) {

    # Root OU auslesen
    $RootOU = Get-ADDomain | Select-Object -ExpandProperty DistinguishedName

    # GPO erstellen
    New-GPO -Name $GPOName -Comment "29.04.2022 - Richtlinie erstellt"

    # GPO verlinken
    New-GPLink -Name $GPOName -LinkEnabled Yes -Target $RootOU -Enforced Yes

    # GPO konfigurieren

    Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\" -ValueName "UpdateNotificationLevel" -Value 1 -Type DWord
    Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\" -ValueName "SetUpdateNotificationLevel" -Value 1 -Type DWord
    Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\" -ValueName "ExcludeWUDriversInQualityUpdate" -Value 1 -Type DWord
    Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\" -ValueName "ElevateNonAdmins" -Value 0 -Type DWord
    Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -ValueName "AllowMUUpdateService" -Value 1 -Type DWord
    Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -ValueName "AUOptions" -Value 3 -Type DWord
    Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -ValueName "IncludeRecommendedUpdates" -Value 1 -Type DWord
    Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -ValueName "NoAutoUpdate" -Value 0 -Type DWord
    Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -ValueName "ScheduledInstallDay" -Value 0 -Type DWord
    Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -ValueName "ScheduledInstallEveryWeek" -Value 1 -Type DWord
    Set-GPRegistryValue -Name $GPOName -Key "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" -ValueName "ScheduledInstallTime" -Value 23 -Type DWord
    }