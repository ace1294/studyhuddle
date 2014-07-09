//
//  SHStudyViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/8/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHStudyViewController.h"
#import "UIColor+HuddleColors.h"

@interface SHStudyViewController ()

//Headers
@property (strong, nonatomic) UILabel *dateHeaderLabel;
@property (strong, nonatomic) UILabel *timeStudiedHeaderLabel;
@property (strong, nonatomic) UILabel *subjectHeaderLabel;
@property (strong, nonatomic) UILabel *descriptionHeaderLabel;

//Content
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *timeStudiedLabel;
@property (strong, nonatomic) UILabel *subjectLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;

@end

@implementation SHStudyViewController

- (id)initWithStudy:(PFObject *)aStudy
{
    self = [super init];
    if (self){
        _study = aStudy;
        
        [self initHeaders];
        //[self initContent];
        //[self setFrames];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Inilizing methods

- (void)initHeaders
{
    
    self.dateHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, dateHeaderY, headerWidth, headerHeight)];
    [self.dateHeaderLabel setFont:[UIFont fontWithName:@"Arial"size:16]];
    [self.dateHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.dateHeaderLabel setBackgroundColor:[UIColor whiteColor]];
    [self.dateHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.dateHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.dateHeaderLabel.text = @"Date:";
    [self.view addSubview:self.dateHeaderLabel];
    
    self.timeStudiedHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, timeStudiedHeaderY, headerWidth, headerHeight)];
    [self.timeStudiedHeaderLabel setFont:[UIFont fontWithName:@"Arial"size:16]];
    [self.timeStudiedHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.timeStudiedHeaderLabel setBackgroundColor:[UIColor whiteColor]];
    [self.timeStudiedHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.timeStudiedHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.timeStudiedHeaderLabel.text = @"Time Studied:";
    [self.view addSubview:self.timeStudiedHeaderLabel];
    
    self.subjectHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, subjectHeaderY, headerWidth, headerHeight)];
    [self.subjectHeaderLabel setFont:[UIFont fontWithName:@"Arial"size:16]];
    [self.subjectHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.subjectHeaderLabel setBackgroundColor:[UIColor whiteColor]];
    [self.subjectHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.subjectHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.subjectHeaderLabel.text = @"Subject:";
    [self.view addSubview:self.subjectHeaderLabel];
    
    
    self.descriptionHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, descriptionHeaderY, headerWidth, headerHeight)];
    [self.descriptionHeaderLabel setFont:[UIFont fontWithName:@"Arial"size:16]];
    [self.descriptionHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.descriptionHeaderLabel setBackgroundColor:[UIColor whiteColor]];
    [self.descriptionHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.descriptionHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.descriptionHeaderLabel.text = @"Description:";
    [self.view addSubview:self.descriptionHeaderLabel];
    
}

- (void)initContent
{
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, dateY, contentWidth, contentHeight)];
    [self.dateLabel setFont:[UIFont fontWithName:@"Arial"size:14]];
    [self.dateLabel setTextColor:[UIColor huddleSilver]];
    [self.dateLabel setBackgroundColor:[UIColor whiteColor]];
    [self.dateLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.dateLabel.textAlignment = NSTextAlignmentLeft;
    //self.dateLabel.text = self.study[SHStudyStartKey];
    [self.view addSubview:self.dateLabel];
    
    self.timeStudiedLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, timeStudiedY, contentWidth, 200.0)];
    [self.timeStudiedLabel setFont:[UIFont fontWithName:@"Arial"size:14]];
    [self.timeStudiedLabel setTextColor:[UIColor huddleSilver]];
    [self.timeStudiedLabel setBackgroundColor:[UIColor whiteColor]];
    [self.timeStudiedLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.timeStudiedLabel.textAlignment = NSTextAlignmentLeft;
    self.timeStudiedLabel.text = self.study[SHStudyStartKey];
    [self.view addSubview:self.timeStudiedLabel];
    
    self.subjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, timeStudiedY, contentWidth, 200.0)];
    [self.subjectLabel setFont:[UIFont fontWithName:@"Arial"size:14]];
    [self.subjectLabel setTextColor:[UIColor huddleSilver]];
    [self.subjectLabel setBackgroundColor:[UIColor whiteColor]];
    [self.subjectLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.subjectLabel.textAlignment = NSTextAlignmentLeft;
    //self.subjectLabel.text = self.study[SHStudyClassesKey];
    [self.view addSubview:self.subjectLabel];
    
    self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, descriptionY, contentWidth, 200.0)];
    [self.descriptionLabel setFont:[UIFont fontWithName:@"Arial"size:14]];
    [self.descriptionLabel setTextColor:[UIColor huddleSilver]];
    [self.descriptionLabel setBackgroundColor:[UIColor whiteColor]];
    [self.descriptionLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.descriptionLabel.textAlignment = NSTextAlignmentLeft;
    self.descriptionLabel.text = self.study[SHStudyDescriptionKey];
    [self.view addSubview:self.descriptionLabel];
    

    
}


@end
