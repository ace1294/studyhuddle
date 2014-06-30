//
//  SHResourceViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/29/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHResourceViewController.h"

@interface SHResourceViewController ()

@property (strong, nonatomic) PFObject *resource;

@property (strong, nonatomic) UILabel *headerHuddleLabel;
@property (strong, nonatomic) UILabel *headerTitleLabel;
@property (strong, nonatomic) UILabel *memberLabel;
@property (strong, nonatomic) UILabel *categoryLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;
//@property (strong, nonatomic) UILabel 
//@property (strong, nonatomic) UILabel
//@property (strong, nonatomic) UILabel

@end

@implementation SHResourceViewController

- (id)initWithResource:(PFObject *)aResource
{
    self = [super init];
    if (self) {
        _resource = aResource;
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



@end
