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

configurable ApiKeysConfig apiKeyConfig = ?;
configurable string serviceUrl = "https://api.temenos.com/api/v4.0.0/";
configurable string customerId = "66052";

ConnectionConfig config = {
    auth: apiKeyConfig
};

final Client temenos = check new Client(config, serviceUrl);

@test:Config {}
isolated function testGetHoldings() returns error? {
    CustomerHoldingsResponse|error response = temenos->/holdings.get();
    if response is CustomerHoldingsResponse {
        io:println("Success Response: ", response);
        test:assertTrue(true, "Successfully retrieved holdings");
    } else {
        io:println("Error Response: ", response.message());
        test:assertFail("Failed to retrieve holdings: " + response.message());
    }
}

@test:Config {}
isolated function testGetCustomerHoldings() returns error? {
    CustomerHoldingsResponse|error response = temenos->/holdings/customers/[customerId]/holdings.get();
    if response is CustomerHoldingsResponse {
        io:println("Success Response: ", response);
        test:assertTrue(true, "Successfully retrieved customer holdings");
    } else {
        io:println("Error Response: ", response.message());
        test:assertFail("Failed to retrieve customer holdings: " + response.message());
    }
}