//
//  SHStartStudyingViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/6/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHStartStudyingViewController.h"
#import "SHHuddleButtons.h"
#import "UIColor+HuddleColors.h"
#import "SHUtility.h"
#import "UIViewController+MJPopupViewController.h"

@interface SHStartStudyingViewController ()

@property (strong, nonatomic) PFObject *student;
@property (strong, nonatomic) PFObject *study;

@property (strong, nonatomic) SHHuddleButtons *privacyButtons;
@property (strong, nonatomic) SHHuddleButtons *subjectButtons;

@property (strong, nonatomic) UILabel *privacyHeaderLabel;
@property (strong, nonatomic) UILabel *subjectHeaderLabel;

@end

@implementation SHStartStudyingViewController

- (id)initWithStudent:(PFObject *)aStudent studyObject:(PFObject *)aStudy
{
    self = [super init];
    if (self) {
        _student = aStudent;
        _study = aStudy;
        
        self.modalFrameHeight = 200.0;
        [self.view setFrame:CGRectMake(0.0, 0.0, modalWidth, self.modalFrameHeight)];
        
        [self initHeaders];
        CGRect initialButton = CGRectMake(vertViewSpacing, privacyHeaderY+headerHeight, huddleButtonWidth, huddleButtonHeight);
        self.privacyButtons = [[SHHuddleButtons alloc]initWithFrame:initialButton items:@[@"Public",@"My Huddles",@"Private"] addButton:nil];
        self.privacyButtons.delegate = self;
        [self.privacyButtons setViewController:self];
        
        initialButton = CGRectMake(vertViewSpacing, subjectHeaderY+headerHeight, huddleButtonWidth, huddleButtonHeight);
        self.subjectButtons = [[SHHuddleButtons alloc]initWithFrame:initialButton items:[SHUtility namesForObjects:aStudent[SHStudentClassesKey] withKey:SHClassShortNameKey] addButton:nil];
        self.subjectButtons.delegate = self;
        [self.subjectButtons setViewController:self];
        self.subjectButtons.multipleSelection = YES;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initHeaders
{
    //Resource Header
    self.headerLabel.text = @"Start Studying";
    
    //Description Header
    self.privacyHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing +horiElemSpacing, privacyHeaderY, headerWidth, headerHeight)];
    [self.privacyHeaderLabel setFont:self.headerFont];
    [self.privacyHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.privacyHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.privacyHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.privacyHeaderLabel.text = @"Who can see I'm online";
    [self.view addSubview:self.privacyHeaderLabel];
    
    //Description Header
    self.subjectHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing+horiElemSpacing, subjectHeaderY, headerWidth, headerHeight)];
    [self.subjectHeaderLabel setFont:self.headerFont];
    [self.subjectHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.subjectHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.subjectHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.subjectHeaderLabel.text = @"Subject";
    [self.view addSubview:self.subjectHeaderLabel];
    
    
}

- (void)continueAction
{
    //self.study = [PFObject objectWithClassName:SHStudyParseClass];
    self.study[SHStudyStartKey] = [NSDate date];
    
    PFQuery *classes = [PFQuery queryWithClassName:SHClassParseClass];
    [classes whereKey:SHClassShortNameKey containedIn:self.subjectButtons.selectedButtons];
    self.study[SHStudyClassesKey] = [classes findObjects];
    self.study[SHStudyOnlineKey] = [NSNumber numberWithBool:true];
    self.study[SHStudyStudentKey] = self.student;
    
    
    [self.student addObject:self.study forKey:SHStudentStudyKey];
    
    [self.study saveInBackground];
    [self.student saveInBackground];
    
    [self.delegate startedStudying:self.study];
    
    [self cancelAction];
}




@end
