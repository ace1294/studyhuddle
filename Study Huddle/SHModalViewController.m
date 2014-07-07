//
//  SHModalViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/6/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHModalViewController.h"
#import "UIColor+HuddleColors.h"
#import "SHUtility.h"

@interface SHModalViewController ()




@end

@implementation SHModalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.clipsToBounds = YES;
        [self.view setBackgroundColor:[UIColor colorWithWhite:.9 alpha:1]];
        self.view.layer.cornerRadius = 3;
        
        [self initHeader];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init

- (void)initHeader
{
    //Header
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, modalWidth, headerHeight)];
    [self.headerLabel setFont:[UIFont fontWithName:@"Arial-BoldMT"size:14]];
    [self.headerLabel setTextColor:[UIColor whiteColor]];
    [self.headerLabel setBackgroundColor:[UIColor huddleOrange]];
    [self.headerLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.headerLabel.textAlignment = NSTextAlignmentCenter;
    [SHUtility setMaskTo:self.headerLabel byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight];
    self.headerLabel.text = @"New Header";
    [self.view addSubview:self.headerLabel];
    
}

- (void)initButtons
{
    //Create
    self.continueButton = [[UIButton alloc]initWithFrame:CGRectMake(225.0, vertElemSpacing/2, 40.0, headerHeight-vertElemSpacing)];
    [self.continueButton setTitle:@"Continue" forState:UIControlStateNormal];
    [self.continueButton setBackgroundColor:[UIColor whiteColor]];
    self.continueButton.layer.cornerRadius = 3;
    [self.continueButton.titleLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    [self.continueButton setTitleColor:[UIColor huddleBlue] forState:UIControlStateNormal];
    [self.continueButton addTarget:self action:@selector(continueAction) forControlEvents:UIControlEventTouchUpInside];
    //Border
//    [[self.continueButton  layer] setBorderWidth:1.0f];
//    [[self.continueButton  layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [self.view addSubview:self.continueButton];
    
    //Create
    self.cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(horiElemSpacing, vertElemSpacing/2, 45.0, headerHeight-vertElemSpacing)];
    [self.cancelButton setBackgroundColor:[UIColor whiteColor]];
    self.cancelButton.layer.cornerRadius = 3;
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelButton.titleLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    [self.cancelButton setTitleColor:[UIColor huddleBlue] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
    
}

- (void)continueAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapContinue)])
    {
        [self.delegate didTapContinue];
    }
}

- (void)cancelAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapCancel)])
    {
        [self.delegate didTapCancel];
    }
}
@end
