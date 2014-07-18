//
//  SHHuddleAddViewController.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/17/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHHuddleAddViewController : UIViewController

@property (strong, nonatomic) id delegate;

@end


@protocol SHHuddleAddDelegate <NSObject>

- (void)addHuddleTapped;

@end
