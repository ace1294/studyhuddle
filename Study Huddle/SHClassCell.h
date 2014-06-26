//
//  SHClassCell.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/14/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <Parse/Parse.h>
#import "SHConstants.h"
#import "SHBaseTextCell.h"
@class SHClass;

@interface SHClassCell :SHBaseTextCell

@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) PFObject *huddleClass;

- (void)setClass:(PFObject *)aClass;

@end

//Title
#define classTitleX titleX
#define classTitleY titleY






@protocol SHClassCellDelegate <NSObject>
@optional

/*!
 Sent to the delegate when the activity button is tapped
 @param activity the PFObject of the activity that was tapped
 */
//- (void)cell:(SHClassCell *)cellView didTapArrowButton:(PFObject *)class;

@end
