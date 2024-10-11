$certs=get-childitem -path cert:/LocalMachine/My
foreach ($c in $certs) {   
    if ($c.Subject.IndexOf("CN=*.") -eq 0) {
        write-host -ForegroundColor Yellow  $c.Subject
        $t=[string]$c.thumbprint
        wmic /namespace:\\root\CIMV2\TerminalServices PATH Win32_TSGeneralSetting Set SSLCertificateSHA1Hash=$t 
    } 
}
