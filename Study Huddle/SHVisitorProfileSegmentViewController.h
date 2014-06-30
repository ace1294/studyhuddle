//
//  SHProfileSegmentViewController.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/14/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZNSegmentedControl.h"
#import <Parse/Parse.h>
@class SHVisitorProfileViewController;
@class Student;

@interface SHVisitorProfileSegmentViewController : UIViewController <DZNSegmentedControlDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DZNSegmentedControl *control;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic,strong) UIScrollView* parentScrollView;
@property (nonatomic, strong) SHVisitorProfileViewController *owner;



- (id)initWithStudent:(Student *)student;

- (void)setStudent:(Student *)aSegStudent;
- (BOOL)loadStudentData;

@end


#define huddleCellHeight 70.0f
#define studentCellHeight 70.0f
#define classCellHeight 50.0f
#define requestsCellHeight 50.0f
