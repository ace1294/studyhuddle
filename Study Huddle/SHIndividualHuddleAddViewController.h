//
//  SHHuddleAddViewController.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/11/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHIndividualHuddleAddViewController : UIViewController

@property (strong, nonatomic) id delegate;

@end


@protocol SHIndividualHuddleAddDelegate <NSObject>

- (void)addMemberTapped;
- (void)addResourceTapped;
- (void)addThreadTapped;

@end