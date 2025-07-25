import ballerina/http;
import ballerina/log;
import ballerinax/kafka;

// Kafka service to consume raw orders and publish processed orders
service on new kafka:Listener(
    bootstrapServers = "localhost:9092",
    groupId = "order-processor-group",
    topics = "raw-orders",
    autoCommit = false
) {
    
    remote function onConsumerRecord(kafka:AnydataConsumerRecord[] records, kafka:Caller caller) returns error? {
        check processOrderBatch(records, caller);
    }
    
    remote function onError(kafka:Error err) returns error? {
        log:printError("Error in Kafka consumer", err);
    }
}

service /quote on new http:Listener(9090) {

    resource function get quote() returns QuoteOutput|error {

        // Fetch random quote from quotable.io API
        json quoteResponse = check quotableApiClient->get("/random");

        // Convert JSON to QuoteResponse record
        QuoteResponse quoteData = check quoteResponse.cloneWithType();

        // Transform to required output format
        QuoteOutput result = {
            author: quoteData.author,
            quote: quoteData.content
        };

        return result;
    }
}

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