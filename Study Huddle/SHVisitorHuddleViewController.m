//
//  SHVisitorHuddleViewController.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 7/13/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

//
//  SHProfileViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/14/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHVisitorHuddleViewController.h"
#import "UIColor+HuddleColors.h"
#import "SHConstants.h"
#import "SHVisitorHuddleSegmentViewController.h"
#import "SHNewQuestionViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "WYPopoverController.h"
#import "SHNewResourceViewController.h"
#import "SHStudentSearchViewController.h"
#import "SHHuddleJoinRequestViewController.h"


#define profileImageWidth 100
#define profileImageHeight 100
#define profileImageVerticalOffsetFromTop 10

#define fullNameLabelVerticalOffsetFromPicture 5
#define fullNameWidth 400
#define fullNameHeight 20



#define hoursStudiedLabelWidth 45
#define hoursStudiedLabelHeight 30

#define sideItemDiameters 45
#define sideItemLabelsVerticalOffsetFromCircle 0
#define sideLabelsWidth 70
#define sideLabelHeight 10


#define topPartSize 170




#define nameLabelFont [UIFont boldSystemFontOfSize:15]

#define sideItemsFont [UIFont systemFontOfSize:7]


@interface SHVisitorHuddleViewController () <UIScrollViewDelegate, SHModalViewControllerDelegate, WYPopoverControllerDelegate>


@property (strong, nonatomic) SHVisitorHuddleSegmentViewController *segmentController;
@property UIView *segmentContainer;
@property UIScrollView* scrollView;

@property (nonatomic, strong) PFObject *indvHuddle;

@property (nonatomic, strong) UILabel* fullNameLabel;
@property (nonatomic,strong) UILabel* inviteToStudyLabel;
@property (nonatomic,strong) UIButton* inviteToStudyButton;
@property (nonatomic,strong) UIButton* requestToJoinButton;
@property (nonatomic,strong) UILabel* requestToJoinLabel;




@end

@implementation SHVisitorHuddleViewController


- (id)init
{
    NSLog(@"normal init called");
    self = [self initWithHuddle:nil];
    
    return self;
}

- (id)initWithHuddle:(PFObject *)aHuddle
{
    NSLog(@"initWithHuddleCalled");
    self = [super init];
    if (self) {
        self.indvHuddle = aHuddle;
        
        self.title = @"Huddle";
        self.tabBarItem.image = [UIImage imageNamed:@"profile.png"];
    
    }
    return self;
}



- (void)setHuddle:(PFObject *)aHuddle
{
    
    self.indvHuddle = aHuddle;
    
    [self.segmentController setHuddle:aHuddle];
    [self.profileImage setHuddle:aHuddle];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.topItem.title = @"";
    
    //important coordinates
    float centerX = self.view.bounds.origin.x + self.view.bounds.size.width/2;
    
    float bottomOfNavBar = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
    //float middleHeight = (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height)/2;
    
    //background
    UIImageView* backGroundImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shBackground.png"]];
    [backGroundImg setFrame:self.view.frame];
    [self.view addSubview:backGroundImg];
    
    
    
    //set up portrait view
    CGRect profileFrame = CGRectMake(centerX-profileImageWidth/2, bottomOfNavBar + profileImageVerticalOffsetFromTop, profileImageWidth, profileImageHeight);
    
    //set up name label
    self.fullNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(centerX - fullNameWidth/2,profileFrame.origin.y + profileFrame.size.height + fullNameLabelVerticalOffsetFromPicture, fullNameWidth, fullNameHeight)];
    self.fullNameLabel.text = [self.indvHuddle[@"huddleName"] uppercaseString];
    [self.fullNameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.fullNameLabel setFont: nameLabelFont];
    [self.fullNameLabel setTextColor:[UIColor grayColor]];
    [self.view addSubview:self.fullNameLabel];
    
    
    //set up the side items
    float leftPictureEdge = profileFrame.origin.x;
    float rightPictureEdge = leftPictureEdge + profileFrame.size.width;
    float leftMidPoint = leftPictureEdge/2-sideItemDiameters/2;
    float rightMidPoint = rightPictureEdge + leftMidPoint;
    float midYPoint = profileFrame.origin.y + profileFrame.size.height/2 - sideItemDiameters/2;
    self.inviteToStudyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.inviteToStudyButton addTarget:self action:@selector(inviteToStudyPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.inviteToStudyButton setFrame:CGRectMake(leftMidPoint, midYPoint, sideItemDiameters, sideItemDiameters)];
    [self.inviteToStudyButton setImage:[UIImage imageNamed:@"inviteToStudy.png"] forState:UIControlStateNormal];
    self.inviteToStudyLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.inviteToStudyButton.frame.origin.x + self.inviteToStudyButton.frame.size.width/2 - sideLabelsWidth/2, self.inviteToStudyButton.frame.origin.y + self.inviteToStudyButton.frame.size.height + sideItemLabelsVerticalOffsetFromCircle, sideLabelsWidth, sideLabelHeight)];
    self.inviteToStudyLabel.text = @"INVITE TO STUDY";
    self.inviteToStudyLabel.textColor = [UIColor huddleOrange];
    [self.inviteToStudyLabel setTextAlignment:NSTextAlignmentCenter];
    [self.inviteToStudyLabel setFont:sideItemsFont];
    [self.view addSubview:self.inviteToStudyLabel];
    
    
    self.requestToJoinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.requestToJoinButton addTarget:self action:@selector(requestToJoinPressed) forControlEvents:UIControlEventTouchUpInside];
    self.requestToJoinButton.frame = CGRectMake(rightMidPoint, midYPoint, sideItemDiameters, sideItemDiameters);
    [self.requestToJoinButton setImage:[UIImage imageNamed:@"inviteToHuddle.png"] forState:UIControlStateNormal];
    self.requestToJoinLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.requestToJoinButton.frame.origin.x+ self.requestToJoinButton.frame.size.width/2 - sideLabelsWidth/2, self.requestToJoinButton.frame.origin.y + self.requestToJoinButton.frame.size.height + sideItemLabelsVerticalOffsetFromCircle, sideLabelsWidth, sideLabelHeight)];

    
    self.requestToJoinLabel.text = @"REQUEST TO JOIN";
    [self.requestToJoinLabel setTextColor:[UIColor huddlePurple]];
    [self.requestToJoinLabel setTextAlignment:NSTextAlignmentCenter];
    [self.requestToJoinLabel setFont:sideItemsFont];
    //[self.startStudyingLabel setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:self.requestToJoinLabel];
    
    
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
    self.segmentController = [[SHVisitorHuddleSegmentViewController alloc]initWithHuddle:self.indvHuddle];
    
    [self addChildViewController:self.segmentController];
    self.segmentController.view.frame = self.segmentContainer.bounds;
    self.segmentContainer.backgroundColor = [UIColor whiteColor];
    [self.segmentContainer addSubview:self.segmentController.view];
    [self.segmentController didMoveToParentViewController:self];
    //self.segmentController.owner = self;
    [self.scrollView addSubview:self.segmentContainer];
    self.segmentController.parentScrollView = self.scrollView;
    
    
    self.profileImage = [[SHHuddlePortraitView alloc]initWithFrame:profileFrame];
    [self.profileImage setHuddle:self.indvHuddle];
    self.profileImage.isClickable = NO;

    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.profileImage];
    [self.view addSubview:self.inviteToStudyButton];
    [self.view addSubview:self.requestToJoinButton];

    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)inviteToStudyPressed
{
    NSLog(@"inviteToStudy not implemented yet");
}

-(void)requestToJoinPressed
{
    SHHuddleJoinRequestViewController *joinRequestVC = [[SHHuddleJoinRequestViewController alloc]initWithHuddle:self.indvHuddle];
    joinRequestVC.delegate = self;
    
    [self presentPopupViewController:joinRequestVC animationType:MJPopupViewAnimationSlideBottomBottom];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    DZNSegmentedControl* control = self.segmentController.control;
    
    
    
    float heightOfTable = [self.segmentController getOccupatingHeight];
    
    float distanceFromBottomToPortrait = topPartSize - (profileImageVerticalOffsetFromTop + self.profileImage.frame.size.height);
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
    
    
    
    if(scrollView.contentOffset.y>distanceFromBottomToPortrait)
    {
        [self.view bringSubviewToFront:self.scrollView];
        
    }
    else
    {
        [self.view bringSubviewToFront:self.profileImage];
        [self.view bringSubviewToFront:self.requestToJoinButton];
        [self.view bringSubviewToFront:self.inviteToStudyButton];
    }
    
    float distanceFromSegmentToTop = distanceFromBottomToPortrait + self.profileImage.frame.size.height + profileImageVerticalOffsetFromTop;
    
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

#pragma mark - Popup delegate methods

- (void)cancelTapped
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
}



@end
