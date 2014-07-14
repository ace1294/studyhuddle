//
//  SHHuddleSegmentViewController.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/24/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZNSegmentedControl.h"
#import <Parse/Parse.h>
@class Student;

@interface SHVisitorHuddleSegmentViewController : UIViewController <DZNSegmentedControlDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DZNSegmentedControl *control;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic,strong) UIScrollView* parentScrollView;
//@property (nonatomic, strong) SHIndividualHuddleviewController *owner;

- (id)initWithHuddle:(PFObject *)aHuddle;
- (void)setHuddle:(PFObject *)aHuddle;
- (BOOL)loadHuddleData;
-(float)getOccupatingHeight;


@end