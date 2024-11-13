# Skript zum umbenennen von AD Gruppen
# Stannek GmbH  v.1.0 - 13.11.2024 - E.Sauerbier

# Parameter
$OldGroupName = 'Alte Gruppe'
$NewGroupName =  'Neue Gruppe' 
$NewDescrip = "Gruppe"

# checken ob Gruppe vorhanden
try {Get-ADGroup -Identity $OldGroupName}
catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
{Write-Host "Gruppe nicht vorhanden";break}

# Gruppe umbenennen
Get-ADGroup -Identity $OldGroupName | Rename-ADObject -NewName $NewGroupName
Get-ADGroup -Identity $OldGroupName | Set-ADGroup -SamAccountName $NewGroupName -DisplayName $NewGroupName -Description $NewDescrip