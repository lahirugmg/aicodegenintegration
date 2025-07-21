import ballerina/http;

// HTTP client to fetch data from external API
http:Client externalApiClient = check new ("https://api.mockfly.dev");