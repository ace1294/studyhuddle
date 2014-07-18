//
//  SHHuddleAddViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/17/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHHuddleAddViewController.h"
#import "UIColor+HuddleColors.h"

@interface SHHuddleAddViewController ()

@property (strong, nonatomic) UIButton *addHuddle;

@end

@implementation SHHuddleAddViewController

- (id)init
{
    self = [super init];
    if (self) {
        
        [self.view setBackgroundColor:[UIColor huddleSilver]];
        self.view.clipsToBounds = YES;
        
        self.addHuddle = [[UIButton alloc]initWithFrame:CGRectMake(5.0, 5.0, 110.0, 30.0)];
        self.addHuddle.layer.cornerRadius = 3;
        [self.addHuddle.titleLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
        [self.addHuddle setTitleColor:[UIColor huddleOrange] forState:UIControlStateNormal];
        [self.addHuddle setBackgroundColor:[UIColor whiteColor]];
        [self.addHuddle setTitle:@"Create Huddle" forState:UIControlStateNormal];
        [self.addHuddle addTarget:self action:@selector(addHuddleAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.addHuddle];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)addHuddleAction
{
    [self.delegate addHuddleTapped];
    
}
@end
