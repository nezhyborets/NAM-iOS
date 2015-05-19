//
//  NetworkActivityIndicatorHelper.swift
//  Swayy
//
//  Created by Oleksii Nezhyborets on 03.03.15.
//  Copyright (c) 2015 Onix. All rights reserved.
//

import UIKit

class NetworkActivityIndicatorHelper: NSObject {
    static var number: Int = 0
    
    class func addOperation() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.number++
            UIApplication.sharedApplication().networkActivityIndicatorVisible = (self.number > 0)
        })
    }
    
    class func removeOperation() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.number--
            if (self.number < 0) {
                fatalError("Network Activity Indicator was asked to hide more often than shown")
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = (self.number > 0)
        })
    }
}
