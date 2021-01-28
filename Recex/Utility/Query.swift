//
//  Query.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/25/20.
//


import Foundation
import PromiseKit

/// Object Query: All Database CRUD Operations will utilize this model to request and recieve responses from https://recex.applications.pulkith.com . Database is hosted on the same site. Application uses https. Most Requests that do not access the public API requires a "authentication_string" that is created client-side and validated server-side to deter some possible attacks. Passwords are hashed  with sha256 and salted with unique salts. Files hosted can be retrieved through app with the use of fetching scripts, but cannot be seen from direct links in a browser
struct Query {
    
    /// "Meat" of the Query Struct. Takes the URL and a request in JSON Format, and a recieves a response in JSON Format
    /// - Parameters:
    ///   - urlString: URL from the Dictionary Struct that  is used to perform CRUD Operations from the Database or APIs. Dictionary is exhuastive for every request in the application. Throws A RuntimeError with a user-message if URL is invalid or missing. Utilizes URLSession.shared.datatask to make async request and responses to the server.
    ///   - jsonData: Request Data Formated Into a specifically created or generic Struct In Utility/HTTP/Requests, which is then encoded into JSON and a POST request for the server to interpret
    ///   - responseFormat: Struct similar to the JSONData in Utility/HTTP/Responses which the JSON response from the server is decoded into and later utilized. Specific Format is part of an enumeration in Resources/Enums and a exhuastive switch will pair the format with the correct struct.
    /// - Returns: Promise from the 3rd Party CocoaPod "PromiseKit", of type HTTPResponse which is a protocol all responseFormats conform to. Promises is this application's solution to utilziing data from async requests.
    func Request<T: Request>(urlString: String,jsonData : Data, jsonModel : T.Type, responseFormat : responseFormats) -> Promise<HTTPResponse> {
        
        return Promise { seal in
            //Set & Create URL
            let url = URL(string: urlString)
            //Throw Runtime Error If The URL is broken or invalid
            guard let requestUrl = url else {throw RuntimeError("Failed To Authenticate") }
            //Format the URL as a URL REquest
            var request = URLRequest(url: requestUrl)
            
            //Set Request Type
            request.httpMethod = "POST"
            
            let boundary = generateBoundaryString()
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            //Set the Request JSON Data
            request.httpBody = createBodyWithParameters(parameters: jsonData, type: jsonModel, boundary: boundary) as Data
            
            //Create the Request -> Closure with outcome
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                // Error During Request
                if error != nil {
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
                        } else if (responseFormat == .withInfo) {
                            guard let request = ResponseInfo(data: data) else {
                                throw RuntimeError("The Server Failed To Respond")
                            }
                            seal.fulfill(request)
                        } else if (responseFormat == .user) {
                            guard let request = UserRequest(data: data) else {
                                throw RuntimeError("The Server Failed To Respond")
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
    
    func RequestWithImage<T: Request>(urlString: String,jsonData : Data, jsonModel : T.Type, responseFormat : responseFormats, imageData: [UIImage: String]) -> Promise<HTTPResponse> {
        return Promise { seal in
            //Set & Create URL
            let url = URL(string: urlString)
            //Throw Runtime Error If The URL is broken or invalid
            guard let requestUrl = url else {throw RuntimeError("Failed To Authenticate") }
            //Format the URL as a URL REquest
            var request = URLRequest(url: requestUrl)
            
            //Set Request Type
            request.httpMethod = "POST";
            
            let boundary = generateBoundaryString()
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            var imgData : [NSData: String] = [:]
            
            for (img, name) in imageData {
                // reduce image size(keeping same ratio & resolution), reduces a ~10 image upload from >20 seconds to 1-2 seconds
                let imageData = img.jpegData(compressionQuality: 0.1)
                if imageData == nil  {
                    throw RuntimeError("Failed To Upload Images")
                }
                imgData[imageData! as NSData] = name
            }
            
            request.httpBody = createBodyWithParametersImages(parameters: jsonData, type: jsonModel, filePathKey: "file", imgData: imgData, boundary: boundary) as Data
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
                        } else if (responseFormat == .withInfo) {
                            guard let request = ResponseInfo(data: data) else {
                                throw RuntimeError("The Server Failed To Respond")
                            }
                            seal.fulfill(request)
                        } else if (responseFormat == .user) {
                            guard let request = UserRequest(data: data) else {
                                throw RuntimeError("The Server Failed To Respond")
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
    func ResponseInfo(data: Data) -> ResponseWithInfoHTTPResponse? {
        guard let response = try? JSONDecoder().decode(ResponseWithInfoHTTPResponse.self, from: data) else {
            return nil
        }
        return response
    }
    func UserRequest(data: Data) -> UserDataResponse? {
        guard let response = try? JSONDecoder().decode(UserDataResponse.self, from: data) else {
            return nil
        }
        return response
    }
    
    func createBodyWithParametersImages<T: Request>(parameters: Data, type: T.Type, filePathKey: String?, imgData: [NSData: String], boundary: String, useCustomKeys : Bool? = false) -> NSData {
        let body = NSMutableData();
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let obj = try? JSONDecoder().decode(T.self, from: parameters)
        guard let params =  try? obj?.allProperties() else { return body }
        for(key, value) in params {
             var keyAsData = Data()
                if value is String { keyAsData = try! encoder.encode(value as! String) }
                else if value is [Any] { keyAsData = try! encoder.encode((value as! [String]))}
                else if value is [String: String] { keyAsData = try! encoder.encode(value as! [String: String])}
                else if value is [String: [String: String]] {keyAsData = try! encoder.encode(value as! [String: [String: String]])}
            var jsonParamater = (String(data: keyAsData, encoding: .utf8) ?? "")
            if value is String {
                jsonParamater = jsonParamater.replacingOccurrences(of: "\"", with: "")
            }
            
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: multipart/form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(jsonParamater)\r\n")
        }
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: multipart/form-data; name=\"image_count\"\r\n\r\n")
        body.appendString(string: "\(imgData.count)\r\n")
        //increement filePathKey to allow for multiple files
        var fileCount = 0
        for (img, name) in imgData {
            let filename = "\(name).jpg"
            let mimetype = "image/jpg"
            
            body.appendString(string: "--\(boundary)\r\n")
            if(useCustomKeys != nil && (useCustomKeys!)) {
                body.appendString(string: "Content-Disposition: multipart/form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n")
            } else {
                body.appendString(string: "Content-Disposition: multipart/form-data; name=\"\(filePathKey!)-\(fileCount)\"; filename=\"\(filename)\"\r\n")
            }
            body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
            body.append(img as Data)
            body.appendString(string: "\r\n")
            body.appendString(string: "--\(boundary)--\r\n")
            fileCount += 1
        }
        if(imgData.count == 0) {
            body.appendString(string: "--\(boundary)--\r\n")
        }
        return body
    }
    
    func createBodyWithParameters<T: Request>(parameters: Data, type: T.Type, boundary: String) -> NSData {
        let body = NSMutableData();
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let obj = try? JSONDecoder().decode(T.self, from: parameters)
        guard let params =  try? obj?.allProperties() else { return body }
        for(key, value) in params {
             var keyAsData = Data()
                if value is String { keyAsData = try! encoder.encode(value as! String) }
                else if value is [Any] { keyAsData = try! encoder.encode((value as! [String]))}
                else if value is [String: String] { keyAsData = try! encoder.encode(value as! [String: String])}
                else if value is [String: [String: String]] {keyAsData = try! encoder.encode(value as! [String: [String: String]])}
            var jsonParamater = (String(data: keyAsData, encoding: .utf8) ?? "")
            if value is String {
                jsonParamater = jsonParamater.replacingOccurrences(of: "\"", with: "")
            }
            
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: multipart/form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(jsonParamater)\r\n")
        }
        body.appendString(string: "--\(boundary)--\r\n")
        
      return body
    }
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
}




extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
extension Dictionary {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: [.prettyPrinted]) else {
            return nil
        }

        return String(data: theJSONData, encoding: .ascii)
    }
}

protocol Loopable {
    func allProperties() throws -> [String: Any]
}

extension Loopable {
    func allProperties() throws -> [String: Any] {

        var result: [String: Any] = [:]

        let mirror = Mirror(reflecting: self)

        // Optional check to make sure we're iterating over a struct or class
        guard let style = mirror.displayStyle, style == .struct || style == .class else {
            throw NSError()
        }

        for (property, value) in mirror.children {
            guard let property = property else {
                continue
            }

            result[property] = value
        }

        return result
    }
}
