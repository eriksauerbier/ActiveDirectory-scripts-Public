# Selbstsigniertes Domänen-Wildcard Zertifikat erstellen (z.B. für TSFarm)
# Stannek GmbH - v.1.2 - 02.06.2022 - E.Sauerbier

# Paramter
$ExportPath = "C:\Util\"

# Domänen-Parameter auslesen
$domaininfo = Get-ADDomain
$certfilepfx = $domaininfo.forest + ".pfx"
$certfile = $domaininfo.forest + ".cer"
$certdns = "*." + $domaininfo.forest

# Zertifikat erstellen
$Certificate = New-SelfSignedCertificate -certstorelocation cert:\localmachine\my -dnsname $certdns -NotAfter (Get-Date).AddYears(10) -KeyExportPolicy Exportable

# Tumbprint abspeichern
$Tumbprint = $Certificate.thumbprint

# Passwort zum Exportieren hinterlegen
$Password = get-credential -UserName $certfile -Message 'Bitte Passwort für Zertifikat angeben:'

# Export-Pfad prüfen und ggf. Erstellen
If (!(Test-Path $ExportPath)) {New-Item -path $ExportPath -ItemType 'directory'}

# erstelltes Zertifikat exportieren
Export-PfxCertificate -cert cert:\localMachine\my\$Tumbprint -FilePath ($ExportPath+$certfilepfx) -Password $Password.Password
Export-Certificate -cert cert:\localMachine\my\$Tumbprint -FilePath ($ExportPath+$certfile)