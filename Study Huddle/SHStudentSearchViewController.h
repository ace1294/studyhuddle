//
//  SHSearchViewController.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/21/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//


#import <Parse/Parse.h>
#import "SHStudentCell.h"

@interface SHStudentSearchViewController : PFQueryTableViewController <UISearchBarDelegate>

@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) PFObject *addedMember;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) PFObject *huddle;

@end

@protocol SHStudentSearchDelegate <NSObject>
@optional

- (void)didAddMember:(PFObject *)member;

@end