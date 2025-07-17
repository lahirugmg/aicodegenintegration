import ballerina/http;

service /contacts on new http:Listener(8080) {
    
    resource function post transform(xml xmlPayload) returns ContactOutput[]|error {
        
        // Convert XML to JSON
        json jsonData = xmlPayload.toJson();
        
        // Convert JSON to structured record
        ContactsJson contactsData = check jsonData.cloneWithType();
        
        // Handle both single contact and array of contacts
        ContactJsonInput[] contactArray = [];
        if contactsData.Contact is ContactJsonInput[] {
            ContactJsonInput[] contacts = <ContactJsonInput[]>contactsData.Contact;
            contactArray = contacts;
        } else {
            ContactJsonInput singleContact = <ContactJsonInput>contactsData.Contact;
            contactArray = [singleContact];
        }
        
        // Transform to output format
        ContactOutput[] outputContacts = [];
        
        foreach ContactJsonInput contact in contactArray {
            string phoneValue = "";
            if contact.Phone is PhoneJson {
                PhoneJson phoneObj = <PhoneJson>contact.Phone;
                phoneValue = phoneObj.\#content;
            } else {
                phoneValue = <string>contact.Phone;
            }
            
            ContactOutput outputContact = {
                FirstName: contact.FirstName,
                LastName: contact.LastName,
                Email: contact.Email,
                Phone: phoneValue,
                Department: contact.Department,
                Title: contact.Title,
                MailingCity: contact.Address.City,
                MailingCountry: contact.Address.Country
            };
            
            outputContacts.push(outputContact);
        }
        
        return outputContacts;
    }
}