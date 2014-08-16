//
//  SHHuddleStartStudyingViewController.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/15/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHModalViewController.h"
#import <Parse/Parse.h>

@interface SHHuddleStartStudyingViewController : SHModalViewController

- (id)initWithHuddle:(PFObject *)aHuddle;

@end

@protocol SHStartStudyingDelegate <NSObject>

- (void)activateStudyLog:(PFObject *)study;

@end
