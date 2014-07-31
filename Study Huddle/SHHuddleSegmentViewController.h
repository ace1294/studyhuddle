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
@class SHIndividualHuddleViewController;

@interface SHHuddleSegmentViewController : UIViewController <DZNSegmentedControlDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DZNSegmentedControl *control;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic,strong) UIScrollView* parentScrollView;
@property (nonatomic, strong) SHIndividualHuddleViewController *owner;

- (id)initWithHuddle:(PFObject *)aHuddle;
-(id)initWithHuddle:(PFObject *)aHuddle andInitialSection:(int)section;
- (void)setHuddle:(PFObject *)aHuddle;
-(float)getOccupatingHeight;
- (BOOL)loadHuddleData;

- (void)didAddMember:(PFObject *)member;

@end