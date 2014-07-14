//
//  SHVisitorClassPageViewController.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 7/13/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHVisitorClassPageViewController.h"
#import "SHVisitorClassSegmentViewController.h"
#import "SHConstants.h"

#define topPartSize 100
#define classNameWidth 500
#define classNameY 30
#define classNameFont boldSystemFontOfSize:35
#define emailFont systemFontOfSize:10
#define roomFont systemFontOfSize:10
#define classNameColor [UIColor grayColor]
#define verticalOffsetBetweenTitles 5
#define emailWidth 300
#define classWidth 300



@interface SHVisitorClassPageViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) PFObject* classObj;
@property (nonatomic,strong) SHVisitorClassSegmentViewController* segmentController;
@property (nonatomic,strong) UIView* segmentContainer;
@property (nonatomic,strong) UIScrollView* scrollView;

@property (nonatomic,strong) UILabel* classNameLabel;
@property (nonatomic,strong) UILabel* profEmailLabel;
@property (nonatomic,strong) UILabel* roomLabel;
@property (nonatomic,strong) UIButton* joinClassButton;

@end

@implementation SHVisitorClassPageViewController

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
        self.tabBarItem.image = [UIImage imageNamed:@"profile.png"];
        
        
        //set up the navigation options
        //settings button
        
        
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.classObj fetchIfNeeded];
    
    
    //important coordinates
    float centerX = self.view.bounds.origin.x + self.view.bounds.size.width/2;
    
    float bottomOfNavBar = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
    //float middleHeight = (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height)/2;
    
    //background
    UIImageView* backGroundImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shBackground.png"]];
    [backGroundImg setFrame:self.view.frame];
    [self.view addSubview:backGroundImg];
    
    //set up the big class name label
    UIFont* classFont = [UIFont classNameFont];

    self.classNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - classNameWidth/2,bottomOfNavBar + topPartSize/2 - (classFont.pointSize)/2,classNameWidth,classFont.pointSize)];
    self.classNameLabel.text = self.classObj[SHClassFullNameKey];
    [self.classNameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.classNameLabel setFont:classFont];
    [self.classNameLabel setTextColor:classNameColor];
    //self.classNameLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.classNameLabel];
    
    //set up the emails label
    UIFont* profEmailFont = [UIFont emailFont];
    self.profEmailLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-emailWidth/2, self.classNameLabel.frame.origin.y + self.classNameLabel.frame.size.height + verticalOffsetBetweenTitles, emailWidth, profEmailFont.pointSize)];
    self.profEmailLabel.text = self.classObj[SHClassEmailKey];
    //self.profEmailLabel.backgroundColor = [UIColor blueColor];
    self.profEmailLabel.font = profEmailFont;
    [self.profEmailLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.profEmailLabel];
    
    //set up the room number
    UIFont* roomLabelFont = [UIFont roomFont];
    self.roomLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-emailWidth/2, self.profEmailLabel.frame.origin.y + self.profEmailLabel.frame.size.height + verticalOffsetBetweenTitles, classWidth, roomLabelFont.pointSize)];
    self.roomLabel.text = self.classObj[SHClassRoomKey];
    self.roomLabel.font = roomLabelFont;
    //self.roomLabel.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.roomLabel];
    
    
    
    
    //set up scroll view
    float viewableHeight = self.tabBarController.tabBar.frame.origin.y - self.navigationController.navigationBar.frame.origin.y - self.navigationController.navigationBar.frame.size.height;
    CGRect scrollViewFrame = CGRectMake(self.view.bounds.origin.x, bottomOfNavBar, self.view.bounds.size.width, viewableHeight);
    self.scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    self.scrollView.delegate = self;
    CGSize sViewContentSize = scrollViewFrame.size;
    sViewContentSize.height+=(topPartSize);
    //sViewContentSize.height+=999999;
    [self.scrollView setContentSize:sViewContentSize];
    [self.view addSubview:self.scrollView];
    
    
    
    //set up segmented view
    self.segmentContainer = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.scrollView.bounds.origin.y + topPartSize, self.view.frame.size.width, self.view.frame.size.height*10)];
    self.segmentContainer.backgroundColor = [UIColor clearColor];
    self.segmentController = [[SHVisitorClassSegmentViewController alloc]initWithClass:self.classObj];
    
    [self addChildViewController:self.segmentController];
    self.segmentController.view.frame = self.segmentContainer.bounds;
    self.segmentContainer.backgroundColor = [UIColor whiteColor];
    [self.segmentContainer addSubview:self.segmentController.view];
    [self.segmentController didMoveToParentViewController:self];
    [self.scrollView addSubview:self.segmentContainer];
    self.segmentController.parentScrollView = self.scrollView;
    
    
    
    
    
    [self.view addSubview:self.scrollView];
    
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    
    
    
    float distanceFromSegmentToTop = topPartSize;
    if(self.scrollView.contentOffset.y > distanceFromSegmentToTop )
    {
        float distanceMoved = scrollView.contentOffset.y - distanceFromSegmentToTop;
        CGRect rect = control.frame;
        rect.origin.y=distanceMoved;
        [control setFrame:rect];
        NSLog(@"its at the top");
        //check to see if we should all the table to keep scrolling
        
    }
    else
    {
        CGRect rect = control.frame;
        rect.origin.y=0;
        [control setFrame:rect];
    }
    
}

@end
