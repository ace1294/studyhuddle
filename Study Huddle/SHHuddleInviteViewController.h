//
//  SHHuddleInviteViewController.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/10/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHModalViewController.h"
#import <Parse/Parse.h>

@interface SHHuddleInviteViewController : SHModalViewController

- (id)initWithToStudent:(PFObject *)aToStudent fromStudent:(PFObject *)aFromStudent;

@end
