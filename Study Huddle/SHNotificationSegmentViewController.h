//
//  SHNotificationSegmentViewController.h
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/30/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DZNSegmentedControl.h"
#import <Parse/Parse.h>
#import "SHNotificationViewController.h"




@interface SHNotificationSegmentViewController : UIViewController <DZNSegmentedControlDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DZNSegmentedControl *control;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic,strong) UIScrollView* parentScrollView;
@property (nonatomic, strong) SHNotificationViewController *owner;



- (id)initWithStudent:(PFUser *)student;

- (void)setStudent:(PFUser *)aSegStudent;
- (BOOL)loadStudentData;

@end


#define cellHeight 50