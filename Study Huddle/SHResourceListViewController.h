//
//  SHResourceListViewController.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/6/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SHResourceListViewController : UIViewController

@property (strong, nonatomic) PFObject *category;

- (id)initWithResourceCategory:(PFObject *)aCategory;

@end
