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
- (void)setRequest:(PFObject *)aRequest;

@end

#define acceptX 245.0
#define requestButtonY 15.0
#define requestButtonWidth 40.0

#define denyX acceptX+requestButtonWidth+horiElemSpacing

@protocol SHRequestCellDelegate <SHBaseCellDelegate>
@optional

- (void)didTapAccept:(SHRequestCell *)cell;
- (void)didTapDeny:(SHRequestCell *)cell;

@end