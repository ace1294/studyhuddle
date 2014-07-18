//
//  SHRequestCell.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/14/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <Parse/Parse.h>
#import "SHBaseTextCell.h"

@interface SHRequestCell : SHBaseTextCell

@property (strong, nonatomic) PFObject *request;
@property (nonatomic, strong) UILabel *expandedMessageLabel;

@property (nonatomic, strong) UIButton *acceptButton;
@property (nonatomic, strong) UIButton *denyButton;

- (void)setRequest:(PFObject *)aRequest;
- (void)expand;
- (void)collapse;

- (CGFloat)heightForExpandedCell:(NSString *)message;

@end



@protocol SHRequestCellDelegate <SHBaseCellDelegate>
@optional

- (void)didTapAccept:(PFObject *)request;
- (void)didTapDeny:(PFObject *)request;

@end