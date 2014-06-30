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

@property (strong, nonatomic) PFObject *addedMember;
@property (strong, nonatomic) NSString *type;

@end