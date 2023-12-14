# Skript zum aktivieren des ActiveDirectory Papierkorbs
# Stannek GmbH - Version 1.0 - 14.12.2023 ES

# Ad Feature aktivieren
Enable-ADOptionalFeature 'Recycle Bin Feature' -Scope ForestOrConfigurationSet -Target $(Get-ADDomain).Forest -Confirm:$false

Read-Host "zum beenden beliebige Taste druecken"