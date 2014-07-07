//
//  SHIndividualResourceViewController.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/6/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SHConstants.h"

@interface SHIndividualResourceViewController : UIViewController

@property (strong, nonatomic) PFObject *resource;

- (id)initWithResource: (PFObject *)aResource;

@end


#define nameHeaderY 70.0
#define linkHeaderY 120.0
#define descrHeaderY 190.0

#define resourceNameY nameHeaderY+headerHeight
#define linkY linkHeaderY+headerHeight
#define descrY descrHeaderY+headerHeight

#define contentWidth 290.0
#define contentHeight 25.0
