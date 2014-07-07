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

#define questionHorizontalOffset 10
#define repliesHorizontalOffset 30
#define bubbleWidth 300
#define firstBubbleStartY 30
#define verticalOffsetBetweenBubbles 40
#define replyTextFieldHeight 40

@interface SHThreadViewController ()<UITextFieldDelegate,SHQuestionBubbleDelegate>

@property UIScrollView* scrollView;

@property (strong,nonatomic) PFObject* threadObject;
@property (strong,nonatomic) NSMutableArray* replies;
@property (strong,nonatomic) SHQuestionBubble* questionBubble;
@property (strong,nonatomic) UITextField* replyTextField;

@property CGRect initialFrame;

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
    
    //that scroll view
    CGRect scrollViewFrame = self.view.frame;
    scrollViewFrame.size.height -= (replyTextFieldHeight + 100);
    self.scrollView = [[UIScrollView alloc]initWithFrame:scrollViewFrame];
    [self.view addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 99999);
    self.scrollView.backgroundColor = [UIColor grayColor];
    
    //that reply text field
    self.replyTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-replyTextFieldHeight, self.view.frame.size.width, replyTextFieldHeight)];
    self.replyTextField.text = @"W00h";
    self.replyTextField.backgroundColor = [UIColor whiteColor];
    self.replyTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.replyTextField.delegate = self;
    self.initialFrame = self.replyTextField.frame;
    [self.view addSubview:self.replyTextField];
    
  
 
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
            
            SHReplyBubble* replyBubble = [[SHReplyBubble alloc] initWithReply:replyObject andFrame:CGRectMake(repliesHorizontalOffset, lastBubbleY, bubbleWidth                                                                                , 100)];
            [self.scrollView addSubview:replyBubble];
            
            lastBubbleY = replyBubble.frame.origin.y + replyBubble.frame.size.height + verticalOffsetBetweenBubbles;
            
        }
        
    }

    

    
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITextfield Delgate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
    [textField resignFirstResponder];
    return YES;
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    [self moveUp:up];
    
}



- (void)moveUp: (BOOL) up
{
    const int movementDistance = -220; // tweak as needed
    
    
    if(up){
        [UIView animateWithDuration:0.1f animations:^{
           self.replyTextField.frame = CGRectOffset(self.initialFrame, 0, movementDistance);
        }];
    }
    else{
        [UIView animateWithDuration:0.1f animations:^{
            self.replyTextField.frame = self.initialFrame;
        }];
    }
    
    
}

-(void)didTapReply:(PFObject *)questionObject
{
    NSLog(@"question object: %@",questionObject);
    
    //make a new reply object
    PFObject* creator = [PFUser currentUser];
    NSString* answer = self.replyTextField.text;
    PFObject* newReplyObject = [PFObject objectWithClassName:SHReplyClassName];
    newReplyObject[SHReplyCreator] = creator;
    newReplyObject[SHReplyAnswer] = answer;
    
    //append it to the questions array
    [questionObject fetchIfNeeded];
    NSMutableArray* replies = questionObject[SHQuestionReplies];
    [replies addObject:newReplyObject];
    [self updateReplies];
    
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
