//
//  SHProfileViewController.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/14/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHProfileViewController.h"
#import "SHProfileSegmentViewController.h"
#import "SHProfileHeaderViewController.h"
@class Student;

@class SHProfileSegmentViewController;

@interface SHProfileViewController : UIViewController
@property (strong, nonatomic) SHProfileHeaderViewController* profileVC;
@property (strong,nonatomic) SHProfilePortraitView* profileImage;


- (id)initWithStudent:(Student *)aStudent;
- (void)setStudent:(Student *)aProfStudent;

@end
