//
//  SHHuddleInviteViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/10/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHHuddleInviteViewController.h"
#import "UIColor+HuddleColors.h"
#import "SHHuddleButtons.h"
#import "SHUtility.h"

@interface SHHuddleInviteViewController () <UITextViewDelegate>

@property (strong, nonatomic) PFObject *request;
@property (strong, nonatomic) PFObject *student;

//Headers
@property (strong, nonatomic) UILabel *messageHeaderLabel;
@property (strong, nonatomic) UILabel *huddleHeaderLabel;

//Content
@property (strong, nonatomic) SHHuddleButtons *huddleButtons;
@property (strong, nonatomic) UITextView *messageTextView;

@end

@implementation SHHuddleInviteViewController

#define messageHeaderY firstHeader
#define huddleHeaderY messageY+textFieldHeight

#define messageY messageHeaderY+headerHeight
#define huddleY huddleHeaderY+headerHeight

- (id)initWithToStudent:(PFObject *)aToStudent fromStudent:(PFObject *)aFromStudent
{
    self = [super init];
    if (self) {
        self.modalFrameHeight = 140.0;
        [self.view setFrame:CGRectMake(0.0, 0.0, modalWidth, self.modalFrameHeight)];
        
        self.request = [PFObject objectWithClassName:SHRequestParseClass];
        self.request[SHRequestStudent1Key] = aToStudent;
        self.request[SHRequestTypeKey] = SHRequestHSJoin;
        self.student = aFromStudent;
        
        [self initHeaders];
        [self initContent];
        
        
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
    self.headerLabel.text = @"Invite to Huddle";
    [self.continueButton setTitle:@"Invite" forState:UIControlStateNormal];
    
    
    //Subjet Header
    self.messageHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, messageHeaderY, headerWidth, headerHeight)];
    [self.messageHeaderLabel setFont:self.headerFont];
    [self.messageHeaderLabel setTextColor:[UIColor huddleSilver]];
    self.messageHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.messageHeaderLabel.text = @"Add Message";
    [self.view addSubview:self.messageHeaderLabel];
    
    //Time Header
    self.huddleHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, huddleHeaderY, headerWidth, headerHeight)];
    [self.huddleHeaderLabel setFont:self.headerFont];
    [self.huddleHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.huddleHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.huddleHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.huddleHeaderLabel.text = @"Select Huddle";
    [self.view addSubview:self.huddleHeaderLabel];
}

- (void)initContent
{
    CGRect initialFrame = CGRectMake(horiViewSpacing, huddleY, huddleButtonWidth, huddleButtonHeight);
    self.huddleButtons = [[SHHuddleButtons alloc] initWithFrame:initialFrame items:[SHUtility namesForObjects:self.student[SHStudentHuddlesKey] withKey:SHHuddleNameKey] addButton:nil];
    self.huddleButtons.viewController = self;
    self.huddleButtons.delegate = self;
    
    
}


@end
