//
//  SHHuddleCell.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/14/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//


@class SHHuddle;
#import <Parse/Parse.h>
#import "SHConstants.h"
#import "SHBaseTextCell.h"

@interface SHHuddleCell : SHBaseTextCell

@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) PFObject *huddle;

- (void)setHuddle:(PFObject *)aHuddle;
- (void)setOnline;

@end


//Title
#define huddleTitleX cellPortraitX+cellPortraitDim+horiElemSpacing
#define huddleTitleY vertViewSpacing





/*!
 The protocol defines methods a delegate of a PAPBaseTextCell should implement.
 */
@protocol SHHuddleCellDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the activity button is tapped
 @param activity the PFObject of the activity that was tapped
 */
- (void)cell:(SHHuddleCell *)cellView didTapStudyButton:(PFObject *)requestStudy;
- (void)cell:(SHHuddleCell *)cellView didTapTitleButton:(PFObject *)requestStudy;

@end
