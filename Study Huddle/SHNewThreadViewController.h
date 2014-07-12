//
//  SHNewThreadViewController.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/11/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHModalViewController.h"
#import <Parse/Parse.h>

@interface SHNewThreadViewController : SHModalViewController

- (id)initWithChatCategory:(PFObject *)aCategory;

@end
