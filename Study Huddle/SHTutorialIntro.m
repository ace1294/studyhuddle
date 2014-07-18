//
//  SHTutorialIntro.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 7/16/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHTutorialIntro.h"
#import "SHIntro1ViewController.h"
#import "SHIntro2ViewController.h"
#import "SHIntro3ViewController.h"
#import "SHStartUpViewController.h"
#import "SHSignUpViewController.h"
#import "SHLoginViewController.h"
#import "SHAppDelegate.h"
#import "UIColor+HuddleColors.h"

#define MAX_PAGES 4

@interface SHTutorialIntro ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong,nonatomic) UIPageControl* pageControl;
@property (strong,nonatomic) UIView* previousView;
@property BOOL updatedPage;

@end

@implementation SHTutorialIntro

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageController.delegate = self;
    
    self.pageController.dataSource = self;
    self.pageController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height+37);
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+self.view.frame.size.height-37, self.view.frame.size.width, 37)];
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = MAX_PAGES;
    self.pageControl.pageIndicatorTintColor = [UIColor huddleLightGrey];
    self.pageControl.currentPageIndicatorTintColor = [UIColor huddleSilver];
    

    
    SHIntro1ViewController *initialViewController = [[SHIntro1ViewController alloc]init];


    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
    [self.view addSubview:self.pageControl];



    SHAppDelegate* appDelegate = (SHAppDelegate*)[[UIApplication sharedApplication] delegate];
    if(appDelegate.isRunMoreThanOnce)
    {
        self.pageControl.currentPage = MAX_PAGES-1;
        [self goToLastPage];
    }
    

    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    UIViewController* result;
    if([viewController isKindOfClass:[SHIntro2ViewController class]])
        result = [[SHIntro1ViewController alloc]init];
    else if([viewController isKindOfClass:[SHIntro3ViewController class]])
        result = [[SHIntro2ViewController alloc]init];

    else if([viewController isKindOfClass:[SHLoginViewController class]])
        result = [[SHIntro3ViewController alloc]init];
    else //its number 1. There is no previous
        result = nil;
    
    return result;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    UIViewController* result;
    if([viewController isKindOfClass:[SHIntro1ViewController class]])
        result = [[SHIntro2ViewController alloc]init];
    else if([viewController isKindOfClass:[SHIntro2ViewController class]])
        result = [[SHIntro3ViewController alloc]init];
    else if([viewController isKindOfClass:[SHIntro3ViewController class]])
        result = [self getLogingViewController];
    else //its number 4. There is no after
        result = nil;

    return result;
}


    
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return MAX_PAGES;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

-(UIViewController*) getLogingViewController
{

        // Customize the Log In View Controller
        SHLoginViewController *logInViewController = [[SHLoginViewController alloc]init];
        logInViewController.delegate = self;
        logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsSignUpButton | PFLogInFieldsPasswordForgotten | PFLogInFieldsLogInButton;
        
        // Customize the Sign Up View Controller
        SHSignUpViewController *signUpViewController = [[SHSignUpViewController alloc] init];
        signUpViewController.delegate = self;
        signUpViewController.fields = PFSignUpFieldsUsernameAndPassword | PFSignUpFieldsEmail | PFSignUpFieldsAdditional | PFSignUpFieldsSignUpButton |PFSignUpFieldsDismissButton;
        logInViewController.signUpController = signUpViewController;
    
    return logInViewController;



}



-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if(completed)
       [self updatePageNumber];
}

-(void)updatePageNumber
{
    self.pageControl.pageIndicatorTintColor = [UIColor huddleLightGrey];
    self.pageControl.currentPageIndicatorTintColor = [UIColor huddleSilver];
    UIViewController* viewController = self.pageController.viewControllers[0];
    if([viewController isKindOfClass:[SHIntro1ViewController class]])
        self.pageControl.currentPage = 0;
    else if([viewController isKindOfClass:[SHIntro2ViewController class]])
        self.pageControl.currentPage = 1;
    else if([viewController isKindOfClass:[SHIntro3ViewController class]])
        self.pageControl.currentPage = 2;
    else
    {
        self.pageControl.currentPage = 3;
        self.pageControl.currentPageIndicatorTintColor = nil;
        self.pageControl.pageIndicatorTintColor = nil;
    }
}

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    
    
    BOOL informationComplete = YES;
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        NSLog(@"key: %@, field: %@",key,info);
        if (!field || field.length == 0) {
            informationComplete = NO;
            break;
        }
    }
    
    NSString* firstPassword = [info objectForKey:@"password"];
    NSString* secondPassword = [info objectForKey:@"additional"];
    BOOL passwordsMatch = [firstPassword isEqualToString:secondPassword];
    
    
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    if (!passwordsMatch) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Passwords do not Match", nil) message:NSLocalizedString(@"Make sure you both passwords match", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    return informationComplete && passwordsMatch;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    
    SHSignUpViewController* SHSignUpController = (SHSignUpViewController*)signUpController;
    Student* currentUser = [Student currentUser];
    
    currentUser.major = SHSignUpController.majorTextField.text;
    currentUser.hoursStudied = @"0";
    
    
    //make sure that the username is the email
    currentUser.fullName = currentUser.username;
    currentUser.username = currentUser.email;
    
    [currentUser saveInBackground];
    
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    [(SHAppDelegate*)[[UIApplication sharedApplication] delegate] doLogin];
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];

    // Present Anypic UI
    [(SHAppDelegate*)[[UIApplication sharedApplication] delegate] doLogin];
}

- (void)goToLastPage
{
    // Instead get the view controller of the first page
    UIViewController *newInitialViewController = [self getLogingViewController];
    NSArray *initialViewControllers = [NSArray arrayWithObject:newInitialViewController];
    self.pageControl.currentPageIndicatorTintColor = nil;
    self.pageControl.pageIndicatorTintColor = nil;
    
    // Do the setViewControllers: again but this time use direction animation:
    [self.pageController setViewControllers:initialViewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
}


@end

