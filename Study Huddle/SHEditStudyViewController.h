//
//  SHEditStudyViewController.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/9/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHModalViewController.h"
#import <Parse/Parse.h>
#import "SHHuddleButtons.h"

@interface SHEditStudyViewController : SHModalViewController

//Content
@property (strong, nonatomic) SHHuddleButtons *subjectButtons;
@property (strong, nonatomic) UITextView *descriptionTextView;

- (id)initWithStudy:(PFObject *)aStudy;



@end




