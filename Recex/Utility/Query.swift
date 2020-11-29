//
//  Query.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/25/20.
//

import Foundation
import PromiseKit

struct Query {
    
    func Request(urlString: String,jsonData : Data, responseFormat : responseFormats) -> Promise<HTTPResponse> {

        return Promise { seal in
            //Set & Create URL
            let url = URL(string: urlString)
            guard let requestUrl = url else {throw RuntimeError("Failed To Authenticate") }
            var request = URLRequest(url: requestUrl)
            
            //Set Request Type
            request.httpMethod = "POST"
            
            // Set HTTP Request Header
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            //Create the Request
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                // Error During Request
                if error != nil {
                    seal.reject(error!)
                } else {
                    // Recieved data from request
                    guard let data = data else {seal.reject(RuntimeError("The Server Failed To Respond")); return}
                    do {
                        if(responseFormat == .basic){
                            guard let request = basicRequest(data: data) else { throw RuntimeError("The Server Failed To Respond")}
                            seal.fulfill(request)
                        } else if( responseFormat == .emailHash){
                            guard let request = EmailHashRequest(data: data) else { throw RuntimeError("The Server Failed To Respond")}
                            seal.fulfill(request)
                            
                        } else if( responseFormat == .passwordValidation) {
                            guard let request = basicRequest(data: data) else { throw RuntimeError("The Server Failed to Respond") }
                            seal.fulfill(request)
                        }
                    } catch let error as RuntimeError {
                        seal.reject(error)
                    } catch {
                        seal.reject(RuntimeError("Unknown Error"))
                    }
                }
            }
            //Send the Request
            task.resume()
        }
    }
    
    func basicRequest(data: Data) -> BasicHTTPResponse? {
        guard let response = try? JSONDecoder().decode(BasicHTTPResponse.self, from: data) else { return nil }
        return response
    }
    
    func EmailHashRequest(data: Data) -> EmailHashHTTPResponse? {
        guard let response = try? JSONDecoder().decode(EmailHashHTTPResponse.self, from: data) else { return nil }
        return response
    }

}
