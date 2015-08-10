//
//  File.swift
//  tableView
//
//  Created by Udit Verma on 8/10/15.
//  Copyright (c) 2015 alchemist. All rights reserved.
//

import Foundation


class API {
    
   // var delegate : APIControllerProtocol?
    
    func searchString(search: String){
        
        let searchStr = search.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        if let escapedString = searchStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding){
            let urlPath = "http://itunes.apple.com/search?term=\(escapedString)&media=software"
            let url = NSURL(string: urlPath)
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
                println("Task complete")
                if (error != nil){
                    println("Error!!")
                }
                
                var error : NSError?
                if let jsonResults = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSDictionary {
                    
                    if(error != nil){
                        println("Json failed to read")
                    }
                    
                    if let jsonData : NSArray = jsonResults["results"] as? NSArray{
                       
                    }
                }
            })
            // The task is just an object with all these properties set
            // In order to actually make the web request, we need to "resume"
            task.resume()
        }
    }
}