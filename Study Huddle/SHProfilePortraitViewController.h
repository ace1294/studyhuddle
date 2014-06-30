//
//  SHProfilePortraitViewController.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/26/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHBasePortraitViewController.h"
#import <Parse/Parse.h>

@interface SHProfilePortraitViewController : SHBasePortraitViewController

@property PFObject* portraitStudent;
-(void)setStudent: (PFObject*)student;


@end
