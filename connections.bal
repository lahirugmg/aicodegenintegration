import ballerina/http;
import ballerinax/kafka;

// HTTP client to fetch data from external API
http:Client externalApiClient = check new ("https://api.mockfly.dev");

// HTTP client for quotable.io API
http:Client quotableApiClient = check new ("https://api.quotable.io");

// Kafka producer for publishing processed orders
kafka:Producer processedOrdersProducer = check new (
    bootstrapServers = "localhost:9092"
);