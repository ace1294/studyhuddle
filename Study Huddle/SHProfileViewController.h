//
//  SHProfileViewController.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/14/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHVisitorProfileSegmentViewController.h"
#import "SHProfileHeaderViewController.h"
#import "SHProfilePortraitView.h"

@class Student;

@interface SHProfileViewController : UIViewController
@property (strong,nonatomic) SHProfilePortraitView* profileImage;


- (id)initWithStudent:(Student *)aStudent;
- (void)setStudent:(Student *)aProfStudent;
-(void)setNavigationBarItems;

@end
