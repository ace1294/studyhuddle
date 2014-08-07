//
//  SHNewHuddleViewController.h
//  Sample
//
//  Created by Jason Dimitriou on 6/12/14.
//  Copyright (c) 2014 Epic Peaks GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class SHPageImageView;
@class SHHuddle;

@interface SHNewHuddleViewController : UIViewController <UINavigationControllerDelegate>


@property (strong, nonatomic) PFObject *huddle;

- (id)initWithStudent:(PFObject *)aStudent;

@end





