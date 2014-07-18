//
//  SHHuddleAddViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/11/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHIndividualHuddleAddViewController.h"
#import "UIColor+HuddleColors.h"
#import "SHNewResourceViewController.h"

@interface SHIndividualHuddleAddViewController ()

@property (strong, nonatomic) UIButton *addMember;
@property (strong, nonatomic) UIButton *addResource;
@property (strong, nonatomic) UIButton *addThread;

@end

@implementation SHIndividualHuddleAddViewController

- (id)init
{
    self = [super init];
    if (self) {
        
        [self.view setBackgroundColor:[UIColor huddleSilver]];
        self.view.clipsToBounds = YES;
        
        self.addMember = [[UIButton alloc]initWithFrame:CGRectMake(5.0, 5.0, 110.0, 30.0)];
        self.addMember.layer.cornerRadius = 3;
        [self.addMember.titleLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
        [self.addMember setTitleColor:[UIColor huddleOrange] forState:UIControlStateNormal];
        [self.addMember setBackgroundColor:[UIColor whiteColor]];
        [self.addMember setTitle:@"Add Member" forState:UIControlStateNormal];
        [self.addMember addTarget:self action:@selector(addMemberAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.addMember];
        
        self.addResource = [[UIButton alloc]initWithFrame:CGRectMake(5.0, 40.0, 110.0, 30.0)];
        self.addResource.layer.cornerRadius = 3;
        [self.addResource.titleLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
        [self.addResource setTitleColor:[UIColor huddleOrange] forState:UIControlStateNormal];
        [self.addResource setBackgroundColor:[UIColor whiteColor]];
        [self.addResource setTitle:@"New Resource" forState:UIControlStateNormal];
        [self.addResource addTarget:self action:@selector(addResourceAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.addResource];
        
        self.addThread = [[UIButton alloc]initWithFrame:CGRectMake(5.0, 75.0, 110.0, 30.0)];
        self.addThread.layer.cornerRadius = 3;
        [self.addThread.titleLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
        [self.addThread setTitleColor:[UIColor huddleOrange] forState:UIControlStateNormal];
        [self.addThread setBackgroundColor:[UIColor whiteColor]];
        [self.addThread setTitle:@"New Question" forState:UIControlStateNormal];
        [self.addThread addTarget:self action:@selector(addThreadAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.addThread];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)addMemberAction
{
    [self.delegate addMemberTapped];
    
}

- (void)addResourceAction
{
    
    [self.delegate addResourceTapped];
}

- (void)addThreadAction
{
    [self.delegate addThreadTapped];
    
}
                                                        
                                                        
                                                        
@end
