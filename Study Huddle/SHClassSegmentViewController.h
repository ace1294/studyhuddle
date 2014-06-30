//
//  SHClassSegmentViewController.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/29/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SHClassPageViewController.h"
#import "DZNSegmentedControl.h"
#import <Parse/Parse.h>
@class Student;


@interface SHClassSegmentViewController : UIViewController <DZNSegmentedControlDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DZNSegmentedControl *control;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic,strong) UIScrollView* parentScrollView;
@property (nonatomic, strong) SHClassPageViewController *owner;

- (id)initWithClass:(PFObject *)aClass;

- (void)setClass:(PFObject *)aClass;
- (BOOL)loadClassData;

@end
