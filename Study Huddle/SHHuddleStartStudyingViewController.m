//
//  SHHuddleStartStudyingViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/15/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHHuddleStartStudyingViewController.h"
#import "UIColor+HuddleColors.h"

@interface SHHuddleStartStudyingViewController () <UITextViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) PFObject *huddle;

//Headers
@property (strong, nonatomic) UILabel *locationHeaderLabel;
@property (strong, nonatomic) UILabel *descriptionHeaderLabel;

//Fields
@property (strong, nonatomic) UITextField *locationTextField;
@property (strong, nonatomic) UITextView *descriptionTextView;

@end

@implementation SHHuddleStartStudyingViewController


#define locationHeaderY firstHeader
#define descriptionHeaderY locationY+textFieldHeight

#define locationY locationHeaderY+headerHeight
#define descriptionY descriptionHeaderY+headerHeight

- (id)initWithHuddle:(PFObject *)aHuddle
{
    self = [super init];
    if(self){
        
        self.modalFrameHeight = 235.0;
        [self.view setFrame:CGRectMake(0.0, 0.0, modalWidth, self.modalFrameHeight)];
        
        _huddle = aHuddle;
        
        [self initHeaders];
        [self initContent];
        
    }
    
    return self;
}

- (void)initHeaders
{
    //Resource Header
    self.headerLabel.text = @"Study Invitation";
    [self.continueButton setTitle:@"Invite" forState:UIControlStateNormal];
    
    
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
    //set huddles page so it shows location
    
    for(PFObject *member in self.huddle[SHHuddleMembersKey]){
        
        if([[member objectId] isEqual:[[PFUser currentUser]objectId]])
            continue;
        
        PFObject *notification = [PFObject objectWithClassName:SHNotificationParseClass];
        notification[SHNotificationTypeKey] = SHNotificationHSStudyRequestType;
        notification[SHNotificationTitleKey] = self.huddle[SHHuddleNameKey];
        notification[SHNotificationToStudentKey] = member;
        notification[SHNotificationHuddleKey] = self.huddle;
        notification[SHNotificationMessageKey] = self.descriptionTextView.text;
        notification[SHNotificationLocationKey] = self.locationTextField.text;
        notification[SHNotificationDescriptionKey] = [NSString stringWithFormat:@"We are studying at %@ ", self.locationTextField.text];
        
        [notification saveInBackground];
        
    }
    
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

@end
