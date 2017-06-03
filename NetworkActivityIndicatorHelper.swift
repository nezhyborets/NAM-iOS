//
//  NetworkActivityIndicatorHelper.swift
//  Swayy
//
//  Created by Oleksii Nezhyborets on 03.03.15.
//  Copyright (c) 2015 Nezhyborets. All rights reserved.
//

import UIKit

class NetworkActivityIndicatorHelper: NSObject {
    static var number: Int = 0
    
    class func addOperation() {
        DispatchQueue.main.async(execute: { () -> Void in
            self.number += 1
            UIApplication.shared.isNetworkActivityIndicatorVisible = (self.number > 0)
        })
    }
    
    class func removeOperation() {
        DispatchQueue.main.async(execute: { () -> Void in
            self.number -= 1
            if (self.number < 0) {
                fatalError("Network Activity Indicator was asked to hide more often than shown")
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = (self.number > 0)
        })
    }
}
