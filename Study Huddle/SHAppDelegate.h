//
//  SHAppDelegate.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/8/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHHuddleViewController.h"
#import "SHIndividualHuddleviewController.h"
#import "SHClassPageViewController.h"
#import "SHNotificationViewController.h"
#import "SHVisitorHuddleViewController.h"
#import "SHVisitorClassPageViewController.h"
#import "SHSearchViewController.h"

@class SHProfileViewController;

@interface SHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SHProfileViewController *profileController;
@property (strong, nonatomic) UINavigationController *profileNavigator;

@property (strong, nonatomic) SHHuddleViewController *huddlesController;
@property (strong, nonatomic) UINavigationController *huddlesNavigator;

@property (strong, nonatomic) SHSearchViewController *searchController; //temporary for testing
@property (strong, nonatomic) UINavigationController *searchNavigator;

@property (strong, nonatomic) SHNotificationViewController *notificationController; //temporary for testing
@property (strong, nonatomic) UINavigationController *notificationNavigator;

@property (strong, nonatomic) UINavigationController* navController;

@property (strong,nonatomic) UITabBarController* tabBarController;

@property BOOL isRunMoreThanOnce;

- (void)presentTabBarController;

-(void)userLoggedIn:(PFUser *)user;
-(void)logout;
-(void)doTutorial;

@end
