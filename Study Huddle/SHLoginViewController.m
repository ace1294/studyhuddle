//
//  SHLoginViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/8/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHLoginViewController.h"
#import "UIColor+HuddleColors.h"
#import "SHAppDelegate.h"

#define tutorialVerticalOffsetFromButtons 10

@interface SHLoginViewController ()


@end

@implementation SHLoginViewController

-(void)loadView
{
    [super loadView];
    
    //Background
    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"LaunchBackground.png"]]];
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LaunchLogo.png"]]];
    
    //Fields
    [self.logInView.usernameField setTextColor:[UIColor huddleOrange]];
    [self.logInView.passwordField setTextColor:[UIColor huddleOrange]];
    [self.logInView.usernameField setBackgroundColor:[UIColor whiteColor]];
    [self.logInView.passwordField setBackgroundColor:[UIColor whiteColor]];
    self.logInView.usernameField.layer.cornerRadius = 5;
    self.logInView.passwordField.layer.cornerRadius = 5;
    self.logInView.usernameField.placeholder = @"Email";
    
    //Create Account
    [self.logInView.signUpButton setTitle:@"Create Account" forState:UIControlStateNormal];
    [self.logInView.signUpButton setTitle:@"Create Account" forState:UIControlStateHighlighted];
    [self.logInView.signUpButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.logInView.signUpButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    [self.logInView.signUpButton setTitleColor:[UIColor huddleOrange] forState:UIControlStateNormal];
    [self.logInView.signUpButton setTitleColor:[UIColor huddleOrangeAlpha] forState:UIControlStateHighlighted];
    [self.logInView.signUpButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [self.logInView.signUpButton setTitleShadowColor:nil forState:UIControlStateNormal];
    self.logInView.signUpButton.titleLabel.shadowColor = [UIColor clearColor];
    self.logInView.signUpButton.titleLabel.shadowOffset = CGSizeMake(0.0, 0.0);
    self.logInView.signUpButton.backgroundColor = [UIColor whiteColor];
    self.logInView.signUpButton.layer.cornerRadius = 5;
    [self.logInView.signUpLabel setHidden:TRUE];
    
    //Forgot Password
    [self.logInView.passwordForgottenButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.logInView.passwordForgottenButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    [self.logInView.passwordForgottenButton setTitle:@"Forgot Password" forState:UIControlStateNormal];
    [self.logInView.passwordForgottenButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    self.logInView.passwordForgottenButton.backgroundColor = [UIColor clearColor];
    [self.logInView.passwordForgottenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //Login Button
    [self.logInView.logInButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.logInView.logInButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    [self.logInView.logInButton setTitleColor:[UIColor huddleOrange] forState:UIControlStateNormal];
    [self.logInView.logInButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    self.logInView.logInButton.backgroundColor = [UIColor whiteColor];
    self.logInView.logInButton.layer.cornerRadius = 5;
    [self.logInView.logInButton setHidden:FALSE];
    
    
    // Guest Button
    UIButton *guest = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [guest addTarget:self
              action:@selector(guestLogin:)
    forControlEvents:UIControlEventTouchUpInside];
    [guest setTitleColor:[UIColor huddleOrange] forState:UIControlStateNormal];
    [guest.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [guest setTitle:@"Continue as Guest" forState:UIControlStateNormal];
    guest.backgroundColor = [UIColor whiteColor];
    guest.layer.cornerRadius = 5;
    guest.frame = CGRectMake(163.0, 380.0, 125.0, 30.0);
    
    //view tutorial button
    UIButton *tutorialButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [tutorialButton addTarget:self
              action:@selector(doTutorial)
    forControlEvents:UIControlEventTouchUpInside];
    [tutorialButton setTitleColor:[UIColor huddleOrange] forState:UIControlStateNormal];
    [tutorialButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [tutorialButton setTitle:@"View tutorial" forState:UIControlStateNormal];
    tutorialButton.backgroundColor = [UIColor whiteColor];
    tutorialButton.layer.cornerRadius = 5;
    tutorialButton.frame = CGRectMake(163.0-125.0/2, 380.0 + guest.frame.size.height + tutorialVerticalOffsetFromButtons, 125.0, 30.0);


    [self.logInView addSubview:guest];
    [self.logInView addSubview:tutorialButton];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    //Logo
    [self.logInView.logo setFrame:CGRectMake(32.0f, 115.0f, 251.0f, 60.0f)];
    
    //Fields
    [self.logInView.usernameField setFrame:CGRectMake(35.0f, 195.0f, 250.0f, 40.0f)];
    [self.logInView.passwordField setFrame:CGRectMake(35.0f, 240.0f, 250.0f, 40.0f)];

    //Login
    self.logInView.logInButton.frame = CGRectMake(35.0, 285.0, 250.0, 25.0);
    [self.logInView.logInButton setTitleColor:[UIColor huddleOrange] forState:UIControlStateNormal];
    [self.logInView.logInButton setTitleColor:[UIColor huddleOrangeAlpha] forState:UIControlStateHighlighted];
    [self.logInView.logInButton setTitleShadowColor:nil forState:UIControlStateNormal];
    [self.logInView.logInButton setTitle:@"LOGIN" forState:UIControlStateNormal];
    self.logInView.logInButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    
    //Forgot Password
    self.logInView.passwordForgottenButton.frame = CGRectMake(97.5, 315.0, 125.0, 30.0);
    
    //Create Account
    [self.logInView.signUpButton setFrame:CGRectMake(35.0, 380.0, 125.0, 30.0)];
}

- (void)guestLogin:(UIButton*)button
{
    NSLog(@"Button  clicked.");
}


-(void)doTutorial
{
    
  [(SHAppDelegate*)[[UIApplication sharedApplication] delegate] doTutorial];
}


@end
