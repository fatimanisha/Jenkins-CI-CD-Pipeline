Configuration ConfigureVM {
    Node "localhost" {
        WindowsFeature WebServer {
            Ensure = "Present"
            Name   = "Web-Server"
        }
    }
}
ConfigureVM -OutputPath "C:\DSC\"
