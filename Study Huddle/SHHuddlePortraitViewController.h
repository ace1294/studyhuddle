//
//  SHHuddlePortraitViewController.h
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/26/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHBasePortraitViewController.h"
#import <Parse/Parse.h>

@interface SHHuddlePortraitViewController : SHBasePortraitViewController

@property PFObject* portraitHuddle;
-(void)setHuddle: (PFObject*)huddle;

@end
