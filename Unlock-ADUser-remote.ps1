# Skript zum Remote entsperren von AD-Benutzern
# Stannek GmbH - Version 1.0 - 23.11.2022 ES

# Info: Das Feature RSAT-AD-PowerShell wird benötigt

# Parameter
$DC = "server.local"

# Gesperrte Accounts im AD suchen und entsperren
Search-ADAccount -LockedOut -UsersOnly -Server $DC | Unlock-ADAccount -PassThru | Format-Table Name,UserPrincipalName

Read-Host "Zum beenden beliebige Taste drücken"
