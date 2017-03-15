Configuration VmDsc {

    Node "localhost" {
        
        WindowsFeature WebRole {
            Name = "Web-Server"
            Ensure = "Present"
        }

    }

}