//
//  SHStudentCell.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/19/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <Parse/Parse.h>
#import "SHConstants.h"
#import "SHBaseTextCell.h"


@interface SHStudentCell : SHBaseTextCell

@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) PFObject *student;
- (void)setStudent:(PFObject *)aStudent;
- (void)setOnline;

@end


//Title
#define studentTitleX cellPortraitX+cellPortraitDim+horiElemSpacing
#define studentTitleY vertViewSpacing




/*!
 The protocol defines methods a delegate of a PAPBaseTextCell should implement.
 */
@protocol SHStudentCellDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the activity button is tapped
 @param activity the PFObject of the activity that was tapped
 */
- (void)cell:(SHStudentCell *)cellView didTapStudyButton:(PFObject *)requestStudy;

@end