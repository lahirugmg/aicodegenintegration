import ballerina/http;

service /contacts on new http:Listener(8080) {
    
    resource function post .() returns xml|error {
        
        // Fetch contacts data from external API
        json contactsResponse = check externalApiClient->get("/mocks/5a4878c5-b727-4d26-ad25-df5f485f324c/contacts");
        
        // Convert JSON to Contact array
        Contact[] contacts = check contactsResponse.cloneWithType();
        
        // Build XML string
        string xmlString = "<Contacts>";
        
        foreach Contact contact in contacts {
            xmlString = xmlString + "<Contact>";
            xmlString = xmlString + "<FirstName>" + contact.FirstName + "</FirstName>";
            xmlString = xmlString + "<LastName>" + contact.LastName + "</LastName>";
            xmlString = xmlString + "<Email>" + contact.Email + "</Email>";
            xmlString = xmlString + "<Phone>" + contact.Phone + "</Phone>";
            xmlString = xmlString + "<Department>" + contact.Department + "</Department>";
            xmlString = xmlString + "<Title>" + contact.Title + "</Title>";
            xmlString = xmlString + "<MailingCity>" + contact.MailingCity + "</MailingCity>";
            xmlString = xmlString + "<MailingCountry>" + contact.MailingCountry + "</MailingCountry>";
            xmlString = xmlString + "</Contact>";
        }
        
        xmlString = xmlString + "</Contacts>";
        
        // Convert string to XML
        xml contactsXml = check xml:fromString(xmlString);
        
        return contactsXml;
    }
}