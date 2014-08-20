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
#import "SHCache.h"

@interface SHHuddleInviteViewController () <UITextViewDelegate>

@property (strong, nonatomic) PFObject *student;
@property (strong, nonatomic) PFObject *toStudent;

//Headers
@property (strong, nonatomic) UILabel *messageHeaderLabel;
@property (strong, nonatomic) UILabel *huddleHeaderLabel;

//Content
@property (strong, nonatomic) SHHuddleButtons *huddleButtons;
@property (strong, nonatomic) UITextView *messageTextView;

@end

@implementation SHHuddleInviteViewController

#define messageHeaderY firstHeader
#define huddleHeaderY messageY+100.0

#define messageY messageHeaderY+headerHeight
#define huddleY huddleHeaderY+headerHeight

- (id)initWithToStudent:(PFObject *)aToStudent fromStudent:(PFObject *)aFromStudent
{
    self = [super init];
    if (self) {
        self.modalFrameHeight = 140.0;
        [self.view setFrame:CGRectMake(0.0, 0.0, modalWidth, self.modalFrameHeight)];
        
        self.student = aFromStudent;
        self.toStudent = aToStudent;
        
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
    //Description Text View
    self.messageTextView = [[UITextView alloc]initWithFrame:CGRectMake(horiViewSpacing, messageY, modalContentWidth, 100.0)];
    self.messageTextView.layer.cornerRadius = 2;
    self.messageTextView.textColor = [UIColor huddleSilver];
    self.messageTextView.delegate = self;
    [self.view addSubview:self.messageTextView];

    CGRect initialFrame = CGRectMake(horiViewSpacing, huddleY, huddleButtonWidth, huddleButtonHeight);
    NSArray *huddleNames = [SHUtility namesForObjects:[[SHCache sharedCache] huddles] withKey:SHHuddleNameKey];
    NSMutableDictionary *huddleObjects = [[NSMutableDictionary alloc] initWithObjects:[[SHCache sharedCache] huddles] forKeys:huddleNames];
    self.huddleButtons = [[SHHuddleButtons alloc] initWithFrame:initialFrame items:huddleObjects addButton:nil];
    self.huddleButtons.viewController = self;
    self.huddleButtons.delegate = self;
    
    
}

#pragma mark - Super Class Methods

- (void)continueAction
{
    if (!self.huddleButtons.selectedButtonObject) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Missing Info"
                                                        message: @"Must select a huddle."
                                                       delegate: nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    PFObject *selectedHuddle = self.huddleButtons.selectedButtonObject;

    PFObject *request = [PFObject objectWithClassName:SHRequestParseClass];
    request[SHRequestTitleKey] = selectedHuddle[SHHuddleNameKey];
    request[SHRequestHuddleKey] = selectedHuddle;
    request[SHRequestMessageKey] = self.messageTextView.text;
    request[SHRequestTypeKey] = SHRequestHSJoin;
    request[SHRequestStudent1Key] = self.toStudent;
    request[SHRequestDescriptionKey] = @"We want you to join our huddle";
    
    
    [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSString* channel = [NSString stringWithFormat:@"a%@",[self.toStudent objectId]];
        NSString* message = [NSString stringWithFormat:@"%@ wants you to become a member!!!",selectedHuddle[SHHuddleNameKey]];
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              message, @"alert",
                              @"Increment", @"badge",
                              request,@"request",
                              nil];
        
        PFPush *push = [[PFPush alloc] init];
        [push setChannels:[NSArray arrayWithObjects:channel, nil]];
        [push setData:data];
        [push sendPushInBackground];
        
    }];

    
    //Set button as Invite Sent
    
    [self cancelAction];
}


#pragma mark - Text View Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqual:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


@end
