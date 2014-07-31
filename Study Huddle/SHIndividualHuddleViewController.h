//
//  SHProfileViewController.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/14/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SHHuddlePortraitView.h"

@class Student;

@interface SHIndividualHuddleViewController : UIViewController
@property (strong,nonatomic) SHHuddlePortraitView* profileImage;


- (id)initWithHuddle:(PFObject *)aHuddle;
-(id)initWithHuddle:(PFObject *)aHuddle andInitialSection:(int)section;
- (void)setHuddle:(PFObject *)aHuddle;


@end
