//
//  SHThreadCategoryViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/11/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHNewQuestionViewController.h"
#import "UIColor+HuddleColors.h"
#import "Student.h"
#import "SHHuddleButtons.h"
#import "SHUtility.h"

@interface SHNewQuestionViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) PFObject *huddle;
@property (strong, nonatomic) PFObject *chatCategory;
@property (strong, nonatomic) PFObject *thread;
@property (strong, nonatomic) PFObject *question;

//Headers
@property (strong, nonatomic) UILabel *categoryHeaderLabel;
@property (strong, nonatomic) UILabel *subjectHeaderLabel;
@property (strong, nonatomic) UILabel *messageHeaderLabel;

// Content
@property (strong, nonatomic) UITextField *subjectTextField;
@property (strong, nonatomic) UITextView *messageTextView;
@property (strong, nonatomic) SHHuddleButtons *chatCategoryButtons;

@end

@implementation SHNewQuestionViewController


#define subjectHeaderY firstHeader
#define messageHeaderY subjectY+textFieldHeight
#define categoryHeaderY messageY+100.0

#define subjectY subjectHeaderY+headerHeight
#define messageY messageHeaderY+headerHeight
#define categoryY categoryHeaderY+headerHeight


- (id)initWithHuddle:(PFObject *)aHuddle
{
    self = [super init];
    if (self) {
        self.modalFrameHeight = 290.0;
        [self.view setFrame:CGRectMake(0.0, 0.0, modalWidth, self.modalFrameHeight)];
        
        _huddle = aHuddle;
        self.chatCategory = [PFObject objectWithClassName:SHChatCategoryParseClass];
        self.thread = [PFObject objectWithClassName:SHThreadParseClass];
        self.question = [PFObject objectWithClassName:SHQuestionParseClass];
        
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
    self.headerLabel.text = @"Create Chat Category";
    [self.continueButton setTitle:@"Create" forState:UIControlStateNormal];
    
    
    //Subjet Header
    self.categoryHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, categoryHeaderY, headerWidth, headerHeight)];
    [self.categoryHeaderLabel setFont:self.headerFont];
    [self.categoryHeaderLabel setTextColor:[UIColor huddleSilver]];
    self.categoryHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.categoryHeaderLabel.text = @"Category";
    [self.view addSubview:self.categoryHeaderLabel];
    
    //Time Header
    self.subjectHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, subjectHeaderY, headerWidth, headerHeight)];
    [self.subjectHeaderLabel setFont:self.headerFont];
    [self.subjectHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.subjectHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.subjectHeaderLabel.text = @"Thread Subject";
    [self.view addSubview:self.subjectHeaderLabel];
    
    //Description Header
    self.messageHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, messageHeaderY, headerWidth, headerHeight)];
    [self.messageHeaderLabel setFont:self.headerFont];
    [self.messageHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.messageHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.messageHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.messageHeaderLabel.text = @"Question";
    [self.view addSubview:self.messageHeaderLabel];
    
    
}

- (void)initContent
{
    
    CGRect initial = CGRectMake(horiViewSpacing, categoryY, huddleButtonWidth, huddleButtonHeight);
    self.chatCategoryButtons = [[SHHuddleButtons alloc]initWithFrame:initial items:[SHUtility namesForObjects:self.huddle[SHChatCategoryNameKey] withKey:SHChatCategoryNameKey] addButton:@"Add Category"];
    self.chatCategoryButtons.viewController = self;
    
    self.subjectTextField = [[UITextField alloc] initWithFrame:CGRectMake(horiViewSpacing, subjectY, modalContentWidth, textFieldHeight)];
    self.subjectTextField.tag = 1;
    self.subjectTextField.delegate = self;
    self.subjectTextField.backgroundColor = [UIColor whiteColor];
    [self.subjectTextField setTextColor:[UIColor huddleSilver]];
    self.subjectTextField.layer.cornerRadius = 3.0;
    UIView *SpacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [self.subjectTextField setLeftViewMode:UITextFieldViewModeAlways];
    [self.subjectTextField setLeftView:SpacerView];
    [self.view addSubview:self.subjectTextField];
    
    //Message Text View
    self.messageTextView = [[UITextView alloc]initWithFrame:CGRectMake(horiViewSpacing, messageY, modalContentWidth, 100.0)];
    self.messageTextView.layer.cornerRadius = 2;
    self.messageTextView.textColor = [UIColor huddleSilver];
    self.messageTextView.delegate = self;
    [self.view addSubview:self.messageTextView];
}

#pragma mark - Super Class

- (void)continueAction
{
    
    if (!self.chatCategoryButtons.selectedButton) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Missing Info"
                                                        message: @"Must enter a new category"
                                                        delegate: nil cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [alert show];
        return;
    } else if(!self.subjectTextField.text || self.subjectTextField.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Missing Info"
                                                        message: @"Must enter a thread subject"
                                                       delegate: nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if(!self.messageTextView.text || self.messageTextView.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Missing Info"
                                                        message: @"Must enter a thread question"
                                                       delegate: nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    
    [self.huddle addObject:self.chatCategory forKey:SHHuddleChatCategoriesKey];
    
    //self.chatCategory[SHChatCategoryNameKey] = self.categoryTextField.text;
    self.chatCategory[SHChatCategoryThreadsKey] = @[self.thread];
    
    self.thread[SHThreadTitle] = self.subjectTextField.text;
    self.thread[SHThreadQuestions] = @[self.question];
    self.thread[SHThreadCreator] = [Student currentUser];
    
    self.question[SHQuestionCreator] = [Student currentUser];
    self.question[SHQuestionQuestion] = self.messageTextView.text;
    
    [self.huddle saveInBackground];
    [self.chatCategory saveInBackground];
    [self.thread saveInBackground];
    [self.question saveInBackground];
    
    [self cancelAction];
    
}



#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 0) {
        [self.subjectTextField becomeFirstResponder];
    } else
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
    [self moveUp:YES height:40.0];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self moveUp:NO height:40.0];
}


@end
