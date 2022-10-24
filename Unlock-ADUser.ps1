# Skript zum entsperren von AD-Benutzern
# Stannek GmbH - Version 1.0 - 08.06.2022 ES

# Gesperrte Accounts im AD suchen und entsperren
Search-ADAccount -LockedOut -UsersOnly | Unlock-ADAccount -PassThru | Format-Table Name,UserPrincipalName

Read-Host "Zum beenden beliebige Taste drücken"
