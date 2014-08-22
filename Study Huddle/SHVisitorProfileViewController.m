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
#import "SHVisitorProfileViewController.h"
#import "SHVisitorProfileSegmentViewController.h"
#import "SHStudyInviteViewController.h"
#import "SHHuddleInviteViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "SHCache.h"


#define profileImageWidth 100
#define profileImageHeight 100
#define profileImageVerticalOffsetFromTop 10

#define fullNameLabelVerticalOffsetFromPicture 5
#define fullNameWidth 400
#define fullNameHeight 20

#define majorLabelVerticalOffsetFromName 5
#define majorLabelWidth 400
#define majorLabelHeight 20

#define hoursStudiedLabelWidth 45
#define hoursStudiedLabelHeight 30

#define sideItemDiameters 45
#define sideItemLabelsVerticalOffsetFromCircle 0
#define sideLabelsWidth 70
#define sideLabelHeight 10


#define topPartSize 170




#define nameLabelFont [UIFont boldSystemFontOfSize:15]
#define majorLabelFont [UIFont boldSystemFontOfSize:10]
#define sideItemsFont [UIFont systemFontOfSize:7]


@interface SHVisitorProfileViewController () <UIScrollViewDelegate, SHModalViewControllerDelegate>


@property (strong, nonatomic) SHVisitorProfileSegmentViewController *segmentController;
@property UIView *segmentContainer;
@property UIScrollView* scrollView;

@property (nonatomic, strong) PFUser *profStudent;

@property (nonatomic, strong) UILabel* fullNameLabel;
@property (nonatomic, strong) UILabel* majorLabel;
@property (nonatomic, strong) UILabel* collegeLabel;
@property (nonatomic,strong) UILabel* inviteToStudyLabel;

@property (nonatomic,strong) UIButton* inviteToStudyButton;
@property (nonatomic,strong) UIButton* inviteToHuddleButton;




@end

@implementation SHVisitorProfileViewController


- (id)init
{
    self = [self initWithStudent:[PFUser user]];
    
    return self;
}

- (id)initWithStudent:(PFUser *)aStudent
{
    self = [super init];
    if (self) {
        _profStudent = aStudent;
        
        self.title = @"Profile";
        self.tabBarItem.image = [UIImage imageNamed:@"profile.png"];
        
        
        //set up the navigation options
        //settings button
        
        
    }
    return self;
}

- (void)setStudent:(PFUser *)aProfStudent
{
    
    _profStudent = aProfStudent;
    
    [self.segmentController setStudent:aProfStudent];
    [self.profileImage setStudent:aProfStudent];
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
    self.fullNameLabel.text = [self.profStudent[SHStudentNameKey] uppercaseString];
    [self.fullNameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.fullNameLabel setFont: nameLabelFont];
    [self.fullNameLabel setTextColor:[UIColor grayColor]];
    [self.view addSubview:self.fullNameLabel];
    
    //set up major label
    self.majorLabel = [[UILabel alloc]initWithFrame:CGRectMake(centerX - majorLabelWidth/2,self.fullNameLabel.frame.origin.y + self.fullNameLabel.frame.size.height + majorLabelVerticalOffsetFromName, majorLabelWidth, majorLabelHeight)];
    self.majorLabel.text = [self.profStudent[SHStudentMajorKey] uppercaseString];
    [self.majorLabel setTextAlignment:NSTextAlignmentCenter];
    [self.majorLabel setFont: majorLabelFont];
    [self.majorLabel setTextColor:[UIColor grayColor]];
    [self.view addSubview:self.majorLabel];
    
    //set up the side items
    float leftPictureEdge = profileFrame.origin.x;
    float rightPictureEdge = leftPictureEdge + profileFrame.size.width;
    float leftMidPoint = leftPictureEdge/2-sideItemDiameters/2;
    float rightMidPoint = rightPictureEdge + leftMidPoint;
    float midYPoint = profileFrame.origin.y + profileFrame.size.height/2 - sideItemDiameters/2;
    //invite to study button setup
    self.inviteToStudyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.inviteToStudyButton addTarget:self action:@selector(inviteToStudyPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.inviteToStudyButton setFrame:CGRectMake(leftMidPoint, midYPoint, sideItemDiameters, sideItemDiameters)];
    [self.inviteToStudyButton setImage:[UIImage imageNamed:@"inviteToStudy.png"] forState:UIControlStateNormal];
    //[self.startStudyingButton setBackgroundColor:[UIColor yellowColor]];
    self.inviteToStudyLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.inviteToStudyButton.frame.origin.x + self.inviteToStudyButton.frame.size.width/2 - sideLabelsWidth/2, self.inviteToStudyButton.frame.origin.y + self.inviteToStudyButton.frame.size.height + sideItemLabelsVerticalOffsetFromCircle, sideLabelsWidth, sideLabelHeight)];
    self.inviteToStudyLabel.text = @"INVITE TO STUDY";
    [self.inviteToStudyLabel setTextAlignment:NSTextAlignmentCenter];
    [self.inviteToStudyLabel setFont:sideItemsFont];
    // [self.startStudyingLabel setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:self.inviteToStudyLabel];
    //invite to Huddle button setup
    self.inviteToHuddleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.inviteToHuddleButton addTarget:self action:@selector(inviteToHuddlePressed) forControlEvents:UIControlEventTouchUpInside];
    [self.inviteToHuddleButton setFrame:CGRectMake(rightMidPoint, midYPoint, sideItemDiameters, sideItemDiameters)];
    [self.inviteToHuddleButton setImage:[UIImage imageNamed:@"inviteToHuddle.png"] forState:UIControlStateNormal];

    
    UILabel* inviteToHuddleLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.inviteToHuddleButton.frame.origin.x+ self.inviteToHuddleButton.frame.size.width/2 - sideLabelsWidth/2, self.inviteToHuddleButton.frame.origin.y + self.inviteToHuddleButton.frame.size.height + sideItemLabelsVerticalOffsetFromCircle, sideLabelsWidth, sideLabelHeight)];
    inviteToHuddleLabel.text = @"INVITE TO HUDDLE";
    [inviteToHuddleLabel setTextAlignment:NSTextAlignmentCenter];
    [inviteToHuddleLabel setFont:sideItemsFont];
    //[self.startStudyingLabel setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:inviteToHuddleLabel];
    
    
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
    self.segmentController = [[SHVisitorProfileSegmentViewController alloc]initWithStudent:self.profStudent];
    
    [self addChildViewController:self.segmentController];
    self.segmentController.view.frame = self.segmentContainer.bounds;
    self.segmentContainer.backgroundColor = [UIColor whiteColor];
    [self.segmentContainer addSubview:self.segmentController.view];
    [self.segmentController didMoveToParentViewController:self];
    self.segmentController.owner = self;
    [self.scrollView addSubview:self.segmentContainer];
    self.segmentController.parentScrollView = self.scrollView;
    
    
    self.profileImage = [[SHProfilePortraitView alloc]initWithFrame:profileFrame];
    self.profileImage.owner = self;
    self.profileImage.isClickable = NO;
    [self.profileImage setStudent:self.profStudent];
    
 
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.profileImage];
    [self.view addSubview:self.inviteToHuddleButton];
    [self.view addSubview:self.inviteToStudyButton];

    

    
}

-(void)inviteToStudyPressed
{
    
    //check if he already sent a request
    NSArray* sentRequests = [[SHCache sharedCache] sentRequests];
    for(PFObject* request in sentRequests)
    {
        [request fetchIfNeeded];
        if([request[SHRequestTypeKey] isEqualToString:SHRequestSSInviteStudy] && [[request[SHRequestToStudentKey] objectId] isEqualToString:[self.profStudent objectId]])
        {
            [self showAlert];
            return;
        }
    }
    
    SHStudyInviteViewController *studyInviteVC = [[SHStudyInviteViewController alloc]initWithFromStudent:[PFUser currentUser] toStudent:self.profStudent];
    studyInviteVC.owner = self;
    studyInviteVC.delegate = self;
    
    [self presentPopupViewController:studyInviteVC animationType:MJPopupViewAnimationSlideBottomBottom dismissed:^{
        NSLog(@"HERHEHREHRHERHEHRL:KSJDFL:KJSDLFJSDF");
    }];
    
    
}

-(void)inviteToHuddlePressed
{
    

    //check if he already sent a request
    NSArray* sentRequests = [[SHCache sharedCache] sentRequests];
    for(PFObject* request in sentRequests)
    {
        [request fetchIfNeeded];
        if([request[SHRequestTypeKey] isEqualToString:SHRequestHSJoin] && [[request[SHRequestToStudentKey] objectId] isEqualToString:[self.profStudent objectId]])
        {
            [self showAlert];
            return;
        }
    }
    
    SHHuddleInviteViewController *huddleInviteVC = [[SHHuddleInviteViewController alloc]initWithToStudent:self.profStudent fromStudent:[PFUser currentUser]];
    huddleInviteVC.delegate = self;
    
    [self presentPopupViewController:huddleInviteVC animationType:MJPopupViewAnimationSlideBottomBottom];
}

-(void)showAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Wait!"
                                                    message: @"You already sent him a request"
                                                   delegate: nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
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
        [self.view bringSubviewToFront:self.inviteToHuddleButton];
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

#pragma mark - Modal Delgate

- (void)cancelTapped
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
}



@end
