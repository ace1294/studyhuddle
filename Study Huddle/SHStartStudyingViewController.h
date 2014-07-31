//
//  SHStartStudyingViewController.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/6/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SHModalViewController.h"
#import "SHConstants.h"

@interface SHStartStudyingViewController : SHModalViewController

- (id)initWithStudent:(PFObject *)aStudent studyObject:(PFObject *)aStudy;

@end


@protocol SHStartStudyingDelegate <NSObject>

- (void)activateStudyLog:(PFObject *)study;

@end


#define privacyHeaderY firstHeader

#define subjectHeaderY huddleButtonHeight*2+vertElemSpacing+privacyHeaderY+headerHeight
