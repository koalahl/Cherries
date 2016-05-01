//
//  Network.swift
//  Cherries
//
//  Created by HanLiu on 16/5/1.
//  Copyright © 2016年 HanLiu. All rights reserved.
//

import UIKit

class NetworkManager {
    
    var url:String
    var method:HTTPMethod
    var parameters:Dictionary<String,AnyObject>?
    var completionHandler:(data:AnyObject?,response:NSURLResponse?,error:NSError?)->Void
    var request : NSMutableURLRequest!
    var task: NSURLSessionTask!
    var session:NSURLSession!
    let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()

    var files : Array<File>?
    var boundary = "--Cherries--"
    var mimeType:String?
    
    init(url:String,method:HTTPMethod,parameters:Dictionary<String,AnyObject>?,files : Array<File>? = Array<File>(),mimeType:String?,completionHandler:(data:AnyObject?,response:NSURLResponse?,error:NSError?)->Void) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.completionHandler = completionHandler
        self.files = files
        self.mimeType = mimeType

    }

    func buildRequest() {
        guard var URL = NSURL(string: url) else {return}
        
        // if http method is GET and also have URLParams , need to append parameters dic after url.
        if self.method == .GET && self.parameters?.count > 0 {
            URL = URL.URLByAppendingQueryParameters(parameters!)
        }
        request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = method.rawValue
        
        if self.files != nil && self.files?.count > 0 {
            request.addValue((self.mimeType)!, forHTTPHeaderField: "Content-Type")
        }
    }
    
    func buildHTTPBody() {
        let data = NSMutableData()
        if self.files != nil && self.files?.count > 0 {
            guard self.method != .GET else { return }
            
            for (key,value) in self.parameters! {
                data.appendData("--\(self.boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                data.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                data.appendData("\(value.description)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            }
            
            for file in (self.files)! {
                data.appendData("--\(self.boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                data.appendData("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.path.lastPathComponent)\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                if let a = NSData(contentsOfURL: file.path) {
                    data.appendData(a)
                    data.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
                }
            }
            data.appendData("--\(self.boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        if self.method != .GET && self.parameters?.count > 0 {
            let bodyParameters = parameters
            let bodyString = bodyParameters!.queryParameters
            print("bodyString= \(bodyString)")
            data.appendData(bodyString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
        }
        
        request.HTTPBody = data

    }
    
    func buildSession() {
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! NSHTTPURLResponse).statusCode
                let json = try!NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves)
                print("URL Session Task Succeeded: HTTP \(statusCode) ")
                self.completionHandler(data: json, response: response, error: error)
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
                self.completionHandler(data: nil, response: response, error: error)

            }
        })
        task.resume()
    }
    func sendRequest() {
        /* Configure session, choose between:
         * defaultSessionConfiguration
         * ephemeralSessionConfiguration
         * backgroundSessionConfigurationWithIdentifier:
         And set session-wide properties, such as: HTTPAdditionalHeaders,
         HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
         */
        
        /* Create session, and optionally set a NSURLSessionDelegate. */
        session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        buildRequest()
        // Body
        buildHTTPBody()
        /* Start a new Task */
        buildSession()
    }
}


protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
     */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = NSString(format: "%@=%@",
                                String(key).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!,
                            String(value).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
            parts.append(part as String)
        }
        return parts.joinWithSeparator("&")
    }
    
}

extension NSURL {
    /**
     Creates a new URL by adding the given query parameters.
     @param parametersDictionary The query parameter dictionary to add.
     @return A new NSURL.
     */
    func URLByAppendingQueryParameters(parametersDictionary : Dictionary<String, AnyObject>) -> NSURL {
        let URLString : NSString
        if self.absoluteString .containsString("?"){
            URLString = NSString(format: "%@&%@", self.absoluteString, parametersDictionary.queryParameters)

        }else{
            URLString = NSString(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)

        }
        return NSURL(string: URLString as String)!
    }
}

