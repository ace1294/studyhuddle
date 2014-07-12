//
//  SHNotificationViewController.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/30/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHChatEntryViewController.h"
#import "SHChatEntrySegmentViewController.h"
#import "SHConstants.h"
#import "SHNewThreadViewController.h"
#import "UIViewController+MJPopupViewController.h"



@interface SHChatEntryViewController () <SHModalViewControllerDelegate>

@property (nonatomic,strong) SHChatEntrySegmentViewController* segmentController;
@property (nonatomic,strong) UIView* segmentContainer;
@property (nonatomic,strong) PFObject* chatCategory;

@end

@implementation SHChatEntryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithChatEntry:(PFObject*) aChatEntry
{
    self = [super init];
    if (self) {
        self.chatCategory = aChatEntry;
        
        self.title = aChatEntry[SHChatCategoryNameKey];
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                   target:self
                                                                                   action:@selector(addThread)];
        
        self.navigationItem.rightBarButtonItem = addButton;
        
        
    }
    return self;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    float bottomOfNavBar = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
    
    
    self.segmentContainer = [[UIView alloc]initWithFrame:CGRectMake(0, bottomOfNavBar+10, self.view.frame.size.width, self.view.frame.size.height)];
    self.segmentContainer.backgroundColor = [UIColor clearColor];
    
    self.segmentController = [[SHChatEntrySegmentViewController alloc]initWithChatEntry:self.chatCategory];
    [self addChildViewController:self.segmentController];
    
    self.segmentController.view.frame = self.segmentContainer.bounds;
    self.segmentContainer.backgroundColor = [UIColor whiteColor];
    [self.segmentContainer addSubview:self.segmentController.view];
    [self.segmentController didMoveToParentViewController:self];
    self.segmentController.owner = self;
    
    [self.view addSubview:self.segmentContainer];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

- (void)addThread
{
    SHNewThreadViewController *newThreadVC = [[SHNewThreadViewController alloc]initWithChatCategory:self.chatCategory];
    newThreadVC.owner = self;
    newThreadVC.delegate = self;
    
    [self presentPopupViewController:newThreadVC animationType:MJPopupViewAnimationSlideBottomBottom dismissed:^{
        //
    }];
}

- (void)cancelTapped
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
}

@end
