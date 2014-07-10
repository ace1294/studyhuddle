//
//  SHStudyViewController.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/8/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SHConstants.h"

@interface SHStudyViewController : UIViewController

@property (strong, nonatomic) PFObject *study;

- (id)initWithStudy: (PFObject *)aStudy;

@end


