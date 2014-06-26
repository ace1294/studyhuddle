//
//  SHProfileViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/14/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHProfileViewController.h"
#import "SHProfileSettingsController.h"
#import "UIColor+HuddleColors.h"
#import "SHConstants.h"


#define profileImageWidth 100
#define profileImageHeight 100
#define profileImageVerticalOffsetFromTop 10

@interface SHProfileViewController ()<UIScrollViewDelegate>


@property (strong, nonatomic) SHProfileSegmentViewController *segmentController;

@property UIView* profileHeaderContainer;
@property UIView *segmentContainer;
@property UIScrollView* scrollView;
@property BOOL inMiddleOfAnimation;
@property BOOL isGoingDown;
@property BOOL isGoingUp;
@property BOOL isUp;
@property (nonatomic, strong) PFObject *profStudent;

@end

@implementation SHProfileViewController


- (id)init
{
    self = [self initWithStudent:(Student *)[Student user]];
            
    return self;
}

- (id)initWithStudent:(Student *)aStudent
{
    self = [super init];
    if (self) {
        _profStudent = aStudent;
    
        self.title = @"Profile";
        self.tabBarItem.image = [UIImage imageNamed:@"profile.png"];
        
        
        //set up the navigation options
  
        //settings button
        UIBarButtonItem* settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(settingsPressed)];
        UIImage* cogWheelImg = [UIImage imageNamed:@"cogwheel.png"];
        [settingsButton setImage:cogWheelImg];
        settingsButton.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = settingsButton;

        
    }
    return self;
}

- (void)setStudent:(Student *)aProfStudent
{
    
    _profStudent = aProfStudent;
    
    [self.segmentController setStudent:aProfStudent];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    UITapGestureRecognizer *navSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navSingleTap)];
    navSingleTap.numberOfTapsRequired = 1;
    [[self.navigationController.navigationBar.subviews objectAtIndex:1] setUserInteractionEnabled:YES];
    [[self.navigationController.navigationBar.subviews objectAtIndex:1] addGestureRecognizer:navSingleTap];
    
    //set up portrait view
     CGRect profileFrame = CGRectMake(self.view.bounds.origin.x, self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.bounds.size.height, self.view.bounds.size.width, 168);
     self.profileHeaderContainer = [[UIView alloc]initWithFrame:profileFrame];
     self.profileHeaderContainer.backgroundColor = [UIColor clearColor];
    self.profileVC = [[SHProfileHeaderViewController alloc]init];
    [self addChildViewController:self.profileVC];
    self.profileVC.view.frame = self.profileHeaderContainer.bounds;
    [self.profileHeaderContainer addSubview:self.profileVC.view];
    [self.profileVC didMoveToParentViewController:self];
    
    
    
    //set up segmented view
    self.segmentContainer = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.profileHeaderContainer.bounds.size.height + self.scrollView.bounds.origin.y  , self.view.frame.size.width, self.view.frame.size.height*10)];
    self.segmentContainer.backgroundColor = [UIColor clearColor];
    self.segmentController = [[SHProfileSegmentViewController alloc]initWithStudent:(Student *)self.profStudent];
    self.segmentController.owner = self;
    [self addChildViewController:self.segmentController];
    self.segmentController.view.frame = self.segmentContainer.bounds;
    self.segmentContainer.backgroundColor = [UIColor whiteColor];
    [self.segmentContainer addSubview:self.segmentController.view];
    [self.segmentController didMoveToParentViewController:self];
   
    
    [self.segmentController.tableView setScrollEnabled:NO];
    
    //set up scroll view
    CGRect scrollViewFrame = CGRectMake(self.view.bounds.origin.x, self.profileHeaderContainer.frame.origin.y, self.view.bounds.size.width, self.view.bounds.size.height);
    self.scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.delegate = self;
    CGSize sViewContentSize = scrollViewFrame.size;
    sViewContentSize.height+=(profileFrame.size.height-self.navigationController.navigationBar.frame.size.height-65) + 300;
    [self.scrollView setContentSize:sViewContentSize];
    [self.scrollView addSubview:self.segmentContainer];
    self.segmentController.parentScrollView = self.scrollView;
    self.inMiddleOfAnimation = NO;
    self.isGoingDown = NO;
    self.isGoingUp = NO;
    self.isUp = NO;
    //[self.scrollView setScrollEnabled:NO];
    
    
    //set up extended background
    //CGRect extendedBGFrame = self.profileHeaderContainer.frame;
    //extendedBGFrame.origin.y+=extendedBGFrame.size.height;
    //UIImageView* extendedBG = [[UIImageView alloc]initWithFrame:extendedBGFrame];
    //extendedBG.image = [UIImage imageNamed:@"backgroundPattern@2x.png"];
    
    UIImageView* backgroundImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    backgroundImageView.image = [UIImage imageNamed:@"backgroundPtrnFull@2x.png"];
    [self.view addSubview:backgroundImageView];

    
    //set up the portrait
    UIImage* defaultImage = [UIImage imageNamed:@"placeholderProfPic.png"];
    float centerX = self.view.bounds.origin.x + self.view.bounds.size.width/2;
    self.profileImage = [[SHProfilePortraitView alloc]initWithImage:defaultImage andFrame:CGRectMake(centerX - profileImageWidth/2 , profileImageVerticalOffsetFromTop + self.profileHeaderContainer.frame.origin.y, profileImageWidth, profileImageHeight)  ];
    self.profileImage.owner = self;

    //add it in the right order
    //[self.view addSubview:extendedBG];
    [self.view addSubview:self.profileHeaderContainer];
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.profileImage];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.profileVC doLayout];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float distanceFromBottomToPicture = self.profileHeaderContainer.frame.origin.y + self.profileHeaderContainer.frame.size.height-self.profileImage.frame.origin.y - self.profileImage.frame.size.height;
    
    //[self.segmentController.control removeFromSuperview];
    //[self.segmentController.control setFrame:CGRectMake(0, 50, 400, 400)];
    //[self.view addSubview:self.segmentController.control];
    
    NSLog(@"control position: %f",self.segmentController.control.frame.origin.y);
    
    
    NSLog(@"contentoffset: %f",scrollView.contentOffset.y);
    
    if(scrollView.contentOffset.y>distanceFromBottomToPicture)
    {
        NSLog(@"its touching it!");
        [self.view bringSubviewToFront:self.scrollView];
    }
    else if(!self.isGoingDown){
        [self.view bringSubviewToFront:self.profileImage];
    }
    
    if(self.scrollView.contentOffset.y>self.profileHeaderContainer.frame.size.height)
    {
        NSLog(@"its at the top");
        [self.segmentController.tableView setScrollEnabled:YES];
        [self.scrollView setContentOffset:CGPointMake(0, self.profileHeaderContainer.frame.size.height)];
        [self.scrollView setScrollEnabled:NO];
        //[self.scrollView setBounces:NO];
    }
    
    
}


-(void)navSingleTap
{
    NSLog(@"Black People");
    [self.scrollView setScrollEnabled:NO];
    self.isGoingDown = YES;
     [self.view bringSubviewToFront:self.scrollView];
    [UIView animateWithDuration:0.5 animations:^{
    
       
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
                     completion:^ (BOOL finished)
     {
         if (finished) {
             NSLog(@"finished");
             //[self.view bringSubviewToFront:self.profileImage];
             [self.scrollView setScrollEnabled:YES];
             self.isGoingDown = NO;
             [self.view bringSubviewToFront:self.profileImage];
         }
     }];
}


-(void) settingsPressed
{
    NSLog(@"settings pressed");
    SHProfileSettingsController* settingsController = [[SHProfileSettingsController alloc]init];
    [self.navigationController pushViewController:settingsController animated:YES];
}






/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float distanceFromBottomToPicture = self.profileHeaderContainer.frame.origin.y + self.profileHeaderContainer.frame.size.height-self.profileImage.frame.origin.y - self.profileImage.frame.size.height;
    
    NSLog(@"contentoffset: %f",scrollView.contentOffset.y);
    
   if(scrollView.contentOffset.y>distanceFromBottomToPicture)
    {
        NSLog(@"its touching it!");
        [self.view bringSubviewToFront:self.scrollView];
    }
    else{
        [self.view bringSubviewToFront:self.profileImage];
    }
    
    
    if(scrollView.contentOffset.y>0 && !self.tableIsUp)
    {
        [scrollView setScrollEnabled:NO];
        [UIView animateWithDuration:5 animations:^{
            
            scrollView.contentOffset = CGPointMake(0, self.profileHeaderContainer.frame.size.height);
        }
        completion:^ (BOOL finished)
         {
             if (finished) {
                 NSLog(@"finished");
                 [scrollView setScrollEnabled:YES];
                 self.tableIsUp = YES;
             }
         }];

    }
    else
    {
        [scrollView setScrollEnabled:NO];
        [UIView animateWithDuration:5 animations:^{
            
            scrollView.contentOffset = CGPointMake(0, 0);
        }
                         completion:^ (BOOL finished)
         {
             if (finished) {
                 NSLog(@"finished");
                 [scrollView setScrollEnabled:YES];
                 self.tableIsUp = NO;
             }
         }];
    }
    
    if(scrollView.contentOffset.y>self.profileHeaderContainer.frame.size.height)
    {
        NSLog(@"it got here");
    }
    

}
*/

/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
       NSLog(@"content offset: %f",self.scrollView.contentOffset.y);
    float distanceFromBottomToPicture = self.profileHeaderContainer.frame.origin.y + self.profileHeaderContainer.frame.size.height-self.profileImage.frame.origin.y - self.profileImage.frame.size.height;
    
    if(scrollView.contentOffset.y>distanceFromBottomToPicture)
    {
       // NSLog(@"its touching it!");
        [self.view bringSubviewToFront:self.scrollView];
    }
    else{
        [self.view bringSubviewToFront:self.profileImage];
    }

     if(scrollView.contentOffset.y>0 && !self.inMiddleOfAnimation && !self.isGoingDown && !self.isUp)
     {
         self.inMiddleOfAnimation = YES;
         self.isGoingUp = YES;
         [self.scrollView setScrollEnabled:NO];
         [self.scrollView setContentOffset:CGPointMake(0, self.profileHeaderContainer.frame.size.height) withTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear] duration:0.5];
     }
    
    NSLog(@"top: %f",self.profileHeaderContainer.frame.size.height);
    NSLog(@"current: %f",self.scrollView.contentOffset.y);
    
    if(scrollView.contentOffset.y <= self.profileHeaderContainer.frame.size.height-20 && !self.inMiddleOfAnimation && !self.isGoingUp)
    {
        NSLog(@"going down");
        self.inMiddleOfAnimation = YES;
        self.isGoingDown = YES;
        [self.scrollView setScrollEnabled:NO];
        [self.scrollView setContentOffset:CGPointMake(0, 0) withTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear] duration:0.5];
    }
    

 
 


    
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"animation ended");
    [self.scrollView setScrollEnabled:YES];
    self.inMiddleOfAnimation = NO;
    
    self.isGoingUp = NO;
    self.isGoingDown = NO;
    
    if(self.scrollView.contentOffset.y > 0) self.isUp = YES;
    else self.isUp = NO;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
