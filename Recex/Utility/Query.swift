//
//  Query.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/25/20.
//


import Foundation
import PromiseKit

/// Object Query: All Database CRUD Operations will utilize this model to request and recieve responses from http://recex.applications.pulkith.com. Database is hosted on the same site. Application does not yet use https due to the lack of a SSL Certificate, but it is planed to get one soon, after which all links will updated to use https:. Most Requests that do not access the public API requires a "authentication_string" that is created client-side and validated server-side to deter some possible attacks. Passwords are hashed  with sha256 and salted with unique salts.
struct Query {
    
    /// "Meat" of the Query Struct. Takes the URL and a request in JSON Format, and a recieves a response in JSON Format
    /// - Parameters:
    ///   - urlString: URL from the Dictionary Struct that  is used to perform CRUD Operations from the Database or APIs. Dictionary is exhuastive for every request in the application. Throws A RuntimeError with a user-message if URL is invalid or missing. Utilizes URLSession.shared.datatask to make async request and responses to the server.
    ///   - jsonData: Request Data Formated Into a specifically created or generic Struct In Utility/HTTP/Requests, which is then encoded into JSON and a POST request for the server to interpret
    ///   - responseFormat: Struct similar to the JSONData in Utility/HTTP/Responses which the JSON response from the server is decoded into and later utilized. Specific Format is part of an enumeration in Resources/Enums and a exhuastive switch will pair the format with the correct struct.
    /// - Returns: Promise from the 3rd Party CocoaPod "PromiseKit", of type HTTPResponse which is a protocol all responseFormats conform to. Promises is this application's solution to utilziing data from async requests.
    func Request(urlString: String,jsonData : Data, responseFormat : responseFormats) -> Promise<HTTPResponse> {

        return Promise { seal in
            //Set & Create URL
            let url = URL(string: urlString)
            //Throw Runtime Error If The URL is broken or invalid
            guard let requestUrl = url else {throw RuntimeError("Failed To Authenticate") }
            //Format the URL as a URL REquest
            var request = URLRequest(url: requestUrl)
            
            //Set Request Type
            request.httpMethod = "POST"
            
            // Set HTTP Request Header
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            //Set the Request JSON Data
            request.httpBody = jsonData
            
            //Create the Request -> Closure with outcome
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                // Error During Request
                if error != nil {
                    //reject the Promse with the error
                    seal.reject(error!)
                } else {
                    // Recieved data from request ( else reject the Promise with a RuntimeError Which is Parsed into text on the UI. Probable causes of this are incorrect links, or broken server-side code(mostly php)
                    guard let data = data else {seal.reject(RuntimeError("The Server Failed To Respond")); return}
                    do {
                        //Most common response type, which is just a single response with the outcome of a request. Throws Runtime error if expected format is not the same as the recieved response. Returns the Promise with the Data / Response receieved
                        if(responseFormat == .basic){
                            guard let request = basicRequest(data: data) else { throw RuntimeError("The Server Failed To Respond")}
                            seal.fulfill(request)
                            
                            //Ressponse type which sends a request with the email and expects a response that tells if the account exists and the salt to validate the password if so.
                        } else if( responseFormat == .emailHash){
                            guard let request = EmailHashRequest(data: data) else { throw RuntimeError("The Server Failed To Respond")}
                            seal.fulfill(request)
                            
                            //Response same as basic format. Should Merge and Delete.
                        } else if( responseFormat == .passwordValidation) {
                            guard let request = basicRequest(data: data) else { throw RuntimeError("The Server Failed to Respond") }
                            seal.fulfill(request)
                        } else if (responseFormat == .ingredients){
                            guard let request = IngredientsRequest(data: data) else { throw
                                RuntimeError("Failed To Fetch Ingredients")
                            }
                            seal.fulfill(request)
                        }
                    } catch let error as RuntimeError {
                        //Error Found That We Threw. Reject the Promise with the given error
                        seal.reject(error)
                    } catch {
                        // error Found that we did not throw. Reject the Promise with a runtime error
                        seal.reject(RuntimeError("Unknown Error"))
                    }
                }
            }
            //Send the Request
            task.resume()
        }
    }
    
    
    /// Decode given JSON data into an object to utilize. Only One response
    /// - Parameter data: The JSON Data Recieved
    /// - Returns: nil if failed to decode, or the object is successfuly decoded
    func basicRequest(data: Data) -> BasicHTTPResponse? {
        guard let response = try? JSONDecoder().decode(BasicHTTPResponse.self, from: data) else { return nil }
        return response
    }
    
    /// Decode given JSON Data into an object to utiliaze. Two responses: 1) Wether the Email was valid, 2) Optional: given if part 1 is valid, which is the salt for the account
    /// - Parameter data: Data: The JSON Data to Decode
    /// - Returns: nil if failed to decode, or the object if successfulty decoded
    func EmailHashRequest(data: Data) -> EmailHashHTTPResponse? {
        guard let response = try? JSONDecoder().decode(EmailHashHTTPResponse.self, from: data) else { return nil }
        return response
    }

    func IngredientsRequest(data: Data) -> IngredientsHTTPResponse? {
        guard let response = try? JSONDecoder().decode(IngredientsHTTPResponse.self, from: data) else {
            return nil
        }
        return response
    }
}
