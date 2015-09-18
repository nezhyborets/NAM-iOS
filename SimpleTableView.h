//
//  SimpleTableView.h
//  WinePicker
//
//  Created by Oleksii Nezhyborets on 21.08.15.
//  Copyright (c) 2015 Onix-Systems. All rights reserved.
//

typedef void (^SimpleTableViewSelectBlock)(NSIndexPath *indexPath);

@interface SimpleTableView : UITableView
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic) CGFloat textX;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic) BOOL shouldFitToContentSize;
@property (nonatomic, copy) SimpleTableViewSelectBlock block;
@end