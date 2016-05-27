//
//  SimpleTableView.m
//  WinePicker
//
//  Created by Oleksii Nezhyborets on 21.08.15.
//  Copyright (c) 2015 Onix-Systems. All rights reserved.
//

#import "SimpleTableView.h"

@interface SimpleTableViewCell : UITableViewCell
@property (nonatomic, weak) UIImageView *selectionImageView;
@end

@implementation SimpleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        UIView *v = self.contentView;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [v addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(v.mas_trailingMargin);
            make.centerY.equalTo(v);
        }];
        self.selectionImageView = imageView;
    }
    
    return self;
}

@end

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
    SimpleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (!cell) {
        cell = [[SimpleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.separatorInset = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
        cell.indentationWidth = self.textX;
        cell.indentationLevel = 1;
        cell.selectionStyle = self.selectionStyle;
    }

    NSString *value = self.items[indexPath.row];
    cell.textLabel.text = value;
    cell.textLabel.font = self.textFont;
    cell.textLabel.textColor = self.textColor;

    if ([value isEqualToString:self.selectedValue]) {
        cell.selectionImageView.image = self.selectionImage;
    } else {
        cell.selectionImageView.image = nil;
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableArray *indexPathsToReload = [[NSMutableArray alloc] init];
    NSInteger previouslySelectedIndex = [self.items indexOfObject:self.selectedValue];
    NSIndexPath *previouslySelectedIndexPath = [NSIndexPath indexPathForRow:previouslySelectedIndex inSection:0];
    
    if (indexPath.row == previouslySelectedIndex) {
        [indexPathsToReload addObject:previouslySelectedIndexPath];
    } else if (previouslySelectedIndex == NSNotFound) {
        [indexPathsToReload addObject:indexPath];
    } else {
        [indexPathsToReload addObject:previouslySelectedIndexPath];
        [indexPathsToReload addObject:indexPath];
    }
    
    self.selectedValue = self.items[indexPath.row];
    [tableView reloadRowsAtIndexPaths:indexPathsToReload withRowAnimation:UITableViewRowAnimationNone];
    
    if (self.didSelectBlock) {
        self.didSelectBlock(indexPath);
    }
}


@end
