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


#define dateHeaderY 70.0
#define timeStudiedHeaderY 120.0
#define subjectHeaderY 170.0
#define descriptionHeaderY 220.0

#define dateY dateHeaderY+headerHeight
#define timeStudiedY timeStudiedHeaderY+headerHeight
#define subjectY subjectHeaderY+headerHeight
#define descriptionY descriptionHeaderY+headerHeight

#define contentWidth 290.0
#define contentHeight 25.0