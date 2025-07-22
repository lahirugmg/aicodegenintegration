// Contact record type matching the JSON structure
public type Contact record {
    string FirstName;
    string LastName;
    string Email;
    string Phone;
    string Department;
    string Title;
    string MailingCity;
    string MailingCountry;
};

// Quote response from quotable.io API
public type QuoteResponse record {
    string author;
    string content;
    string _id?;
    string[] tags?;
    int length?;
    string dateAdded?;
    string dateModified?;
};

// Output format for quote endpoint
public type QuoteOutput record {
    string author;
    string quote;
};

// Raw order structure from raw-orders topic
public type RawOrder record {
    string orderId;
    decimal totalAmount;
    string customerId?;
    string orderDate?;
    string status?;
};

// Processed order structure for processed-orders topic
public type ProcessedOrder record {
    string orderId;
    decimal totalAmount;
};