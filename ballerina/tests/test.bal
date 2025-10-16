// Copyright (c) 2025, WSO2.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/test;
import ballerina/io;
import ballerina/http;

configurable ApiKeysConfig apiKeyConfig = ?;
configurable string serviceUrl = "https://api.temenos.com/api/v2.0.0//holdings/cards";
configurable string cardIssueId = "VISA.234789412589633";


ConnectionConfig config = {
    auth: apiKeyConfig
};

final Client temenos = check new Client(config, serviceUrl);

@test:Config {
    groups: ["get_test"]
}
isolated function testGetHoldings() returns error? {
    CardIssuesResponse|error response = temenos->/.get();
    if response is CardIssuesResponse {
        io:println("Success Response: ", response);
    } else {
        io:println("Error Response: ", response.message());
    }
}


@test:Config {
    groups: ["post_test, create_delete_issue"]
}
isolated function testPostCardIssue() returns error? {
    
    // Create the card issue request body
    CardIssueResponseBody payload = {
        accountIds: [
            {
                accountId: "140333"
            }
        ],
        cardNames: [
            {
                cardName: "ROLF GERLING"
            }
        ],
        cardStatus: "90", //problem
        currencyId: "USD",
        issueDate: "2019-08-24",
        expiryDate: "2019-10-24",
        pinIssueDate: "2019-08-24",
        cancellationDate: "2019-08-24",
        cancellationReason: "1",
        customerId: "100336",
        cardDisplayNumber: "2347XXXXXXXX6346",
        charge: "100"
    };
    // Convert payload to JSON and create request
    json jsonPayload = payload.toJson();
    http:Request request = new;
    request.setJsonPayload(jsonPayload);

    CardIssueResponse|error response = temenos->/[cardIssueId].post(request);
    
    if response is CardIssueResponse {
        io:println("Success Post Response: ", response);
        test:assertTrue(response.header?.status == "success", "Card issue request failed");
    } else {
        io:println("Error Post Response: ", response.message());
        test:assertFail("Failed to create card issue: " + response.message());
    }
}


@test:Config {
    groups: ["put_test"]
}
isolated function testPutCardIssue() returns error? {
    
    // Update the card issue request body
    CardIssueResponseBody payload = {
        accountIds: [
            {
                accountId: "138387"
            }
        ],
        cardNames: [
            {
                cardName: "Mr & Mrs David Miller"
            }
        ],
        cardStatus: "90",
        issueDate: "2019-08-24",
        pinIssueDate: "2019-08-24",
        cancellationDate: "2019-08-24",
        cancellationReason: "test" //problem
    };

    // Convert payload to JSON and update request
    json jsonPayload = payload.toJson();
    http:Request request = new;
    request.setJsonPayload(jsonPayload);

    CardIssueResponse|error response = temenos->/[cardIssueId].put(request);
    
    if response is CardIssueResponse {
        io:println("Success Response: ", response);
    } else {
        io:println("Error Response: ", response.message());
    }
}


@test:Config {
    dependsOn: [testPostCardIssue],
    groups: ["delete_test", "create_delete_issue"]
}
isolated function testDeleteCardIssue() returns error? {
    
    // Create an empty request since no payload is needed
    http:Request request = new;

    CardIssueResponse|error response = temenos->/[cardIssueId].delete(request);
    if response is CardIssueResponse {
        io:println("Success Delete Response: ", response);
        test:assertTrue(true, "Successfully deleted card issue");
    } else {
        io:println("Error Delete Response: ", response.message());
        test:assertFail("Failed to delete card issue: " + response.message());
    }
}