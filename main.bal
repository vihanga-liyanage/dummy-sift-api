import ballerina/http;
import ballerina/io;

type SiftJSON record {
    Latest_labels latest_labels;
};

type Latest_labels record {
    Payment_abuse payment_abuse;
};

type Payment_abuse record {
    boolean is_fraud?;
};

configurable string fraudUserId = ?;

service /ip_check/v205 on new http:Listener(8080) {
    
    resource function get users/[string userId]/score() returns http:Response|SiftJSON|error {

        // Load JSON from file
        string jsonFilePath = "./sample_sift_response.json";
        map<json> sampleResponseJSON = check io:fileReadJson(jsonFilePath).ensureType();

        SiftJSON readJson = check sampleResponseJSON.cloneWithType(SiftJSON);
        
        // Replace "user_id" with the path parameter `userId`
        readJson["user_id"] = userId;

        // Check if the request's userId matches the hardcoded userId
        if userId == fraudUserId {
            // Set `is_fraud` to true for the authorized user ID
            readJson.latest_labels.payment_abuse.is_fraud = true;
        } else {
            // Set `is_fraud` to false for other user IDs
            readJson.latest_labels.payment_abuse.is_fraud = false;
        }

        // Send response
        return readJson;
    }
}
