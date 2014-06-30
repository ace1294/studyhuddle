//
//  SHResourceViewController.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/29/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SHResourceViewController : UIViewController

- (id)initWithResource:(PFObject *)aResource;

@end
