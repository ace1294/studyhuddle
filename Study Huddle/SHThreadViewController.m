//
//  SHThreadViewController.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 7/5/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHThreadViewController.h"
#import "SHConstants.h"
#import "SHQuestionBubble.h"
#import "SHReplyBubble.h"
#import "UIColor+HuddleColors.h"
#import "SHTextBar.h"
#import "SHUtility.h"

#define questionHorizontalOffset 10
#define repliesHorizontalOffset 30
#define bubbleWidth 300
#define firstBubbleStartY 30
#define verticalOffsetBetweenBubbles 10
#define replyTextFieldHeight 60
#define animationLength 0.225f

@interface SHThreadViewController ()<UITextFieldDelegate,SHQuestionBubbleDelegate,SHReplyBubbleDelegate,UIScrollViewDelegate,HPGrowingTextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property UIScrollView* scrollView;

@property (strong,nonatomic) PFObject* threadObject;
@property (strong,nonatomic) NSMutableArray* replies;
@property (strong,nonatomic) SHQuestionBubble* questionBubble;
@property (strong,nonatomic) UITextField* replyTextField;
@property (strong,nonatomic) SHTextBar* textBar;

@property (strong,nonatomic) PFObject* relevantQuestionObject;
@property (strong,nonatomic) PFObject* relevantReplyObject;

@property int state; //editing or replying or answering
@property BOOL canUpdate; //so when pulling the bar down, it only updates the replies once

@end

@implementation SHThreadViewController



- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)deregisterFromKeyboardNotifications
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithThread:(PFObject *)aThread
{
    self = [super init];
    if(self)
    {
        [aThread fetchIfNeeded];
        _threadObject = aThread;
        self.title = aThread[SHThreadTitle];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    [self updateLayout];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self deregisterFromKeyboardNotifications];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.state = SHQuestioning;
    
    //that scroll view
    CGRect scrollViewFrame = self.view.frame;
    scrollViewFrame.size.height -= (replyTextFieldHeight);
    self.scrollView = [[UIScrollView alloc]initWithFrame:scrollViewFrame];
    [self.view addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 99999);
    self.scrollView.backgroundColor = [UIColor huddleLightSilver];
    self.scrollView.delegate = self;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userPressedOutside:)];
    [self.scrollView addGestureRecognizer:gestureRecognizer];
    
    [NSTimer scheduledTimerWithTimeInterval:30
                                     target:self
                                   selector:@selector(refreshAll)
                                   userInfo:nil
                                    repeats:YES];

    

    
    //that reply text field
   /* self.replyTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-replyTextFieldHeight, self.view.frame.size.width, replyTextFieldHeight)];
    self.replyTextField.text = @"W00h";
    self.replyTextField.backgroundColor = [UIColor whiteColor];
    self.replyTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.replyTextField.delegate = self;
    self.initialFrame = self.replyTextField.frame;
    [self.view addSubview:self.replyTextField];
    
    */
    
    
    self.textBar = [[SHTextBar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-replyTextFieldHeight, self.view.frame.size.width, replyTextFieldHeight)];
    [self.view addSubview:self.textBar];
    self.textBar.textField.delegate = self;
    [self.textBar.postButton addTarget:self action:@selector(postTextInTextView) forControlEvents:UIControlEventTouchUpInside];
    [self.textBar.imageButton addTarget:self action:@selector(takePictureCalled) forControlEvents:UIControlEventTouchUpInside];
 
    [self updateLayout];
    

}

-(void)refreshAll
{
    //[self updateAllFromParse];
    [self.threadObject fetchIfNeeded];
    [self.threadObject refresh];
    [self updateLayout];
}

-(void)updateAllFromParse
{
    [self.threadObject refreshInBackgroundWithTarget:self selector:@selector(updateQuestions)];
}

-(void)updateQuestions
{
    NSMutableArray* questions = self.threadObject[SHThreadQuestions];
    for (PFObject* questionObject in questions) {
        [questionObject refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            [self updateReplyWithQuestion:object];
        }];
    }
}

-(void)updateReplyWithQuestion: (PFObject*) questionObject
{
    NSMutableArray* replies = questionObject[SHQuestionReplies];
    for (PFObject* replyObject in replies) {
        
        [replyObject refresh];
    }
}


-(void)updateLayout
{
    NSLog(@"updateREplies called");
    for(UIView *subview in [self.scrollView subviews])
    {
        [subview removeFromSuperview];
    }
    
    [self.threadObject fetchIfNeeded];
    
    NSMutableArray* questions = self.threadObject[SHThreadQuestions];
    
    float lastBubbleY = firstBubbleStartY;
    for (PFObject* questionObject in questions)
    {
        [questionObject fetchIfNeeded];
        [questionObject refresh];
        SHQuestionBubble* bubble = [[SHQuestionBubble alloc] initWithQuestion:questionObject andFrame:CGRectMake(questionHorizontalOffset, lastBubbleY, bubbleWidth, 100)];
        bubble.delegate = self;
        [self.scrollView addSubview:bubble];
        lastBubbleY = bubble.frame.origin.y + bubble.frame.size.height + verticalOffsetBetweenBubbles;
        
        //now the replies for that particular question
        NSMutableArray* replies = questionObject[SHQuestionReplies];
        for (PFObject* replyObject in replies) {
            
            [replyObject fetchIfNeeded];
            [replyObject refresh];
            SHReplyBubble* replyBubble = [[SHReplyBubble alloc] initWithReply:replyObject andFrame:CGRectMake(repliesHorizontalOffset, lastBubbleY, bubbleWidth - (repliesHorizontalOffset - questionHorizontalOffset), 100)];
            replyBubble.delegate = self;
            [self.scrollView addSubview:replyBubble];
            
            lastBubbleY = replyBubble.frame.origin.y + replyBubble.frame.size.height + verticalOffsetBetweenBubbles;
            
        }
        
    }

}


-(void)postTextInTextView
{
    
    
    if(self.state == SHQuestioning)
    {
        //make a new question object
        PFObject* creator = [PFUser currentUser];
        NSString* question = self.textBar.textField.text;
        PFObject* newQuestionObject = [PFObject objectWithClassName:SHQuestionClassName];
        newQuestionObject[SHQuestionCreator] = creator;
        newQuestionObject[SHQuestionQuestion] = question;
        [newQuestionObject save];
        
        //add it to the threads list
        NSMutableArray* questions = [[NSMutableArray alloc]initWithArray:self.threadObject[SHThreadQuestions]];
        [questions addObject:newQuestionObject];
        self.threadObject[SHThreadQuestions] = questions;
        [self.threadObject save];
    }
    else if(self.state == SHReplying)
    {
        //make a new reply object
        PFObject* creator = [PFUser currentUser];
        NSString* answer = self.textBar.textField.text;
        PFObject* newReplyObject = [PFObject objectWithClassName:SHReplyClassName];
        newReplyObject[SHReplyCreator] = creator;
        newReplyObject[SHReplyAnswer] = answer;
        [newReplyObject save];
        
        //append it to the questions array
        [self.relevantQuestionObject fetchIfNeeded];
        NSMutableArray* replies = [[NSMutableArray alloc]initWithArray: self.relevantQuestionObject[SHQuestionReplies]];
        [replies addObject:newReplyObject];
        self.relevantQuestionObject[SHQuestionReplies] = replies;
        [self.relevantQuestionObject save];
        self.relevantQuestionObject = nil;
    }
    else if(self.state == SHEditingQuestion)
    {
        NSString* editedText = self.textBar.textField.text;
        self.relevantQuestionObject[SHQuestionQuestion] = editedText;
        [self.relevantQuestionObject save];
    }
    else if(self.state == SHEditingReply)
    {
        NSString* editedText = self.textBar.textField.text;
        self.relevantReplyObject[SHReplyAnswer] = editedText;
        [self.relevantReplyObject save];
    }
    
    self.state = SHQuestioning;
    [self.textBar.textField resignFirstResponder];
    self.textBar.textField.text = @"";
    [self updateLayout];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITextfield Delgate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //[SHUtility moveView:self.textBar distance:-keyboardHeight andDuration:0.3];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //[self animateTextField: textField up: YES];
}


//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    [SHUtility moveView:self.textBar distance:210 andDuration:0.3];
//    [textField resignFirstResponder];
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //[SHUtility moveView:self.textBar distance:keyboardHeight andDuration:0.3];
    [textField resignFirstResponder];
    return YES;
}




-(void) userPressedOutside:(id) sender
{
    [self.textBar.textField resignFirstResponder];
    //[SHUtility moveView:self.textBar distance:keyboardHeight andDuration:0.3];
}




-(void)didTapReply:(PFObject *)questionObject
{
 
    [self.textBar.textField becomeFirstResponder];
    self.state = SHReplying;
    self.relevantQuestionObject = questionObject;
    
}

-(void)didTapEdit:(PFObject *)questionObject
{
    [self.textBar.textField becomeFirstResponder];
    [questionObject fetchIfNeeded];
    self.textBar.textField.text = questionObject[SHQuestionQuestion];
    self.state = SHEditingQuestion;
    self.relevantQuestionObject = questionObject;
    
}

-(void)didTapEditReply:(PFObject *)replyObject
{
    NSLog(@"baby got kush 2");
    self.relevantReplyObject = replyObject;
    [replyObject fetchIfNeeded];
    [self.textBar.textField becomeFirstResponder];
    self.textBar.textField.text = replyObject[SHReplyAnswer];
    self.state = SHEditingReply;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"touchesBegan called");
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.textBar.textField isFirstResponder] && [touch view] != self.textBar) {
        [self.textBar.textField resignFirstResponder];
        
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    
    NSDictionary* info = [notification userInfo];
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [SHUtility moveView:self.textBar distance:-keyboardSize.height andDuration:[duration doubleValue]];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    
    NSDictionary* info = [notification userInfo];
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [SHUtility moveView:self.textBar distance:keyboardSize.height andDuration:[duration doubleValue]];

    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    
    if(scrollView.contentOffset.y<0)
    {
    
        if(self.canUpdate)
        {
            self.canUpdate = NO;
            [self refreshAll];
        }
        
    }
    else
    {
        self.canUpdate = YES;
    }
    
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = self.textBar.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	self.textBar.frame = r;
}

#pragma mark - Taking photos
-(void)takePictureCalled
{
    NSLog(@"TAKE PICTURE CALLED");
    [self chooseFromLibrary];
}


-(void)takePhoto

{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    
    // image picker needs a delegate,
    [imagePickerController setDelegate:self];
    
    // Place image picker on the screen
    [self presentViewController:imagePickerController animated:YES completion:nil];
    }



-(void)chooseFromLibrary
{
    
    UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
    [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    // image picker needs a delegate so we can respond to its messages
    [imagePickerController setDelegate:self];
    
    // Place image picker on the screen
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

//delegate methode will be called after picking photo either from camera or library
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    image = [SHUtility imageWithImage:image scaledToSize:CGSizeMake(100, 100)];
    NSLog(@"image: %@",image);
    UIImageView* imageView = [[UIImageView alloc]initWithImage:image];

 
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
