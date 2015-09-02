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
        
        titleLabel.text = movie["title"] as? String
        synopsisLabel.text = movie["synopsis"] as? String
        titleLabel.sizeToFit()
        synopsisLabel.sizeToFit()
        scrollView.contentSize.height = titleLabel.frame.height + synopsisLabel.frame.height + 500
        
        // Get small image URL
        var url = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)!
        imageView.setImageWithURL(url)
        
        //Capture urlString with bigger image
        var urlString = movie.valueForKeyPath("posters.original") as! String
        var range = urlString.rangeOfString(".*cloudfront.net/", options: .RegularExpressionSearch)
        
        if let range = range {
            urlString = urlString.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")

            //convert urlString -> NSURL
            url = NSURL(string: urlString)!
            imageView.setImageWithURL(url)
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
