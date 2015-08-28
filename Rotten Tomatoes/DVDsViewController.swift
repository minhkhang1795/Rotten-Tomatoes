//
//  DVDsViewController.swift
//  Rotten Tomatoes
//
//  Created by Clover on 8/26/15.
//  Copyright (c) 2015 Clover. All rights reserved.
//

import UIKit

class DVDsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    var DVDs: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json")!
        let request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
            if let json = json {
                self.DVDs = json["movies"] as? [NSDictionary]
                self.tableView.reloadData()
            }
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Refreshing
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
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
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
    }
    
    // MARK: - Table Control
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let DVDs = DVDs {
            return DVDs.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("DVDCell", forIndexPath: indexPath) as! DVDCell
        
        let DVD = DVDs![indexPath.row]
        cell.titleLabel.text = DVD["title"] as? String
        cell.synopsisLabel.text = DVD["synopsis"] as? String
    
        let url = NSURL(string: DVD.valueForKeyPath("posters.thumbnail") as! String)!
        cell.posterView.setImageWithURL(url)
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
        
        let DVD = DVDs![indexPath.row]
        
        let dvdDetailsViewController = segue.destinationViewController as! DVDDetailsViewController
        dvdDetailsViewController.DVD = DVD
        
    }
    
}
