//
//  SHStudyInviteViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/10/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHStudyInviteViewController.h"
#import "UIColor+HuddleColors.h"
#import "SHCache.h"

@interface SHStudyInviteViewController () <UITextViewDelegate, UITextFieldDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) PFObject *request;

//Headers
@property (strong, nonatomic) UILabel *timeHeaderLabel;
@property (strong, nonatomic) UILabel *locationHeaderLabel;
@property (strong, nonatomic) UILabel *descriptionHeaderLabel;

//Fields
@property (strong, nonatomic) UIButton *setTimeButton;
@property (strong, nonatomic) UIActionSheet *timeActionSheet;
@property (strong, nonatomic) UIToolbar *toolbarPicker;
@property (strong, nonatomic) UIDatePicker *timePicker;

@property (strong, nonatomic) UITextField *locationTextField;
@property (strong, nonatomic) UITextView *descriptionTextView;

@end

@implementation SHStudyInviteViewController

#define timeHeaderY firstHeader
#define locationHeaderY timeY+textFieldHeight
#define descriptionHeaderY locationY+textFieldHeight

#define timeY timeHeaderY+headerHeight
#define locationY locationHeaderY+headerHeight
#define descriptionY descriptionHeaderY+headerHeight

- (id)initWithFromStudent:(PFObject *)fromStudent toStudent:(PFObject *)toStudent
{
    self = [super init];
    if (self) {
        self.modalFrameHeight = 290.0;
        [self.view setFrame:CGRectMake(0.0, 0.0, modalWidth, self.modalFrameHeight)];
        
        self.request = [PFObject objectWithClassName:SHRequestParseClass];
        self.request[SHRequestTitleKey] = fromStudent[SHStudentNameKey];
        self.request[SHRequestSentTitleKey] = toStudent[SHStudentNameKey];
        self.request[SHRequestTypeKey] = SHRequestSSInviteStudy;
        self.request[SHRequestFromStudentKey] = fromStudent;
        self.request[SHRequestToStudentKey] = toStudent;
        
        [self initHeaders];
        [self initContent];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.timeActionSheet = [[UIActionSheet alloc] initWithTitle:@"Date"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:nil];
    self.timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    [self.timePicker setDatePickerMode:UIDatePickerModeTime];
    
    UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerDateToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerDateToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(datePickerDoneClick:)];
    [barItems addObject:doneBtn];
    
    [pickerDateToolbar setItems:barItems animated:YES];
    [self.timeActionSheet addSubview:pickerDateToolbar];
    [self.timeActionSheet addSubview:self.timePicker];
    
}

- (void)initHeaders
{
    //Resource Header
    self.headerLabel.text = @"Study Invitation";
    [self.continueButton setTitle:@"Invite" forState:UIControlStateNormal];
    
    
    //Subjet Header
    self.timeHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, timeHeaderY, headerWidth, headerHeight)];
    [self.timeHeaderLabel setFont:self.headerFont];
    [self.timeHeaderLabel setTextColor:[UIColor huddleSilver]];
    self.timeHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.timeHeaderLabel.text = @"Time";
    [self.view addSubview:self.timeHeaderLabel];
    
    //Time Header
    self.locationHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, locationHeaderY, headerWidth, headerHeight)];
    [self.locationHeaderLabel setFont:self.headerFont];
    [self.locationHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.locationHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.locationHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.locationHeaderLabel.text = @"Location";
    [self.view addSubview:self.locationHeaderLabel];
    
    //Description Header
    self.descriptionHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, descriptionHeaderY, headerWidth, headerHeight)];
    [self.descriptionHeaderLabel setFont:self.headerFont];
    [self.descriptionHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.descriptionHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.descriptionHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.descriptionHeaderLabel.text = @"Description";
    [self.view addSubview:self.descriptionHeaderLabel];
    
    
}

- (void)initContent
{
    
    self.setTimeButton = [[UIButton alloc]initWithFrame:CGRectMake(horiViewSpacing, timeY, modalContentWidth, textFieldHeight)];
    [self.setTimeButton.titleLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    [self.setTimeButton setTitleColor:[UIColor huddleBlue] forState:UIControlStateNormal];
    [self.setTimeButton setBackgroundColor:[UIColor whiteColor]];
    [self.setTimeButton setTitle:@"Set" forState:UIControlStateNormal];
    [self.setTimeButton addTarget:self action:@selector(setTimePressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.setTimeButton];
    
    self.locationTextField = [[UITextField alloc] initWithFrame:CGRectMake(horiViewSpacing, locationY, modalContentWidth, textFieldHeight)];
    self.locationTextField.delegate = self;
    self.locationTextField.backgroundColor = [UIColor whiteColor];
    [self.locationTextField setTextColor:[UIColor huddleSilver]];
    self.locationTextField.layer.cornerRadius = 3.0;
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [self.locationTextField setLeftViewMode:UITextFieldViewModeAlways];
    [self.locationTextField setLeftView:spacerView];
    [self.view addSubview:self.locationTextField];
    
    //Description Text View
    self.descriptionTextView = [[UITextView alloc]initWithFrame:CGRectMake(horiViewSpacing, descriptionY, modalContentWidth, 100.0)];
    self.descriptionTextView.layer.cornerRadius = 2;
    self.descriptionTextView.textColor = [UIColor huddleSilver];
    self.descriptionTextView.delegate = self;
    [self.view addSubview:self.descriptionTextView];
}


#pragma mark - Super Class Methods

- (void)continueAction
{
    self.request[SHRequestTimeKey] = self.timePicker.date;
    self.request[SHRequestLocationKey] = self.locationTextField.text;
    self.request[SHRequestMessageKey] = self.descriptionTextView.text;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    NSString *timeString = [formatter stringFromDate:self.timePicker.date];
    
    self.request[SHRequestDescriptionKey] = [NSString stringWithFormat:@"Wants to study at %@; %@", timeString, self.locationTextField.text];
    self.request[SHRequestSentDescriptionKey] = [NSString stringWithFormat:@"You requested to study at %@; %@", timeString, self.locationTextField.text];
    
    [self.request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [[SHCache sharedCache] setNewSentRequest:self.request];
    }];
    
    //Set button as Invite Sent
    
    //send a pushy push as well
    PFObject* receiver = self.request[SHRequestToStudentKey];
    [receiver fetchIfNeeded];
    NSString* channel = [NSString stringWithFormat:@"a%@",[receiver objectId]];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"You have invite request!!!", @"alert",
                          @"Increment", @"badge",
                          nil];
    PFPush *push = [[PFPush alloc] init];
    [push setChannels:[NSArray arrayWithObjects:channel, nil]];
    [push setData:data];
    [push sendPushInBackground];
    
    
    
    [self cancelAction];
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.descriptionTextView becomeFirstResponder];
    
    return true;
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

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self moveUp:YES height:77.0];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self moveUp:NO height:77.0];
}

#pragma mark - Actions

- (void)setTimePressed
{
    [self.timeActionSheet showInView:self.owner.view];
    [self.timeActionSheet setBounds:CGRectMake(0,0,320, 464)];
}

-(void)datePickerDoneClick:(id)sender{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    
    NSString *dateString = [formatter stringFromDate:self.timePicker.date];
    
    [self.setTimeButton setTitle:dateString forState:UIControlStateNormal];
    [self.timeActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

@end
