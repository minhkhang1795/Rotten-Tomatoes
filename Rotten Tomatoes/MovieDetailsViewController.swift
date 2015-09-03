//
//  MovieDetailsViewController.swift
//  Rotten Tomatoes
//
//  Created by Clover on 8/27/15.
//  Copyright (c) 2015 Clover. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Description
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["synopsis"] as? String
        titleLabel.sizeToFit()
        synopsisLabel.sizeToFit()
        scrollView.contentSize.height = titleLabel.frame.height + synopsisLabel.frame.height + 500
        
        
        // Get small-image URL
        var url_small = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)!
        var urlRequest_small = NSURLRequest(URL: url_small, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 600)
        
        //Capture urlString with larger image
        var urlString = movie.valueForKeyPath("posters.original") as! String
        var range = urlString.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        if let range = range {
            urlString = urlString.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")

            //convert String -> NSURL
            var url_large = NSURL(string: urlString)!
            
            //convert NSURL -> NSURLRequest
            var urlRequest_large = NSURLRequest(URL: url_large)
            
            //get placeholderImage from URL_small image
            var placeholderImage = UIImage(data: NSData(contentsOfURL: url_small)!)
            
            self.imageView.setImageWithURLRequest(urlRequest_large, placeholderImage: placeholderImage, success: { (request: NSURLRequest!,response: NSHTTPURLResponse!, image: UIImage!) -> Void in
                    self.imageView.image = image
                }, failure: nil)
            //THIS WILL RETURN IMMEDIATELY if I've already downloaded the high resolution image: imageView.setImageWithURL(url)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
