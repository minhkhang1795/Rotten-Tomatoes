//
//  DVDsViewController.swift
//  Rotten Tomatoes
//
//  Created by Clover on 8/26/15.
//  Copyright (c) 2015 Clover. All rights reserved.
//

import UIKit

class DVDsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var DVDs: [NSDictionary]?
    var refreshControl: UIRefreshControl!
    var searchActive : Bool = false
    var filtered: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Reachability.isConnectedToNetwork() == true {
            
            let url = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json")!
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
                if let json = json {
                    self.DVDs = json["movies"] as? [NSDictionary]
                    self.tableView.reloadData()
                }
            }
            
        } else {

            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
        // Setup delegates
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        // Refreshing
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table Control
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let DVDs = DVDs {
            if (searchActive) {
                return filtered.count
            }
            return DVDs.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("DVDCell", forIndexPath: indexPath) as! DVDCell
        
        var DVD = searchActive ? filtered[indexPath.row] : DVDs![indexPath.row]
        
        cell.titleLabel.text = DVD["title"] as? String
        cell.synopsisLabel.text = DVD["synopsis"] as? String
        
        // Get image URL
        let url = NSURL(string: DVD.valueForKeyPath("posters.thumbnail") as! String)!
        cell.posterView.setImageWithURL(url)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Refresh Control
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        if Reachability.isConnectedToNetwork() == true {
            delay(2, closure: {
                
                let url = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json")!
                let request = NSURLRequest(URL: url)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                    let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
                    if let json = json {
                        self.DVDs = json["movies"] as? [NSDictionary]
                        self.tableView.reloadData()
                    }
                }
            })
        } else {
            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            
            alert.show()
        }
        self.refreshControl.endRefreshing()
    }
    
    // MARK: - Search Bar
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = DVDs!.filter({ (DVD) -> Bool in
            let tmpTitle = DVD["title"] as? String
            let range = tmpTitle!.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range != nil
        })
        
        if (searchText == "" && filtered.count == 0) {
            searchActive = false
        } else {
            searchActive = true
        }
        self.tableView.reloadData()
    }
    
    // End searching if scroll down
    func scrollViewDidScroll(scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
        
        let DVD = searchActive ? filtered[indexPath.row] : DVDs![indexPath.row]
        
        let dvdDetailsViewController = segue.destinationViewController as! DVDDetailsViewController
        dvdDetailsViewController.DVD = DVD
        view.endEditing(true)
    }
}
