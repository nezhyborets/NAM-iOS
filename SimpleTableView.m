//
//  SimpleTableView.m
//  WinePicker
//
//  Created by Oleksii Nezhyborets on 21.08.15.
//  Copyright (c) 2015 Onix-Systems. All rights reserved.
//

#import <UIAlertView+Blocks/UIAlertView+Blocks.h>
#import "SimpleTableView.h"

@interface SimpleTableView() <UITableViewDataSource, UITableViewDelegate>
@end

@implementation SimpleTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
    }

    return self;
}

- (void)setContentSize:(CGSize)contentSize {
    [super setContentSize:contentSize];

    if (self.shouldFitToContentSize) {
        CGRect frame = self.frame;
        frame.size.height = self.contentSize.height;
        self.frame = frame;
    }
}

- (void)setItems:(NSArray *)items {
    if (_items != items) {
        _items = items;
        [self reloadData];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"simpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.separatorInset = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
        cell.indentationWidth = self.textX;
        cell.indentationLevel = 1;
    }

    cell.textLabel.text = self.items[indexPath.row];
    cell.textLabel.font = self.textFont;
    cell.textLabel.textColor = self.textColor;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

@end
