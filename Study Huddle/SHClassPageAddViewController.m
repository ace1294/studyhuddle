//
//  SHClassPageAddViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 8/22/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHClassPageAddViewController.h"
#import "UIColor+HuddleColors.h"
#import "SHNewResourceViewController.h"

@interface SHClassPageAddViewController ()

@property (strong, nonatomic) UIButton *addMember;
@property (strong, nonatomic) UIButton *addResource;
@property (strong, nonatomic) UIButton *addThread;

@end

@implementation SHClassPageAddViewController

- (id)init
{
    self = [super init];
    if (self) {
        
        [self.view setBackgroundColor:[UIColor huddleSilver]];
        self.view.clipsToBounds = YES;
        
        self.addThread = [[UIButton alloc]initWithFrame:CGRectMake(5.0, 5.0, 110.0, 30.0)];
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

- (void)addThreadAction
{
    [self.delegate addThreadTapped];
}

@end
