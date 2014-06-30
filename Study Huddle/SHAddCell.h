//
//  SHAddCell.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/14/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//
#import <Parse/Parse.h>
#import "SHConstants.h"
#import "SHBaseTextCell.h"

@interface SHAddCell : SHBaseTextCell

@property (nonatomic, strong) NSString *typeIdentifier;

- (void)didTapAddButtonAction:(id)sender;
- (void)setAdd:(NSString *)addTitle identifier:(NSString *)cellID;

@end

//Title
#define addTitleX 80.0
#define addTitleY 25.0
//#define nameMaxWidth 320.f-titleX-80.0f

//Add
#define addDim 30.0f



/*!
 The protocol defines methods a delegate of a PAPBaseTextCell should implement.
 */
@protocol SHAddCellDelegate <NSObject>
@optional

/*!
 Sent to the delegate when a user button is tapped
 @param aUser the PFUser of the user that was tapped
 */
- (void)didTapAddButton:(SHAddCell *)cell;

@end