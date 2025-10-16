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
// configurable string customerId = "66052";

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
    groups: ["post_test"]
}
isolated function testPostCardIssue() returns error? {
    string cardIssueId = "VISA.2347123812345679";
    
    // Create the card issue request body
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
        currencyId: "USD",
        issueDate: "2019-08-24",
        expiryDate: "2019-10-24",
        pinIssueDate: "2019-08-24",
        cancellationDate: "2019-08-24",
        customerId: "100210",
        cardDisplayNumber: "2347XXXXXXXX5679",
        charge: "100"
    };

    // Convert payload to JSON and create request
    json jsonPayload = payload.toJson();
    http:Request request = new;
    request.setJsonPayload(jsonPayload);

    CardIssueResponse|error response = temenos->/[cardIssueId].post(request);
    
    if response is CardIssueResponse {
        io:println("Success Response: ", response);
    } else {
        io:println("Error Response: ", response.message());
    }
}


@test:Config {
    groups: ["put_test"]
}
isolated function testPutCardIssue() returns error? {
    string cardIssueId = "VISA.2347123812345679";
    
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
        cancellationReason: "test"
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


