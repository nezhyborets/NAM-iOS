//
// Created by Alexei on 12/11/16.
// Copyright (c) 2016 Nezhyborets. All rights reserved.
//

import UIKit

final class ContentInsetHackTableView : HackTableView {
    override func forceUpdate() {
        updateInsets()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(updateInsets), object: nil)
        perform(#selector(updateInsets), with: nil, afterDelay: 0.001)
        
        /* May be used for debug purposes
        print("layoutSubviews frame \(frame)")
        print("layoutSubviews bounds \(bounds)")
         */
    }
    
    @objc private func updateInsets() {
        let header = additionalHeaderHeight + (tableHeaderView?.frame.size.height ?? 0)
        let content = contentSize.height
        var bottomInset = frame.size.height - contentInset.top - content + header
        
        if bottomInset < 0 {
            bottomInset = 0
        }
        
        if bottomInset != contentInset.bottom {
            var inset = contentInset
            inset.bottom = bottomInset
            
            contentInset = inset
            layoutIfNeeded()
            updateInsets()
        }
    }
    
    /* May be used for debug purposes
    override var contentSize: CGSize {
        set {
            let oldSize = contentSize
            super.contentSize = newValue
            
            if oldSize != newValue {
                updateInsets()
            }
            
            print("contentSize from \(oldSize) to \(newValue)")
        }
        
        get {
            return super.contentSize
        }
    }
    
    override var contentInset: UIEdgeInsets {
        set {
            let oldValue = contentInset
            super.contentInset = newValue
            print("inset from \(oldValue) to \(newValue)")
        }
        
        get {
            return super.contentInset
        }
    }
    
    override var contentOffset: CGPoint {
        set {
            let oldValue = contentOffset
            super.contentOffset = newValue
            print("offset from \(oldValue) to \(newValue)")
        }
        
        get {
            return super.contentOffset
        }
    }
    
    override var frame: CGRect {
        set {
            let oldValue = frame
            super.frame = newValue
            print("frame from \(oldValue) to \(newValue)")
        }
        
        get {
            return super.frame
        }
    }
    */
}
