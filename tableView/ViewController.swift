//
//  ViewController.swift
//  tableView
//
//  Created by Udit Verma on 8/9/15.
//  Copyright (c) 2015 alchemist. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var appsTableView : UITableView! 
    var tableData = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchString("JQ Software")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return tableData.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell : UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        if let rowData: NSDictionary = self.tableData[indexPath.row] as? NSDictionary,
            // Grab the artworkUrl60 key to get an image URL for the app's thumbnail
            urlString = rowData["artworkUrl60"] as? String,
            // Create an NSURL instance from the String URL we get from the API
            imgURL = NSURL(string: urlString),
            // Get the formatted price string for display in the subtitle
            formattedPrice = rowData["formattedPrice"] as? String,
            // Download an NSData representation of the image at the URL
            imgData = NSData(contentsOfURL: imgURL),
            // Get the track name
            trackName = rowData["trackName"] as? String {
                // Get the formatted price string for display in the subtitle
                cell.detailTextLabel?.text = formattedPrice
                // Update the imageView cell to use the downloaded image data
                cell.imageView?.image = UIImage(data: imgData)
                // Update the textLabel text to use the trackName from the API
                cell.textLabel?.text = trackName
        }
        return cell
    }
    
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
                        dispatch_async(dispatch_get_main_queue(), {
                            self.tableData = jsonData
                            self.appsTableView!.reloadData()
                        })
                    }
                }
            })
            // The task is just an object with all these properties set
            // In order to actually make the web request, we need to "resume"
            task.resume()
        }
    }
}