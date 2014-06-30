//
//  SHStartUpViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/8/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHStartUpViewController.h"
#import "SHLoginViewController.h"
#import "SHSignUpViewController.h"
#import "SHProfileHeaderViewController.h"
#import "SHAppDelegate.h"
#import "UIColor+HuddleColors.h"

#define logoWidth 200
#define logoHeight 100

@interface SHStartUpViewController ()

@property SHProfileHeaderViewController* profileVC;

@property UIView* profileVCContainer;


@end

@implementation SHStartUpViewController

#pragma mark - UIViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set up the background
    //Background
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainBG.png"]]];
    UIImageView* logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo.png"]];
    [logo setFrame:CGRectMake(self.view.frame.size.width/2-logoWidth/2 , self.view.frame.size.height/2 - logoHeight/2, logoWidth, logoHeight)];
    [self.view addSubview:logo];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 240);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // If not logged in, present login view controller
   /* if (![PFUser currentUser]) {
        NSLog(@"got called again");
        [(SHAppDelegate*)[[UIApplication sharedApplication] delegate] presentLoginViewController];
        return;
    }
    // Present Anypic UI
    [(SHAppDelegate*)[[UIApplication sharedApplication] delegate] presentProfileViewController];*/
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    
    [super viewDidLoad];
    
    [self setTitle:@"StartUp"];
    if (![Student currentUser]) {
        NSLog(@"got called");
        // Customize the Log In View Controller
        SHLoginViewController *logInViewController = [[SHLoginViewController alloc]init];
        logInViewController.delegate = self;
        logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsSignUpButton | PFLogInFieldsPasswordForgotten | PFLogInFieldsLogInButton;
        
        // Customize the Sign Up View Controller
        SHSignUpViewController *signUpViewController = [[SHSignUpViewController alloc] init];
        signUpViewController.delegate = self;
        signUpViewController.fields = PFSignUpFieldsUsernameAndPassword | PFSignUpFieldsEmail | PFSignUpFieldsAdditional | PFSignUpFieldsSignUpButton |PFSignUpFieldsDismissButton;
        logInViewController.signUpController = signUpViewController;
        
        // Present Log In View Controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
    else
    {
        [(SHAppDelegate*)[[UIApplication sharedApplication] delegate] doLogin];
    }
    
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logOutButtonTapAction:(id)sender
{
    
}

#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    if (username && password && username.length && password.length) {
        return YES;
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO;
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    NSLog(@"LOGGED IN");
    
    // Present Anypic UI
    [(SHAppDelegate*)[[UIApplication sharedApplication] delegate] presentProfileViewController];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"User dismissed the logInViewController");
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - PFSignUpViewControllerDelegate

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
    [self.profileVC doLayout];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
