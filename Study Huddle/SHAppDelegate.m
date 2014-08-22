//
//  SHAppDelegate.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/8/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHAppDelegate.h"
#import <Parse/Parse.h>
#import "SHStartUpViewController.h"
#import "UIColor+HuddleColors.h"
#import "SHVisitorProfileViewController.h"
#import "SHLoginViewController.h"
#import "SHConstants.h"
#import "SHProfileViewController.h"
#import "SHSearchViewController.h"
#import "SHTutorialIntro.h"
#import "MBProgressHUD.h"
#import "SHCache.h"


@interface SHAppDelegate()<MBProgressHUDDelegate>

@property SHStartUpViewController* startUpViewController;


@property (nonatomic,strong) PFObject* student;
@property (nonatomic,strong) MBProgressHUD* HUD;

@end

@implementation SHAppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   
    
    [self setupAppearance];
    
    [self setupParseWithOptions:launchOptions];
    
    // Register for push notifications
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    

    
    self.isRunMoreThanOnce = [[NSUserDefaults standardUserDefaults] boolForKey:@"isRunMoreThanOnce"];
    if(!self.isRunMoreThanOnce){
        // Show the alert view
        // Then set the first run flag
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isRunMoreThanOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //show the tutorial thingy
        [self doTutorial];
    }
    else
    {
        self.startUpViewController = [[SHStartUpViewController alloc]init];
        self.navController = [[UINavigationController alloc] initWithRootViewController:self.startUpViewController];
        self.window.rootViewController = self.navController;
        self.window.backgroundColor = [UIColor clearColor];
        [self.window makeKeyAndVisible];
    }
    
 

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
   //check to see if the badge should be incremented
   /* NSDictionary* app = [userInfo objectForKey:@"aps"];
    NSNumber* badgeNumber = [app objectForKey:@"badge"];
    [application setApplicationIconBadgeNumber:[badgeNumber intValue]];*/
    

}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))handler {
    
    NSLog(@"this got called");
    [[SHCache sharedCache]reloadCacheCurrentUser];
    [PFPush handlePush:userInfo];
    self.tabBarController.selectedIndex = 3;
    
}



#pragma mark - AppDelegate



-(void)userLoggedIn:(PFUser *)user
{
    
    //start the loading screen
    self.student = user;
 	MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.window];
	[self.window addSubview:HUD];
    self.HUD = HUD;
	HUD.delegate = self;
	HUD.labelText = @"Loading...";
	[HUD showWhileExecuting:@selector(loadData) onTarget:self withObject:nil animated:YES];
    
    //subscribe to a channel so people can target that user
    //the channel name will be the objectID of the user with an "a" appended because it needs to start with a letter
    NSString* channel = [NSString stringWithFormat:@"a%@",[[PFUser currentUser] objectId]];
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation addUniqueObject:channel forKey:@"channels"];
    [currentInstallation saveInBackground];
    
//    PFQuery *query = [PFQuery queryWithClassName:SHClassParseClass];
//    NSArray *classes = [query findObjects];
//    PFRelation *relation = [[Student currentUser] relationForKey:SHStudentClassesKey];
//    [relation addObject:classes[0]];
//    [relation addObject:classes[3]];
//    [relation addObject:classes[4]];
//    [relation addObject:classes[5]];
//    
//    [[Student currentUser]saveInBackground];
    
    

    
    
}

-(void)loadData
{
    [[SHCache sharedCache] reloadCacheCurrentUser];
    
}

-(void)logout
{
    [[SHCache sharedCache]clearCache];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SHUserDefaultsHuddlesKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SHUserDefaultsClassesKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SHUserDefaultsStudyFriendsKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SHUserDefaultsStudyLogsKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SHUserDefaultsNotificationsKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SHUserDefaultsRequestsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //[[PFInstallation currentInstallation] removeObjectForKey:]
    //[[PFInstallation currentInstallation] saveInBackground];
    NSString* channel = [NSString stringWithFormat:@"a%@",[[PFUser currentUser] objectId]];
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation removeObject:channel forKey:@"channels"];
    [currentInstallation saveInBackground];
    
    [PFQuery clearAllCachedResults];

    
    [PFUser logOut];
    //self.startUpViewController = [[SHStartUpViewController alloc]init];
    //self.navController = [[UINavigationController alloc] initWithRootViewController:self.startUpViewController];
    //self.navController.navigationBar.barTintColor = [UIColor huddleOrange];
    //[self.navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
  
    //self.window.rootViewController = self.navController;

    self.startUpViewController = [[SHStartUpViewController alloc]init];
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.startUpViewController];
    self.window.rootViewController = self.navController;

    self.window.backgroundColor = [UIColor clearColor];
}

- (void)presentTabBarController
{

    //profile
    self.profileController = [[SHProfileViewController alloc]init];
    self.profileNavigator = [[UINavigationController alloc] initWithRootViewController:self.profileController];
    self.profileNavigator.navigationBar.barTintColor = [UIColor huddleOrange];
    [self.profileNavigator.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    //huddles
    self.huddlesController = [[SHHuddleViewController alloc]init];
    self.huddlesNavigator = [[UINavigationController alloc] initWithRootViewController:self.huddlesController];
    self.huddlesNavigator.navigationBar.barTintColor = [UIColor huddleOrange];
    [self.huddlesNavigator.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.searchController = [[SHSearchViewController alloc]init]; //temporary for testing purposes
    self.searchNavigator = [[UINavigationController alloc] initWithRootViewController:self.searchController];
    self.searchNavigator.navigationBar.barTintColor = [UIColor huddleOrange];
    [self.searchNavigator.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    //notification
    self.notificationController = [[SHNotificationViewController alloc]initWithStudent:[PFUser currentUser]];
    self.notificationNavigator = [[UINavigationController alloc] initWithRootViewController:self.notificationController];
    self.notificationNavigator.navigationBar.barTintColor = [UIColor huddleOrange];
    [self.notificationNavigator.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.tabBarController = [[UITabBarController alloc]init];
    [[UITabBar appearance] setTintColor:[UIColor huddleOrange]];
    
    [self.profileController setStudent:[PFUser currentUser]];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:self.profileNavigator, self.huddlesNavigator,self.searchNavigator,self.notificationNavigator ,nil];

    
    
    self.window.rootViewController = self.tabBarController;
    self.window.backgroundColor = [UIColor whiteColor];
    
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[hud removeFromSuperview];
    [self presentTabBarController];

}

#pragma mark - ()

- (void)setupParseWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"tYVLuBAkB3oeGEo8dQa0mQdW8AfyppZHI92DKvTk"
                  clientKey:@"BZ4boxrBIGK0dJKV47r7hVJ4D4C9bSensOhR46kN"];
    
    // Track app open.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //    PFACL *defaultACL = [PFACL ACL];
    //    // Enable public read access by default, with any newly created PFObjects belonging to the current user
    //    [defaultACL setPublicReadAccess:YES];
    //    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
}

//Setup up all Study Huddle custom Appearance attributes
- (void)setupAppearance
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor huddleOrange]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [[UIButton appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}
                                                forState:UIControlStateNormal];
    
    [[UISearchBar appearance] setTintColor:[UIColor whiteColor]];
}

-(void)doTutorial
{
    
    self.window.rootViewController = [[SHTutorialIntro alloc]init];
    self.window.backgroundColor = [UIColor clearColor];
    [self.window makeKeyAndVisible];
}



@end
