//
// Created by Alexei on 12/11/16.
// Copyright (c) 2016 Nezhyborets. All rights reserved.
//

import UIKit

class HackTableView : UITableView {
    var additionalHeaderHeight: CGFloat = 0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    func forceUpdate() {
        fatalError("abstract")
    }
}
