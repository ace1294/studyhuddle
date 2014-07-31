//
//  SHHuddlePageCell.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/12/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHBaseTextCell.h"
#import <Parse/Parse.h>

@interface SHHuddlePageCell : SHBaseTextCell

@property (strong, nonatomic) PFObject *huddle;
- (void)setHuddle:(PFObject *)aHuddle;

@end


@protocol SHHuddlePageCellDelegate <SHBaseCellDelegate>
@optional

- (void)didTapInviteToStudy:(PFObject *)huddle;
- (void)didTapAddResource:(PFObject *)huddle;
- (void)didTapMember:(PFUser *)member;

@end