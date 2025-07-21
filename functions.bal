import ballerina/log;
import ballerinax/kafka;

// Function to fetch RSS feed with retry logic
function fetchRssFeedWithRetry() returns xml|error {
    xml|error result = rssClient->get("/feed/subscribe/en/news/all/rss.xml");

    if result is error {
        log:printInfo("First attempt failed, retrying RSS feed fetch");
        // Retry once
        result = rssClient->get("/feed/subscribe/en/news/all/rss.xml");

        if result is error {
            log:printError("Failed to fetch RSS feed after retry", result);
            return result;
        }
    }

    return result;
}

// Function to process RSS feed and publish to Kafka
function processRssFeed() {
    do {
        // Fetch RSS feed with retry
        xml rssXml = check fetchRssFeedWithRetry();

        // Convert XML to JSON
        json rssJson = rssXml.toJson();

        // Convert to structured record
        RssFeed rssFeed = check rssJson.cloneWithType();

        // Extract items
        RssItem[] items = [];
        if rssFeed.rss.channel.item is RssItem[] {
            RssItem[] itemArray = <RssItem[]>rssFeed.rss.channel.item;
            items = itemArray;
        } else if rssFeed.rss.channel.item is RssItem {
            RssItem singleItem = <RssItem>rssFeed.rss.channel.item;
            items = [singleItem];
        }

        // Publish each item to Kafka
        int publishedCount = 0;
        foreach RssItem item in items {
            json itemJson = item.toJson();
            kafka:AnydataProducerRecord producerRecord = {
                topic: "news-updates",
                value: itemJson
            };

            kafka:Error? result = newsProducer->send(producerRecord);
            if result is kafka:Error {
                log:printError("Failed to publish item to Kafka", result);
            } else {
                publishedCount = publishedCount + 1;
            }
        }

        log:printInfo(string `Successfully published ${publishedCount} news items to Kafka topic 'news-updates'`);

    } on fail error e {
        log:printError("Error processing RSS feed", e);
    }
}