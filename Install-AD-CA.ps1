# Skript zum Installieren einer ActiveDirectory Zertifizierungsstelle
# Stannek GmbH - v.1.1 - 15.05.2024 - E.Sauerbier

# Parameter
$ParamCAVPU = 7 # Gueltigkeitsdauer der CA-Zertifikate
$ParamVPU = 5 # Gueltigkeitsdauer der Zertifikate

# pruefen ob die Zertifizierungsstelle bereits installiert ist
If ($(Get-WindowsFeature -Name ADCS-Cert-Authority).InstallState -ne "Installed") {
  
    # Windows Feature installieren
    Install-WindowsFeature -Name ADCS-Cert-Authority -IncludeManagementTools

    # Zertifizierungsstelle einrichten
    Install-AdcsCertificationAuthority -CAType EnterpriseRootCa -CryptoProviderName "RSA#Microsoft Software Key Storage Provider" -KeyLength 4096 -HashAlgorithmName SHA512 -ValidityPeriod Years -ValidityPeriodUnits $ParamCAVPU -Force

    # kurzen moment warten
    Start-Sleep -Seconds 30

    # Gueltigkeitsdauer der Zertifikate verlaengern
    certutil -setreg ca\ValidityPeriodUnits $ParamVPU
    
    # Dienst neustartet
    Restart-Service -Name CertSvc -Force

    # falls vorhanden Altlasten entfernen
    If (Test-Path -Path 'HKLM:/Software/Microsoft/Cryptography/Services/NTDS/SystemCertificates/My/Certificates') {Remove-Item -Path 'HKLM:/Software/Microsoft/Cryptography/Services/NTDS' -Recurse -Force}

    # Richtlinien aktualisieren
    gpupdate /force
    }
Else {Throw "Zertifizierungsstelle bereits installiert"}
