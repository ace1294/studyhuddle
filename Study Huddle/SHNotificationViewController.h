//
//  SHNotificationViewController.h
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/30/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SHNotificationViewController : UIViewController

-(id)initWithStudent:(PFUser *)aStudent;

@end
