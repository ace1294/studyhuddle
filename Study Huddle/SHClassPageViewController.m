//
//  SHClassPageViewController.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/29/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHClassPageViewController.h"
#import "SHVisitorClassPageViewController.h"
#import "SHClassSegmentViewController.h"
#import "SHVisitorClassSegmentViewController.h"
#import "WYPopoverController.h"
#import "SHClassPageViewController.h"
#import "SHConstants.h"
#import "UIColor+HuddleColors.h"
#import "SHCache.h"
#import "SHClassPageAddViewController.h"

#define topPartSize 100
#define classNameWidth 500
#define classNameY 10
#define classNameFont boldSystemFontOfSize:35
#define emailFont boldSystemFontOfSize:10
#define roomFont boldSystemFontOfSize:10
#define buttonFont boldSystemFontOfSize:7
#define classNameColor [UIColor grayColor]
#define verticalOffsetBetweenTitles 5
#define emailWidth 300
#define classWidth 300
#define roomWidth 100
#define sideButtonWidth 70
#define horizontalOffsetBetweenRoomAndButton 5

@interface SHClassPageViewController () <UIScrollViewDelegate, WYPopoverControllerDelegate, SHClassPageAddDelegate>
{
    WYPopoverController* popoverController;
}

@property (nonatomic,strong) PFObject* classObj;
@property (nonatomic,strong) SHClassSegmentViewController* segmentController;
@property (nonatomic,strong) UIView* segmentContainer;
@property (nonatomic,strong) UIScrollView* scrollView;

@property (nonatomic,strong) UILabel* classNameLabel;
@property (nonatomic,strong) UILabel* profEmailLabel;
@property (nonatomic,strong) UILabel* roomLabel;
@property (nonatomic,strong) UIButton* leaveClassButton;

@property (strong, nonatomic) UIBarButtonItem *addButton;

@end

@implementation SHClassPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithClass:(PFObject *)aClass
{
    self = [super init];
    if (self) {
        self.classObj = aClass;
        
        self.title = @"CLASS";
        self.tabBarItem.image = [UIImage imageNamed:@"NavProf.png"];
      
        //Edit Button
        self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                       target:self
                                                                       action:@selector(addItem)];
        
        self.navigationItem.rightBarButtonItem = self.addButton;
        
    }
    return self;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.classObj fetchIfNeeded];
    
    //save it because it might be returning from the visitor class
    [self.classObj saveInBackground];
    
    SHClassPageAddViewController *addVC = [[SHClassPageAddViewController alloc]init];
    [addVC.view setFrame:CGRectMake(305, 55.0, 100.0, 200.0)];
    addVC.preferredContentSize = CGSizeMake(120, 40);
    addVC.delegate = self;
    popoverController = [[WYPopoverController alloc]initWithContentViewController:addVC];
    popoverController.delegate = self;
    [WYPopoverController setDefaultTheme:[WYPopoverTheme theme]];
    
    WYPopoverBackgroundView *appearance = [WYPopoverBackgroundView appearance];
    [appearance setTintColor:[UIColor huddleSilver]];
    
    
    
    float bottomOfNavBar = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
    //float middleHeight = (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height)/2;
    
    //background
    UIImageView* backGroundImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PatternBackground.png"]];
    [backGroundImg setFrame:self.view.frame];
    [self.view addSubview:backGroundImg];
    
    //set up the big class name label
    UIFont* classFont = [UIFont classNameFont];
    
    self.classNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - classNameWidth/2,bottomOfNavBar + classNameY,classNameWidth,classFont.pointSize)];
    self.classNameLabel.text = self.classObj[SHClassFullNameKey];
    [self.classNameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.classNameLabel setFont:classFont];
    [self.classNameLabel setTextColor:classNameColor];
    //self.classNameLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.classNameLabel];
    
    //set up the emails label
    UIFont* profEmailFont = [UIFont emailFont];
    self.profEmailLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-emailWidth/2, self.classNameLabel.frame.origin.y + self.classNameLabel.frame.size.height + verticalOffsetBetweenTitles, emailWidth, profEmailFont.pointSize)];
    self.profEmailLabel.text = [self.classObj[SHClassEmailKey] uppercaseString];
    //self.profEmailLabel.backgroundColor = [UIColor blueColor];
    self.profEmailLabel.font = profEmailFont;
    [self.profEmailLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.profEmailLabel];
    
    //set up the room number and button
    UIFont* roomLabelFont = [UIFont roomFont];
    CGFloat itemsHeight = roomLabelFont.pointSize;
    CGFloat roomAndButtonWidth = roomWidth + horizontalOffsetBetweenRoomAndButton + sideButtonWidth;
    
    
    
    self.roomLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-roomAndButtonWidth/2, self.profEmailLabel.frame.origin.y + self.profEmailLabel.frame.size.height + verticalOffsetBetweenTitles, roomWidth, itemsHeight)];
    self.roomLabel.text = [self.classObj[SHClassRoomKey] uppercaseString];
    self.roomLabel.font = roomLabelFont;
    [self.roomLabel setTextAlignment:NSTextAlignmentCenter];
    //self.roomLabel.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.roomLabel];
    
    self.leaveClassButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.leaveClassButton.frame = CGRectMake(self.roomLabel.frame.size.width + self.roomLabel.frame.origin.x + horizontalOffsetBetweenRoomAndButton, self.roomLabel.frame.origin.y, sideButtonWidth, itemsHeight);
    [self.leaveClassButton setTitle:@"LEAVE CLASS" forState:UIControlStateNormal];
    [self.leaveClassButton.titleLabel setFont:[UIFont buttonFont]];
    self.leaveClassButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.leaveClassButton.layer.cornerRadius = 3.0f;
    self.leaveClassButton.layer.borderColor = [UIColor redColor].CGColor;
    self.leaveClassButton.layer.borderWidth = 1.0f;
    [self.leaveClassButton addTarget:self action:@selector(leaveClassPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.leaveClassButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [self.view addSubview:self.leaveClassButton];
    
    
    
    
    
    //set up scroll view
    float viewableHeight = self.tabBarController.tabBar.frame.origin.y - self.navigationController.navigationBar.frame.origin.y - self.navigationController.navigationBar.frame.size.height;
    CGRect scrollViewFrame = CGRectMake(self.view.bounds.origin.x, bottomOfNavBar, self.view.bounds.size.width, viewableHeight);
    self.scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    self.scrollView.delegate = self;
    CGSize sViewContentSize = scrollViewFrame.size;
    sViewContentSize.height+=(topPartSize);
    
    [self.scrollView setContentSize:sViewContentSize];
    [self.view addSubview:self.scrollView];
    
    
    
    //set up segmented view
    self.segmentContainer = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.scrollView.bounds.origin.y + topPartSize, self.view.frame.size.width, self.view.frame.size.height*10)];
    self.segmentContainer.backgroundColor = [UIColor clearColor];
    self.segmentController = [[SHClassSegmentViewController alloc]initWithClass:self.classObj];
    self.segmentController.owner = self;
    
    [self addChildViewController:self.segmentController];
    self.segmentController.view.frame = self.segmentContainer.bounds;
    self.segmentContainer.backgroundColor = [UIColor whiteColor];
    [self.segmentContainer addSubview:self.segmentController.view];
    [self.segmentController didMoveToParentViewController:self];
    [self.scrollView addSubview:self.segmentContainer];
    self.segmentController.parentScrollView = self.scrollView;
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.leaveClassButton];
    
}


-(void)doChat
{
    NSLog(@"getting called");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leaveClassPressed
{
    //remove it to the current users classes array
    PFRelation* classesRelation = [[PFUser currentUser] relationForKey:SHStudentClassesKey];
    [classesRelation removeObject:self.classObj];
    [[PFUser currentUser] saveInBackground];
    
    [[SHCache sharedCache]leaveClass:self.classObj];
    
    SHVisitorClassPageViewController* classVC = [[SHVisitorClassPageViewController alloc]initWithClass:self.classObj];
    NSMutableArray* navControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    [navControllers insertObject:classVC atIndex:navControllers.count-1];
    self.navigationController.viewControllers = navControllers;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Actions

- (void)addItem
{
    [popoverController presentPopoverFromBarButtonItem:self.addButton permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
}

#pragma mark - ClassPageAddDelegate methods

- (void)addThreadTapped
{
    [popoverController dismissPopoverAnimated:YES completion:^{
        
        NSLog(@"ADDDING THE DOCUMENT");
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    DZNSegmentedControl* control = self.segmentController.control;
    
    float heightOfTable = [self.segmentController getOccupatingHeight];
    
    float viewableHeight = self.tabBarController.tabBar.frame.origin.y - self.navigationController.navigationBar.frame.origin.y - self.navigationController.navigationBar.frame.size.height;
    
    float normalHeight = viewableHeight + topPartSize;
    float extraDistance = (heightOfTable + control.frame.size.height)-viewableHeight;
    NSLog(@"extraDistance: %f",extraDistance);
    if(extraDistance > 0)
    {
        CGSize contentSize = scrollView.contentSize;
        contentSize.height =extraDistance + normalHeight;
        [self.scrollView setContentSize:contentSize];
    }
    else
    {
        CGSize contentSize = scrollView.contentSize;
        contentSize.height = normalHeight;
        [self.scrollView setContentSize:contentSize];
    }
    
    float distanceFromSegmentToButton =(self.scrollView.frame.origin.y + topPartSize) - ( self.leaveClassButton.frame.origin.y + self.leaveClassButton.frame.size.height);
    if(self.scrollView.contentOffset.y > distanceFromSegmentToButton)
    {
        [self.view bringSubviewToFront:self.scrollView];
        NSLog(@"its touching it gently");
    }
    else
        [self.view bringSubviewToFront:self.leaveClassButton];
    
    float distanceFromSegmentToTop = topPartSize;
    if(self.scrollView.contentOffset.y > distanceFromSegmentToTop )
    {
        float distanceMoved = scrollView.contentOffset.y - distanceFromSegmentToTop;
        CGRect rect = control.frame;
        rect.origin.y=distanceMoved;
        [control setFrame:rect];
        
        NSLog(@"its at the top");
    }
    else
    {
        CGRect rect = control.frame;
        rect.origin.y=0;
        [control setFrame:rect];
    }
    
}

@end
