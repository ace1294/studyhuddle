//
//  SHNewResourceViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/29/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHNewResourceViewController.h"
#import "UIColor+HuddleColors.h"
#import "SHConstants.h"
#import "SHPortraitView.h"

@interface SHNewResourceViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UILabel *createResourceLabel;

@property (strong, nonatomic) UITextField *resourceTitleField;
@property (strong, nonatomic) UIButton *addPictureButton;
@property (strong, nonatomic) SHPortraitView *resourcePortrait;
@property (strong, nonatomic) UITextView *descriptionTextView;
@property (strong, nonatomic) UITableView *categoryTable;


@property BOOL pictureSet;

@end

@implementation SHNewResourceViewController

- (id)init
{
    self = [super init];
    if (self) {
        
        self.view.clipsToBounds = YES;
        [self.view setBackgroundColor:[UIColor whiteColor]];
        self.view.layer.cornerRadius = 5;
        [self.view setFrame:CGRectMake(0.0, 0.0, 280.0, 350.0)];
        
        self.createResourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, vertBorderSpacing, newResourceWidth, sectionHeaderHeight)];
        [self.createResourceLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
        [self.createResourceLabel setTextColor:[UIColor huddleSilver]];
        [self.createResourceLabel setNumberOfLines:0];
        [self.createResourceLabel sizeToFit];
        [self.createResourceLabel setLineBreakMode:NSLineBreakByWordWrapping];
        self.createResourceLabel.textAlignment = NSTextAlignmentCenter;
        self.createResourceLabel.text = @"CREATE RESOURCE";
        [self.view addSubview:self.createResourceLabel];
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0.0, sectionHeaderHeight, 320, 1)];
        separator.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
        [self.view addSubview:separator];
        
        self.resourceTitleField = [[UITextField alloc] initWithFrame:CGRectMake(0.0, vertBorderSpacing+sectionHeaderHeight, newResourceWidth, sectionHeight)];
        [self.resourceTitleField setPlaceholder:@"Resource Name"];
        self.resourceTitleField.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0,0);    //inse
        [self.view addSubview:self.resourceTitleField];
        
        self.addPictureButton = [[UIButton alloc]initWithFrame:CGRectMake(addPictureButtonX, vertBorderSpacing+sectionHeaderHeight+sectionHeight, addPictureButtonDimX, sectionHeight)];
        [self.addPictureButton setTitle:@"Add Picture" forState:UIControlStateNormal];
        [self.addPictureButton addTarget:self action:@selector(choosePicture:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.addPictureButton];
        
        //Avatar
        self.resourcePortrait = [[SHPortraitView alloc] initWithFrame:CGRectMake(addPictureButtonX+addPictureButtonDimX+horiElemSpacing, vertBorderSpacing+sectionHeaderHeight+sectionHeight, cellPortraitDim, cellPortraitDim)];
        [self.resourcePortrait setBackgroundColor:[UIColor clearColor]];
        [self.resourcePortrait setOpaque:YES];
        [self.resourcePortrait.profileButton addTarget:self action:@selector(choosePicture:) forControlEvents:UIControlEventTouchDragInside];
        [self.view addSubview:self.resourcePortrait];
        
        self.descriptionTextView = [[UITextView alloc]initWithFrame:CGRectMake(0.0, vertBorderSpacing+sectionHeaderHeight+2*sectionHeight, newResourceWidth, descriptionHeight)];
        [self.descriptionTextView setText:@"Add Description"];
        [self.view addSubview:self.descriptionTextView];

        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.createResourceLabel setFrame:CGRectMake(0.0, vertBorderSpacing, newResourceWidth, 30.0)];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self.view setFrame:CGRectMake(200.0, 0.0, 280.0, 300.0)];
}

- (void)choosePicture:(id)sender
{
    
}

@end
