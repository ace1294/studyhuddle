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

#define nameX 0.0
#define nameY 130.0
#define nameDimY 35.0

#define classHuddleY 165.0
#define classHuddleDimY 25.0

#define classButtonX 20.0
#define classButtonDimX 280.0
#define classButtonDimY 30.0

#define personalY classHuddleY+classHuddleDimY+vertElemSpacing

#define inviteStudentDimY classHuddleDimY

#define tableX 0.0
#define tableY 430.0
#define tableDimX maxWidth
#define tableDimY 500.0

