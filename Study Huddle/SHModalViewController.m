//
//  SHModalViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/6/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHModalViewController.h"
#import "UIColor+HuddleColors.h"
#import "UIViewController+MJPopupViewController.h"
#import "SHUtility.h"

@interface SHModalViewController ()




@end

CGRect initialFrame;

@implementation SHModalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.clipsToBounds = YES;
        [self.view setBackgroundColor:[UIColor colorWithWhite:.9 alpha:1]];
        self.view.layer.cornerRadius = 3;
        
        self.buttonFont = [UIFont fontWithName:@"Arial" size:12];
        self.headerFont = [UIFont fontWithName:@"Arial-BoldMT" size:12];
        
        [self initHeader];
        [self initButtons];
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
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, modalWidth, modalHeaderHeight)];
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
    self.continueButton = [[UIButton alloc]initWithFrame:CGRectMake(continueX, modalButtonY, modalButtonWidth, modalButtonHeight)];
    [self.continueButton setTitle:@"Start" forState:UIControlStateNormal];
    [self.continueButton setBackgroundColor:[UIColor whiteColor]];
    self.continueButton.layer.cornerRadius = 3;
    [self.continueButton.titleLabel setFont:[UIFont fontWithName:@"Arial" size:10]];
    [self.continueButton setTitleColor:[UIColor huddleOrange] forState:UIControlStateNormal];
    [self.continueButton addTarget:self action:@selector(continueAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.continueButton];
    
    //Create
    self.cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(horiElemSpacing, modalButtonY, modalButtonWidth, modalButtonHeight)];
    [self.cancelButton setBackgroundColor:[UIColor whiteColor]];
    self.cancelButton.layer.cornerRadius = 3;
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelButton.titleLabel setFont:[UIFont fontWithName:@"Arial" size:10]];
    [self.cancelButton setTitleColor:[UIColor huddleSilver] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
    
}

- (void)continueAction
{
    //
}

- (void)cancelAction
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
    
}

- (void)moveUp: (BOOL)up height:(CGFloat)height
{
    const int movementDistance = height;
    
    int movement = (up ? -movementDistance : movementDistance);
    
    if(up){
        initialFrame = self.view.frame;
        [UIView animateWithDuration:0.5f animations:^{
            self.view.frame = CGRectOffset(initialFrame, 0, movement);
        }];
    }
    else{
        [UIView animateWithDuration:0.5f animations:^{
            self.view.frame = initialFrame;
        }];
    }
    
    
}

@end
