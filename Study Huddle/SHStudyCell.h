//
//  SHStudyCell.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/20/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBaseTextCell.h"
#import <Parse/Parse.h>
#import "SHConstants.h"

@interface SHStudyCell : SHBaseTextCell

@property  (strong, nonatomic) PFObject *study;

- (void)setStudy:(PFObject *)aStudy;

@end

#define studyTitleX titleX
#define studyTitleY titleY

//@protocol SHStudyCellDelegate <NSObject>
//
//
//
//@end
