//
//  SHHuddleJoinRequestViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/15/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHHuddleJoinRequestViewController.h"
#import "UIColor+HuddleColors.h"
#import "Student.h"

@interface SHHuddleJoinRequestViewController () <UITextViewDelegate>

@property (strong, nonatomic) PFObject *huddle;

//Headers
@property (strong, nonatomic) UILabel *messageHeaderLabel;

//Fields
@property (strong, nonatomic) UITextView *messageTextView;

@end

@implementation SHHuddleJoinRequestViewController


#define descriptionHeaderY firstHeader

#define descriptionY descriptionHeaderY+headerHeight

- (id)initWithHuddle:(PFObject *)aHuddle
{
    self = [super init];
    if(self){
        
        self.modalFrameHeight = 180.0;
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
    self.headerLabel.text = @"Request to Join Huddle";
    [self.continueButton setTitle:@"Send" forState:UIControlStateNormal];
    
    //Description Header
    self.messageHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, descriptionHeaderY, headerWidth, headerHeight)];
    [self.messageHeaderLabel setFont:self.headerFont];
    [self.messageHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.messageHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.messageHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.messageHeaderLabel.text = @"Description";
    [self.view addSubview:self.messageHeaderLabel];
    
    
}

- (void)initContent
{
    //Description Text View
    self.messageTextView = [[UITextView alloc]initWithFrame:CGRectMake(horiViewSpacing, descriptionY, modalContentWidth, 100.0)];
    self.messageTextView.layer.cornerRadius = 2;
    self.messageTextView.textColor = [UIColor huddleSilver];
    self.messageTextView.delegate = self;
    [self.view addSubview:self.messageTextView];
}

#pragma mark - Super Class Methods

- (void)continueAction
{
    //set huddles page so it shows location
    
    PFObject *request = [PFObject objectWithClassName:SHRequestParseClass];
    
    request[SHRequestTypeKey] = SHRequestSHJoin;
    request[SHRequestTitleKey] = self.huddle[SHHuddleNameKey];
    request[SHRequestStudent1Key] = [Student currentUser];
    request[SHRequestStudent2Key] = self.huddle[SHHuddleCreatorKey];
    request[SHRequestHuddleKey] = self.huddle;
    
    [request saveInBackground];
    
    
    [self cancelAction];
}


#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.messageTextView becomeFirstResponder];
    
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
    [self moveUp:YES height:20.0];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self moveUp:NO height:20.0];
}



@end
