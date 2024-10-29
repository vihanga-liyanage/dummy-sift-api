import ballerina/http;
import ballerina/io;

service /ip_check/v205 on new http:Listener(8080) {

    // Hardcoded user ID for conditional check
    final string fraudUserId = "authorized_user_123";
    resource function get users/[string userId]/score() returns http:Response|json|error {
        // Load JSON from file
        string jsonFilePath = "./sample_sift_response.json";
        json|error sampleResponse = io:fileReadJson(jsonFilePath);

        if sampleResponse is json {

            // Replace "user_id" with the path parameter `userId`
            map<json> sampleResponseJSON = check sampleResponse.ensureType();

            sampleResponseJSON["user_id"] = userId;

            // // Check if the request's userId matches the hardcoded userId
            // if userId == fraudUserId {
            //     // Set `is_fraud` to true for the authorized user ID
            //     sampleResponseJSON["latest_labels"]["payment_abuse"]["is_fraud"] = true;
            // } else {
            //     // Set `is_fraud` to false for other user IDs
            //     sampleResponseJSON["latest_labels"]["payment_abuse"]["is_fraud"] = false;
            // }

            // Send response
            return sampleResponseJSON;
        } else {
            // Handle error if reading or processing JSON fails
            http:Response errorResponse = new;
            errorResponse.statusCode = http:STATUS_INTERNAL_SERVER_ERROR;
            errorResponse.setPayload("Error reading or processing the JSON file.");
            return errorResponse;
        }
    }
}
