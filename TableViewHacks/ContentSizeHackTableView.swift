//
//  TableView.swift
//  Evenly
//
//  Created by Alexei on 12/4/16.
//  Copyright © 2016 Nezhyborets. All rights reserved.
//

import UIKit

final class ContentSizeHackTableView: HackTableView {
    private var minimumContentHeight : CGFloat? = nil

    override var contentSize: CGSize {
        get {            
            return super.contentSize
        }
        
        set {
            if let min = minimumContentHeight {
                showsVerticalScrollIndicator = !(newValue.height <= min)
                
                if newValue.height < min {
                    super.contentSize = CGSize(width: newValue.width, height: min)
                    return
                }
            } else {
                showsVerticalScrollIndicator = true
            }
            
            super.contentSize = newValue
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(updateTableContentSize), object: nil)
        perform(#selector(updateTableContentSize), with: nil, afterDelay: 0.001)
    }
    
    @objc fileprivate func updateTableContentSize() {
        let tableInsets = self.contentInset
        let tableHeight = self.frame.size.height - tableInsets.top - tableInsets.bottom
        let searchBarHeight = (self.tableHeaderView?.frame.size.height ?? 0)
        let height = tableHeight + additionalHeaderHeight + searchBarHeight
        self.minimumContentHeight = height
        let contentSize = self.contentSize
        self.contentSize = contentSize
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}
