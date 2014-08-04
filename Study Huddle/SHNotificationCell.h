//
//  SHNotificationCell.h
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/30/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHBaseTextCell.h"
#import <Parse/Parse.h>

@interface SHNotificationCell : SHBaseTextCell

@property (nonatomic,strong) PFObject* notification;
@property (strong, nonatomic) UILabel *expandedMessageLabel;

@property (nonatomic, strong) UIButton *acceptButton;
@property (nonatomic, strong) UIButton *denyButton;

- (void)setNotification:(PFObject *)aNotification;
- (void)expand;
- (void)collapse;
- (CGFloat)heightForExpandedCell:(NSString *)message;
- (CGFloat)heightForCollapsedCell:(NSString *)message;

@end
