//
//  SHChatEntrySegmentViewController.h
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/30/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DZNSegmentedControl.h"
#import <Parse/Parse.h>
#import "SHChatEntryViewController.h"




@interface SHChatEntrySegmentViewController : UIViewController <DZNSegmentedControlDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) DZNSegmentedControl *control;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic,strong) UIScrollView* parentScrollView;
@property (nonatomic, strong) SHChatEntryViewController *owner;



- (id)initWithChatEntry:(PFObject *)aChatEntry;

- (void)setChatEntry:(PFObject *)aChatEntry;
- (BOOL)loadChatEntryData;

@end


#define cellHeight 80