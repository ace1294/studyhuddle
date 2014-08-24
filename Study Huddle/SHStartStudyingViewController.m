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
#import "SHCache.h"

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
        NSArray *privacyNames = @[@"Public",@"My Huddles",@"Private"];
        NSArray *privacyObjects = @[[PFObject objectWithClassName:@"Public"],[PFObject objectWithClassName:@"My Huddles"],[PFObject objectWithClassName:@"Private"]];
        self.privacyButtons = [[SHHuddleButtons alloc]initWithFrame:initialButton items:[[NSMutableDictionary alloc] initWithObjects:privacyObjects forKeys:privacyNames] addButton:nil];
        self.privacyButtons.delegate = self;
        [self.privacyButtons setViewController:self];
        
        initialButton = CGRectMake(vertViewSpacing, subjectHeaderY+headerHeight, huddleButtonWidth, huddleButtonHeight);
        
        NSArray *classNames = [SHUtility namesForObjects:[[SHCache sharedCache]classes] withKey:SHClassShortNameKey];
        NSMutableDictionary *classObjects = [[NSMutableDictionary alloc]initWithObjects:[[SHCache sharedCache]classes] forKeys:classNames];
        self.subjectButtons = [[SHHuddleButtons alloc]initWithFrame:initialButton items:classObjects addButton:nil];
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
    NSString *privacyString = [self.privacyButtons.selectedButtonObject parseClassName];
    
    self.study[SHStudyStartKey] = [NSDate date];
    
    self.study[SHStudyClassesKey] = self.subjectButtons.multipleSelectedButtonsObjects;
    self.study[SHStudyOnlineKey] = [NSNumber numberWithBool:true];
    
    [self.student addObject:self.study forKey:SHStudentStudyLogsKey];
    
    [self.study saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [[SHCache sharedCache] setNewStudyLog:self.study];
        
        [self.student saveInBackground];
    }];
    
    [self.delegate activateStudyLog:self.study];
    
    [self cancelAction];
}




@end
