//
//  SHThreadCategoryViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/11/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHNewQuestionViewController.h"
#import "UIColor+HuddleColors.h"
#import "SHHuddleButtons.h"
#import "SHUtility.h"

@interface SHNewQuestionViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) PFObject *huddle;
@property (strong, nonatomic) PFObject *chatCategory;
@property (strong, nonatomic) PFObject *chatRoom;
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
        self.chatRoom = [PFObject objectWithClassName:SHChatRoomClassKey];
        self.question = [PFObject objectWithClassName:SHChatClassKey];
        
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
    self.categoryHeaderLabel.text = @"Chat Category";
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
    self.chatCategoryButtons = [[SHHuddleButtons alloc]initWithFrame:initial items:[SHUtility namesForObjects:self.huddle[SHChatCategoryNameKey] withKey:SHChatCategoryNameKey] addButton:@"Add Chat Category"];
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
                                                        message: @"Must enter a chat room subject"
                                                       delegate: nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if(!self.messageTextView.text || self.messageTextView.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Missing Info"
                                                        message: @"Must enter a chat room question"
                                                       delegate: nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    

    PFUser* currentUser = [PFUser currentUser];
    self.chatRoom[SHChatRoomRoomKey] = self.subjectTextField.text;
    self.chatRoom[SHChatRoomCreatorIDKey] = currentUser.objectId;
    [self.chatRoom save];

    self.question[SHChatTextKey] = self.messageTextView.text;
    self.question[SHChatUserKey] = currentUser;
    self.question[SHChatRoomKey] = [self.chatRoom objectId];
    [self.question save];
    
    //create a channel to inform the user when his question has been answered
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation addUniqueObject:[self.chatRoom objectId] forKey:@"channels"];
    [currentInstallation saveInBackground];

    if(self.chatCategoryButtons.addButtonSet){
        
        PFObject *newChatCategory = [PFObject objectWithClassName:SHResourceCategoryParseClass];
        [newChatCategory save]; //so it has an object id
        newChatCategory[SHChatCategoryNameKey] = self.chatCategoryButtons.selectedButton;
        //newChatCategory[SHChatCategoryChatRoomKey] = @[self.chatRoom];
        newChatCategory[SHChatCategoryHuddleKey] = self.huddle;
        self.chatRoom[SHChatRoomChatCategoryOwnerKey] = [newChatCategory objectId];
 
        
        
        [self.huddle addObject:newChatCategory forKey:SHHuddleChatCategoriesKey];
        
        [PFObject saveAll:@[self.huddle,newChatCategory, self.chatRoom]];
    }
    else{
        PFQuery *chatCategoryQuery = [PFQuery queryWithClassName:SHChatCategoryParseClass];
        [chatCategoryQuery whereKey:SHChatCategoryNameKey equalTo:self.chatCategoryButtons.selectedButton];
        [chatCategoryQuery whereKey:SHChatCategoryHuddleKey equalTo:self.huddle];
        self.chatCategory = [chatCategoryQuery findObjects][0];
        //[self.chatCategory addObject:self.chatRoom forKey:SHChatCategoryChatRoomKey];
        self.chatRoom[SHChatRoomChatCategoryOwnerKey] = [self.chatCategory objectId];
        //self.chatRoom[SHThreadChatCategoryKey] = self.chatCategory;
        
        [PFObject saveAll:@[self.chatCategory,self.chatRoom]];
        
    }
    
    
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

