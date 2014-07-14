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



@protocol SHRequestCellDelegate <SHBaseCellDelegate>
@optional

- (void)didTapAccept:(PFObject *)request;
- (void)didTapDeny:(PFObject *)request;

@end