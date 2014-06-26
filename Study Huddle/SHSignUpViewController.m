//
//  SHSignUpViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/8/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHSignUpViewController.h"
#import "UIColor+HuddleColors.h"

@interface SHSignUpViewController ()



@end

@implementation SHSignUpViewController


-(void)loadView
{
    [super loadView];
    
    //Backgrounds
    [self.signUpView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainBG.png"]]];
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]]];
    
    //Custom Major Text Field
    self.majorTextField = [[UITextField alloc]init];
    
    //Exit
    [self.signUpView.dismissButton setImage:[UIImage imageNamed:@"X_cancelbtn@2x.png"] forState:UIControlStateNormal];
    [self.signUpView.dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.signUpView.dismissButton.layer.cornerRadius = 3;
    
    //Fields
    [self.signUpView.usernameField setTextColor:[UIColor huddleOrange]];
    [self.signUpView.emailField setTextColor:[UIColor huddleOrange]];
    [self.signUpView.passwordField setTextColor:[UIColor huddleOrange]];
    [self.signUpView.additionalField setTextColor:[UIColor huddleOrange]];
    [self.majorTextField setTextColor:[UIColor huddleOrange]];
    
    [self.signUpView.usernameField setBackgroundColor:[UIColor whiteColor]];
    [self.signUpView.emailField setBackgroundColor:[UIColor whiteColor]];
    [self.signUpView.additionalField setBackgroundColor:[UIColor whiteColor]];
    [self.signUpView.passwordField setBackgroundColor:[UIColor whiteColor]];
    
    self.signUpView.usernameField.layer.cornerRadius = 5;
    self.signUpView.emailField.layer.cornerRadius = 5;
    self.signUpView.passwordField.layer.cornerRadius = 5;
    self.signUpView.additionalField.layer.cornerRadius = 5;
    self.majorTextField.layer.cornerRadius = 5;
    
    
    self.signUpView.usernameField.placeholder = @"Full Name";
    self.signUpView.additionalField.placeholder = @"Reenter Password";
    self.signUpView.emailField.placeholder = @"Email";
    self.majorTextField.placeholder = @"Major";
    
    //Create
    [self.signUpView.signUpButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.signUpView.signUpButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    [self.signUpView.signUpButton setTitle:@"Create Account" forState:UIControlStateNormal];
    [self.signUpView.signUpButton setBackgroundColor:[UIColor whiteColor]];
    [self.signUpView.signUpButton setTitleColor:[UIColor huddleOrange] forState:UIControlStateNormal];
    [self.signUpView.signUpButton setTitleColor:[UIColor huddleOrangeAlpha] forState:UIControlStateHighlighted];
    self.signUpView.signUpButton.layer.cornerRadius = 5;
    
    
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    //Logo
    [self.signUpView.logo setFrame:CGRectMake(32.0f, 115.0f, 251.0f, 60.0f)];
    
    //Fields
    [self.signUpView.usernameField setFrame:CGRectMake(35.0f, 180.0f, 250.0f, 40.0f)];
    [self.signUpView.emailField setFrame:CGRectMake(35.0f, 225.0f, 250.0f, 40.0f)];
    [self.signUpView.passwordField setFrame:CGRectMake(35.0f, 270.0f, 250.0f, 40.0f)];
    [self.signUpView.additionalField setFrame:CGRectMake(35.0f, 315.0f, 250.0f, 40.0f)];
    [self.majorTextField setFrame:CGRectMake(35.0f, 360.0f, 250.0f, 40.0f)];
    
    //Exit
    [self.signUpView.dismissButton setFrame:CGRectMake(15.0f, 28.0f, 26.0f, 26.0f)];
    
    //Create
    [self.signUpView.signUpButton setFrame:CGRectMake(35.0f, 470.0f, 250.0f, 40.0f)];
    [self.signUpView.signUpButton setTitleShadowColor:nil forState:UIControlStateNormal];
    
    //Custom Major Text Field
    self.majorTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.majorTextField.font = [UIFont systemFontOfSize:17.0];
    [self.majorTextField setTextAlignment:NSTextAlignmentCenter];
    
    
    
    [self.view addSubview:self.majorTextField];
    
    
  
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
