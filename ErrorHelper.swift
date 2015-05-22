//
//  ErrorHelper.swift
//  Swayy
//
//  Created by Oleksii Nezhyborets on 11/20/14.
//  Copyright (c) 2014 Onix. All rights reserved.
//

let kDataFormatError = 1
let kNotLoggedInErrorCode = 2
let kNoStoredApiKeyErrorCode = 2

extension NSError {
    func equals(error: NSError) -> Bool {
        return error.domain == self.domain && self.code == error.code
    }
}

class ErrorHelper: NSObject {
    private static let kErrorDomain = NSBundle.mainBundle().bundleIdentifier != nil ? NSBundle.mainBundle().bundleIdentifier! : "defaultDomain"
    
    class func appErrorDomain() -> String {
        return kErrorDomain
    }
    
    class func errorStatusCodeKey() -> String {
        return "NAMErrorStatusCodeKey"
    }
    
    class func notLoggedInError() -> NSError {
        return NSError(domain: kErrorDomain, code: kNotLoggedInErrorCode, userInfo: [NSLocalizedDescriptionKey : "Not logged in"])
    }

    class func noStoredApiKey() -> NSError {
        return NSError(domain: kErrorDomain, code: kNoStoredApiKeyErrorCode, userInfo: [NSLocalizedDescriptionKey : ""])
    }
    
    class func dataFormatError() -> NSError {
        return NSError(domain: kErrorDomain, code: kDataFormatError, userInfo: [NSLocalizedDescriptionKey : "Wrong data format"])
    }
    
    class func errorWithMessage(errorMessage: String) -> NSError {
        return NSError(domain: kErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey : errorMessage])
    }
    
    class func simpleRequestCompletionWithErrorKey(String, completionBlock: (error: NSError?) -> ()) -> BaseRequestCompletion {
        return { (responseJson, requestError) -> () in
            var errorForCompletion: NSError?
            
            if let uError = requestError {
                errorForCompletion = uError
            } else if let errorString = responseJson?["error"] as? String {
                println("error found in json \(responseJson)")
                errorForCompletion = NSError(domain: "Debts", code: 0, userInfo: [NSLocalizedDescriptionKey : errorString])
            }
            
            completionBlock(error: errorForCompletion)
        }
    }
    
    class func errorForRequest(json: [NSObject : AnyObject]?, error: NSError?) -> NSError? {
        return self.errorForRequest(json, successKey: nil, error: error)
    }
    
    class func errorForRequest(json: [NSObject : AnyObject]?, successKey: String?, error: NSError?) -> NSError? {
        if let uError = error {
            return uError
        } else if let errorString = json?["error"] as? String {
            if errorString == "Not logged in" || errorString == "Not logged in"  {
                println(json)
                return ErrorHelper.notLoggedInError()
            } else {
                println(json)
                return ErrorHelper.errorWithMessage(errorString)
            }
        } else if let key = successKey {
            if json?[key] == nil {
                return ErrorHelper.errorWithMessage("Unknown error")
            }
        }
        
        return nil
    }
    
    class func errorForRequest(json: [NSObject : AnyObject]?, statusCode: NSInteger, error: NSError?, successKey: String?) -> NSError? {
        if statusCode == 401 {
            return ErrorHelper.notLoggedInError()
        } else if let uError = error {
            return uError
        } else if let errorString = json?["error"] as? String {
            if errorString == "Not logged in" {
                println(json)
                return ErrorHelper.notLoggedInError()
            } else {
                println(json)
                return ErrorHelper.errorWithMessage(errorString)
            }
        } else if let key = successKey {
            if json?[key] == nil {
                return ErrorHelper.errorWithMessage("Unknown error")
            }
        }
        
        return nil
    }
    
    class func textForError(error: NSError, statusCode: NSInteger) -> String? {
        var errorString: String?
        
        if error.domain == (kCFErrorDomainCFNetwork as String) {
            if error.code == -1001 {
                errorString = "Request timed out"
            } else if error.code == -1009 {
                errorString = "Not connected to the internet"
            } else if error.code == 3840 {
                errorString = "Unknown server error"
            } else if error.code == -1003 {
                errorString = "Cannot find host."
            } else if error.code == -1005 {
                errorString = "Network connection was lost."
            }
        }
        
        return errorString
    }
    
    class func userFriendlyErrorForNetworkError(error: NSError, statusCode: NSInteger) -> NSError {
        var userInfo: [NSObject : AnyObject] = [:]
        if let uErrorInfo = error.userInfo {
            userInfo = uErrorInfo
        } else {
            userInfo = [NSLocalizedDescriptionKey : "Unknown error"]
        }
        
        var userInfoM = userInfo
        if userInfo[NSLocalizedDescriptionKey] == nil {
            let errorString = self.textForError(error, statusCode: statusCode)
            
            if let string = errorString {
                userInfoM[NSLocalizedDescriptionKey] = string
            }
        }
        
        return NSError(domain: error.domain, code: error.code, userInfo: userInfoM)
    }
    
    class func userFriendlyErrorForNetworkError(error: NSError) -> NSError {
        return self.userFriendlyErrorForNetworkError(error, statusCode: NSNotFound)
    }

//    class func showErrorWithMessage(message: String, cancelButtonTitle: String, otherButtonTitles: [String], completion: (alertView: UIAlertView?, buttonIndex: Int) -> ()) {
//        UIAlertView.showWithTitle("Oops!", message: message, cancelButtonTitle: cancelButtonTitle, otherButtonTitles: otherButtonTitles, tapBlock: completion)
//    }
//
//    class func showErrorWithMessage(message: String, completion: (alertView: UIAlertView?, buttonIndex: Int) -> ()) {
//        UIAlertView.showWithTitle("Oops!", message: message, cancelButtonTitle: "Ok", otherButtonTitles: nil, tapBlock: completion)
//    }
}
