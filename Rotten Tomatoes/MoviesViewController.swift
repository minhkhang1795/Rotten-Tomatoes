//
//  MoviesViewController.swift
//  Rotten Tomatoes
//
//  Created by Clover on 8/26/15.
//  Copyright (c) 2015 Clover. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var movies: [NSDictionary]?
    var refreshControl: UIRefreshControl!
    var searchActive : Bool = false
    var filtered: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = NSURL(string: "https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json")!
        let request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary
            if let json = json {
                self.movies = json["movies"] as? [NSDictionary]
                self.tableView.reloadData()
            }
        }
        /* Setup delegates*/
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        // Refreshing
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    // MARK: - Table Control
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            if (searchActive) {
                return filtered.count
            }
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        var movie = movies![indexPath.row]
        
        if (searchActive){
            var movie = filtered[indexPath.row]
        } else {
            var movie = movies![indexPath.row]
        }
        
        
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
    
        let url = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)!
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
    
    // MARK: - Search Bar
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = movies!.filter({ (text) -> Bool in
            let tmp = text["title"] as? String
            let range = tmp!.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            println("\(range)")
            return false //range.startIndex != NSNotFound
        })
        
        if (filtered.count == 0) {
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)!
        
        let movie = movies![indexPath.row]
        
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
        movieDetailsViewController.movie = movie
        
    }
    
}
