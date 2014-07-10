//
//  SHEditStudyViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/9/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHEditStudyViewController.h"
#import "UIColor+HuddleColors.h"

#import "SHUtility.h"

@interface SHEditStudyViewController () <UITextViewDelegate>

@property (strong, nonatomic) PFObject *study;

//Headers
@property (strong, nonatomic) UILabel *subjectHeaderLabel;
@property (strong, nonatomic) UILabel *descriptionHeaderLabel;


@end

@implementation SHEditStudyViewController

#define subjectHeaderY firstHeader
#define descriptionHeaderY huddleButtonHeight*2+vertElemSpacing+subjectHeaderY+headerHeight

- (id)initWithStudy:(PFObject *)aStudy
{
    self = [super init];
    if (self) {
        _study = aStudy;
        
        self.modalFrameHeight = 100.0;
        [self.view setFrame:CGRectMake(0.0, 0.0, modalWidth, self.modalFrameHeight)];
        
        [self initHeaders];
        [self initContent];
        [self setFrames];

        
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
    self.headerLabel.text = @"Study Session";
    [self.continueButton setTitle:@"Save" forState:UIControlStateNormal];
    
    //Subjet Header
    self.subjectHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing+horiElemSpacing, subjectHeaderY, headerWidth, headerHeight)];
    [self.subjectHeaderLabel setFont:self.headerFont];
    [self.subjectHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.subjectHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.subjectHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.subjectHeaderLabel.text = @"Subject";
    [self.view addSubview:self.subjectHeaderLabel];
    
    //Description Header
    self.descriptionHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing +horiElemSpacing, descriptionHeaderY, headerWidth, headerHeight)];
    [self.descriptionHeaderLabel setFont:self.headerFont];
    [self.descriptionHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.descriptionHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.descriptionHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.descriptionHeaderLabel.text = @"Description";
    [self.view addSubview:self.descriptionHeaderLabel];
    
    
}

- (void)initContent
{
    PFObject *student = self.study[SHStudyStudentKey];
    [student fetchIfNeeded];
    
    CGRect initialButton = CGRectMake(vertViewSpacing, subjectHeaderY+headerHeight, huddleButtonWidth, huddleButtonHeight);
    self.subjectButtons = [[SHHuddleButtons alloc]initWithFrame:initialButton items:[SHUtility namesForObjects:student[SHStudentClassesKey] withKey:SHClassShortNameKey] addButton:nil];
    self.subjectButtons.delegate = self;
    [self.subjectButtons setViewController:self];
    self.subjectButtons.multipleSelection = YES;
    
    //Description Text View
    self.descriptionTextView = [[UITextView alloc]init];
    self.descriptionTextView.layer.cornerRadius = 2;
    self.descriptionTextView.delegate = self;
    [self.view addSubview:self.descriptionTextView];
    
    
}

- (void)setFrames
{
    [self.descriptionHeaderLabel setFrame:CGRectMake(horiViewSpacing, self.modalFrameHeight-10, headerWidth, headerHeight)];
    [self.descriptionTextView setFrame:CGRectMake(horiViewSpacing, self.modalFrameHeight-10+headerHeight, modalContentWidth, 100.0)];
    
    self.modalFrameHeight += headerHeight+100.0;
    
    [self.view setFrame:CGRectMake(0.0, 0.0, modalWidth, self.modalFrameHeight)];
    
}

- (void)continueAction
{
    self.study[SHStudyDescriptionKey] = self.descriptionTextView.text;
    
    [self.study[SHStudyClassesKey] removeAllObjects];
    PFQuery *classes = [PFQuery queryWithClassName:SHClassParseClass];
    [classes whereKey:SHClassShortNameKey containedIn:self.subjectButtons.selectedButtons];
    self.study[SHStudyClassesKey] = [classes findObjects];
    
    [self.study saveInBackground];
    
    [self cancelAction];
    
    
}


@end
