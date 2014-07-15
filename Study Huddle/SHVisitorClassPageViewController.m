//
//  SHVisitorClassPageViewController.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 7/13/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHVisitorClassPageViewController.h"
#import "SHVisitorClassSegmentViewController.h"
#import "SHClassPageViewController.h"
#import "SHConstants.h"
#import "UIColor+HuddleColors.h"

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
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.topItem.title = @"";

    
    float bottomOfNavBar = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
    //float middleHeight = (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height)/2;
    
    //background
    UIImageView* backGroundImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shBackground.png"]];
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
    
    self.joinClassButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.joinClassButton.frame = CGRectMake(self.roomLabel.frame.size.width + self.roomLabel.frame.origin.x + horizontalOffsetBetweenRoomAndButton, self.roomLabel.frame.origin.y, sideButtonWidth, itemsHeight);
    [self.joinClassButton setTitle:@"JOIN CLASS" forState:UIControlStateNormal];
    [self.joinClassButton.titleLabel setFont:[UIFont buttonFont]];
    self.joinClassButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.joinClassButton.layer.cornerRadius = 3.0f;
    self.joinClassButton.layer.borderColor = [UIColor huddleGreen].CGColor;
    self.joinClassButton.layer.borderWidth = 1.0f;
    [self.joinClassButton addTarget:self action:@selector(addClassPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.joinClassButton setTitleColor:[UIColor huddleGreen] forState:UIControlStateNormal];
    [self.view addSubview:self.joinClassButton];

    
    
    
    
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
    self.segmentController = [[SHVisitorClassSegmentViewController alloc]initWithClass:self.classObj];
    self.segmentController.owner = self;
    
    [self addChildViewController:self.segmentController];
    self.segmentController.view.frame = self.segmentContainer.bounds;
    self.segmentContainer.backgroundColor = [UIColor whiteColor];
    [self.segmentContainer addSubview:self.segmentController.view];
    [self.segmentController didMoveToParentViewController:self];
    [self.scrollView addSubview:self.segmentContainer];
    self.segmentController.parentScrollView = self.scrollView;
    
    
    
    
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.joinClassButton];
    
    
    
    
}



-(void)addClassPressed
{
   
    //add it to the current users classes array
    PFUser* currentUser = [PFUser currentUser];
    NSMutableArray* classesArray = [[NSMutableArray alloc]initWithArray:currentUser[SHStudentClassesKey]];
    [classesArray addObject:self.classObj];
    currentUser[SHStudentClassesKey] = classesArray;
    [currentUser save];
    
    //add it to the classes students array
   // [self.classObj addObject:currentUser forKey:SHClassStudentsKey];
    
    NSString* currentUserId = [currentUser objectId];
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    PFObject* student = [query getObjectWithId:currentUserId];
    [self.classObj addObject:student forKey:SHClassStudentsKey];
    [self.classObj save];

  
  
    
    SHClassPageViewController* classVC = [[SHClassPageViewController alloc]initWithClass:self.classObj];
    NSMutableArray* navControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    [navControllers insertObject:classVC atIndex:navControllers.count-1];
    self.navigationController.viewControllers = navControllers;
    [self.navigationController popViewControllerAnimated:YES];

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
    
    float distanceFromSegmentToButton =(self.scrollView.frame.origin.y + topPartSize) - ( self.joinClassButton.frame.origin.y + self.joinClassButton.frame.size.height);
    if(self.scrollView.contentOffset.y > distanceFromSegmentToButton)
    {
        [self.view bringSubviewToFront:self.scrollView];
        NSLog(@"its touching it gently");
    }
    else
        [self.view bringSubviewToFront:self.joinClassButton];
    
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
