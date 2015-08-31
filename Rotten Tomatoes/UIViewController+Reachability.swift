//
//  UIViewController+Reachability.swift
//  Rotten Tomatoes
//
//  Created by Clover on 9/1/15.
//  Copyright (c) 2015 Clover. All rights reserved.
//

import UIKit

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var Status: Bool = false
        let url = NSURL(string: "http://google.com/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: NSURLResponse?
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: nil) as NSData?
        
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                Status = true
            }
        }
        
        return Status
    }
}

extension UIViewController {
    func doIfConnected( onConnected: () -> Void, errorMessageView: UIView, closeButton: UIView ) {
        if Reachability.isConnectedToNetwork() {
            onConnected()
            
            //Turn Network Error bar off
            if errorMessageView.frame.origin.y == 64 {
                UIView.animateWithDuration(0.4, delay: 0.5, options: .CurveEaseOut, animations: {
                    errorMessageView.frame.origin.y -= errorMessageView.frame.size.height
                    closeButton.frame.origin.y -= errorMessageView.frame.size.height
                    }, completion: nil)
            }
        } else {
            //Turn Network Error bar on
            if errorMessageView.frame.origin.y == 32 {
                UIView.animateWithDuration(0.4, delay: 0.5, options: .CurveEaseOut, animations: {
                    errorMessageView.frame.origin.y += errorMessageView.frame.size.height
                    closeButton.frame.origin.y += errorMessageView.frame.size.height
                }, completion: nil)
            }
        }
        println(errorMessageView.frame.origin.y)
    }
}