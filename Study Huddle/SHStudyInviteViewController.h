//
//  SHStudyInviteViewController.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/10/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHModalViewController.h"
#import <Parse/Parse.h>

@interface SHStudyInviteViewController : SHModalViewController

- (id)initWithFromStudent:(PFObject *)aStudent1 toStudent:(PFObject *)aStudent2;

@end
