import ballerina/http;
import ballerina/io;



public function main() returns error? {

    http:Client temenosClient = check new ("https://api.temenos.com/api/v2.0.0//holdings/cards");

    json|error response = check temenosClient->/({
        "apikey": "53IAsVdevbUnLxnZTQUcxFdP0Ftb9XB9" 
    });

    if response is json {
        io:println("Success Response: ", response.toJsonString());
    } else {
        io:println("Error Response: ", response.message());
    }
}

