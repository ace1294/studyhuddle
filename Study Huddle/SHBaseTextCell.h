//
//  SHBaseTextCell.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/20/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBaseTextCell : UITableViewCell

@property (nonatomic, strong) id delegate;

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIButton *titleButton;

@end


@protocol SHBaseCellDelegate <NSObject>
@optional

- (void)didTapTitleCell:(SHBaseTextCell *)cell;

@end
