import ballerina/log;
import ballerinax/kafka;

// Function to process raw orders and publish processed orders
function processOrderBatch(kafka:AnydataConsumerRecord[] records, kafka:Caller caller) returns error? {
    int batchSize = records.length();
    log:printInfo(string `Processing batch of ${batchSize} orders`);
    
    foreach kafka:AnydataConsumerRecord consumerRecord in records {
        // Extract order data from record value
        anydata recordValue = consumerRecord.value;
        
        // Convert byte array to string
        byte[] orderBytes = check recordValue.ensureType();
        string orderString = check string:fromBytes(orderBytes);
        
        // Parse string as JSON
        json orderJson = check orderString.fromJsonString();
        
        // Convert to RawOrder record
        RawOrder rawOrder = check orderJson.cloneWithType();
        
        // Create processed order with only orderId and totalAmount
        ProcessedOrder processedOrder = {
            orderId: rawOrder.orderId,
            totalAmount: rawOrder.totalAmount
        };
        
        // Publish processed order to processed-orders topic
        kafka:AnydataProducerRecord producerRecord = {
            topic: "processed-orders",
            value: processedOrder
        };
        
        kafka:Error? publishResult = processedOrdersProducer->send(producerRecord);
        if publishResult is kafka:Error {
            log:printError("Failed to publish processed order", publishResult);
            return publishResult;
        }
    }
    
    // Commit offsets only after successful publish of all records
    kafka:Error? commitResult = caller->commit();
    if commitResult is kafka:Error {
        log:printError("Failed to commit offsets", commitResult);
        return commitResult;
    }
    
    log:printInfo(string `Successfully processed and published batch of ${batchSize} orders`);
}