//
//  SHProfilePortraitView.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/26/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHBasePortraitView.h"
#import <Parse/Parse.h>

@interface SHProfilePortraitView : SHBasePortraitView

-(void)setStudent: (PFObject*)student;

@end
