import ballerina/http;
import ballerinax/kafka;

// HTTP client to fetch data from external API
http:Client externalApiClient = check new ("https://api.mockfly.dev");

// HTTP client for quotable.io API
http:Client quotableApiClient = check new ("https://api.quotable.io");

// HTTP client for UN RSS feed
http:Client rssClient = check new ("https://news.un.org");

// Kafka producer for publishing news updates
kafka:Producer newsProducer = check new (
    bootstrapServers = "kafka:9092"
);