//
//  Cherries.swift
//  Cherries
//
//  Created by HanLiu on 16/5/1.
//  Copyright © 2016年 HanLiu. All rights reserved.
//

import UIKit
enum HTTPMethod:String{
    case GET    = "Get"
    case POST   = "Post"
    case DELETE = "Delete"
    case PUT    = "Put"
}
class Cherries {
    
    /**
     Basic Http request method
     
     - parameter url:               url
     - parameter method:            method type
     - parameter params:            params
     - parameter completionHandler: completionHandler description
     */
    static func request(url:String,method:HTTPMethod,params:Dictionary<String,AnyObject>? ,completionHandler:(data:AnyObject?, response:NSURLResponse?, error:NSError?)->Void)  {
        NetworkManager(url: url, method: method, parameters: params, files: nil, mimeType: nil, completionHandler: completionHandler).sendRequest()
    }
    
    static func upload(url:String,method:HTTPMethod,params:Dictionary<String,AnyObject>? , files:Array<File> , mimeType:String,completionHandler:(data:AnyObject?, response:NSURLResponse?, error:NSError?)->Void)  {
        NetworkManager(url: url, method: method, parameters: params, files: files, mimeType: mimeType, completionHandler: completionHandler).sendRequest()
    }
    /**
     Get method with parameters
     
     - parameter url:               url
     - parameter params:            parametes
     - parameter completionHandler: completionHandler
     */
    static func Get(url:String,params:Dictionary<String,AnyObject>? , completionHandler:(data:AnyObject?, response:NSURLResponse?, error:NSError?)->Void){
        Cherries.request(url, method: .GET, params: params, completionHandler: completionHandler)
    }
    /**
     Get method without parameters
     */
    static func Get(url:String, completionHandler:(data:AnyObject?, response:NSURLResponse?, error:NSError?)->Void){
        Cherries.request(url, method: .GET, params: nil, completionHandler: completionHandler)
    }
    
    /**
     Post method
     
     - parameter url:               url
     - parameter params:            paramsters
     - parameter completionHandler: completionHandler description
     */
    static func Post(url:String,params:Dictionary<String,AnyObject>? , completionHandler:(data:AnyObject?, response:NSURLResponse?, error:NSError?)->Void){
        Cherries.request(url, method: .POST, params: params, completionHandler: completionHandler)
    }
    
    
}
