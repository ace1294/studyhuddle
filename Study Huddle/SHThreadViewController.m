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
#define replyTextFieldHeight 40
#define keyboardHeight 220
#define animationLength 0.2f

@interface SHThreadViewController ()<UITextFieldDelegate,SHQuestionBubbleDelegate>

@property UIScrollView* scrollView;

@property (strong,nonatomic) PFObject* threadObject;
@property (strong,nonatomic) NSMutableArray* replies;
@property (strong,nonatomic) SHQuestionBubble* questionBubble;
@property (strong,nonatomic) UITextField* replyTextField;
@property (strong,nonatomic) SHTextBar* textBar;

@property (strong,nonatomic) PFObject* relevantQuestionObject;
@property (strong,nonatomic) PFObject* relevantReplyObject;

@property BOOL isPostingNewQuestion;

@end

@implementation SHThreadViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isPostingNewQuestion = YES; //by default when the user hits post, it will be posted as a question instead of a reply
    
    //that scroll view
    CGRect scrollViewFrame = self.view.frame;
    scrollViewFrame.size.height -= (replyTextFieldHeight);
    self.scrollView = [[UIScrollView alloc]initWithFrame:scrollViewFrame];
    [self.view addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 99999);
    self.scrollView.backgroundColor = [UIColor huddleLightSilver];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userPressedOutside:)];
    [self.scrollView addGestureRecognizer:gestureRecognizer];
    

    
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
 
    [self updateReplies];
    

}

-(void)updateReplies
{
    for(UIView *subview in [self.scrollView subviews])
    {
        [subview removeFromSuperview];
    }
    
    NSMutableArray* questions = self.threadObject[SHThreadQuestions];
    
    float lastBubbleY = firstBubbleStartY;
    for (PFObject* questionObject in questions)
    {
        SHQuestionBubble* bubble = [[SHQuestionBubble alloc] initWithQuestion:questionObject andFrame:CGRectMake(questionHorizontalOffset, lastBubbleY, bubbleWidth, 100)];
        bubble.delegate = self;
        [self.scrollView addSubview:bubble];
        lastBubbleY = bubble.frame.origin.y + bubble.frame.size.height + verticalOffsetBetweenBubbles;
        
        //now the replies for that particular question
        NSMutableArray* replies = questionObject[SHQuestionReplies];
        for (PFObject* replyObject in replies) {
            
            SHReplyBubble* replyBubble = [[SHReplyBubble alloc] initWithReply:replyObject andFrame:CGRectMake(repliesHorizontalOffset, lastBubbleY, bubbleWidth - (repliesHorizontalOffset - questionHorizontalOffset), 100)];
            [self.scrollView addSubview:replyBubble];
            
            lastBubbleY = replyBubble.frame.origin.y + replyBubble.frame.size.height + verticalOffsetBetweenBubbles;
            
        }
        
    }

}

-(void)postTextInTextView
{
    
    NSLog(@"postTextInTextView called");
    if(self.isPostingNewQuestion)
    {
        //make a new question object
        PFObject* creator = [PFUser currentUser];
        NSString* question = self.textBar.textField.text;
        PFObject* newQuestionObject = [PFObject objectWithClassName:SHQuestionClassName];
        newQuestionObject[SHQuestionCreator] = creator;
        newQuestionObject[SHQuestionQuestion] = question;
        [newQuestionObject saveInBackground];
        
        //add it to the threads list
         NSMutableArray* questions = self.threadObject[SHThreadQuestions];
        [questions addObject:newQuestionObject];
        self.threadObject[SHThreadQuestions] = questions;
        [self.threadObject saveInBackground];
        [self updateReplies];
    }
    else
    {
        //make a new reply object
        PFObject* creator = [PFUser currentUser];
        NSString* answer = self.textBar.textField.text;
        PFObject* newReplyObject = [PFObject objectWithClassName:SHReplyClassName];
        newReplyObject[SHReplyCreator] = creator;
        newReplyObject[SHReplyAnswer] = answer;
        [newReplyObject saveInBackground];
        
        //append it to the questions array
        [self.relevantQuestionObject fetchIfNeeded];
        NSMutableArray* replies = self.relevantQuestionObject[SHQuestionReplies];
        [replies addObject:newReplyObject];
        self.relevantQuestionObject[SHQuestionReplies] = replies;
        [self.relevantQuestionObject saveInBackground];
        [self updateReplies];
    }
    
    self.isPostingNewQuestion = YES;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITextfield Delgate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [SHUtility moveView:self.textBar distance:-keyboardHeight andDuration:0.3];
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
    [SHUtility moveView:self.textBar distance:keyboardHeight andDuration:0.3];
    [textField resignFirstResponder];
    return YES;
}




-(void) userPressedOutside:(id) sender
{
    [self.textBar.textField resignFirstResponder];
    [SHUtility moveView:self.textBar distance:keyboardHeight andDuration:0.3];
}




-(void)didTapReply:(PFObject *)questionObject
{
    NSLog(@"question object: %@",questionObject);
    
    [self.textBar.textField becomeFirstResponder];
    self.isPostingNewQuestion = NO; //he is posting a reply
    self.relevantQuestionObject = questionObject;
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"touchesBegan called");
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.textBar.textField isFirstResponder] && [touch view] != self.textBar) {
        [self.textBar.textField resignFirstResponder];
        
        [SHUtility moveView:self.textBar distance:keyboardHeight andDuration:0.3];
        
    }
    [super touchesBegan:touches withEvent:event];
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
