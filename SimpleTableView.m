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
@property (nonatomic) CGSize selectionImageSize;
@end

@implementation SimpleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        UIView *v = self.contentView;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [v addSubview:imageView];
        self.selectionImageView = imageView;
        
        _selectionImageSize = CGSizeZero;
        [self remakeSelectionImageViewConstraints];
    }
    
    return self;
}

- (void)setSelectionImageSize:(CGSize)selectionImageSize {
    if (!CGSizeEqualToSize(_selectionImageSize, selectionImageSize)) {
        _selectionImageSize = selectionImageSize;
        [self remakeSelectionImageViewConstraints];
    }
}

- (void)remakeSelectionImageViewConstraints {
    [self.selectionImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView.mas_trailingMargin);
        make.centerY.equalTo(self.contentView);
        
        if (!CGSizeEqualToSize(self.selectionImageSize, CGSizeZero)) {
            make.width.equalTo(@(self.selectionImageSize.width));
            make.height.equalTo(@(self.selectionImageSize.height));
        }
    }];
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
        self.removeMargins = YES;
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

- (void)hideSeparatorsForEmptyCells {
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 0)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"simpleTableIdentifier";
    SimpleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (!cell) {
        cell = [[SimpleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        if (self.removeMargins) {
            cell.separatorInset = UIEdgeInsetsZero;
            cell.layoutMargins = UIEdgeInsetsZero;
            cell.preservesSuperviewLayoutMargins = NO;
            cell.indentationWidth = self.textX;
            cell.indentationLevel = 1;
        }
        
        cell.selectionStyle = self.selectionStyle;
        cell.selectionImageSize = self.imageSize;
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
        self.selectedValue = nil;
        
        if (self.didSelectBlock) {
            self.didSelectBlock(nil);
        }
    } else {
        if (previouslySelectedIndex == NSNotFound) {
            [indexPathsToReload addObject:indexPath];
        } else {
            [indexPathsToReload addObject:previouslySelectedIndexPath];
            [indexPathsToReload addObject:indexPath];
        }
        
        self.selectedValue = self.items[indexPath.row];
        
        if (self.didSelectBlock) {
            self.didSelectBlock(indexPath);
        }
    }
    
    [tableView reloadRowsAtIndexPaths:indexPathsToReload withRowAnimation:UITableViewRowAnimationNone];
}


@end
