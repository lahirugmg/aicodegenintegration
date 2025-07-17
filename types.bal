// JSON structure after XML conversion
public type ContactsJson record {
    string generatedDate?;
    ContactJsonInput|ContactJsonInput[] Contact;
};

public type ContactJsonInput record {
    string id?;
    string FirstName;
    string LastName;
    string Email;
    PhoneJson|string Phone;
    string Department;
    string Title;
    AddressJson Address;
    string PreferredContactMethod?;
    string IsActive?;
    string CreatedDate?;
};

public type PhoneJson record {
    string \#content;
    string 'type?;
};

public type AddressJson record {
    string 'type?;
    string Street;
    string City;
    string State;
    string PostalCode;
    string Country;
};

// Output JSON structure types
public type ContactOutput record {
    string FirstName;
    string LastName;
    string Email;
    string Phone;
    string Department;
    string Title;
    string MailingCity;
    string MailingCountry;
};