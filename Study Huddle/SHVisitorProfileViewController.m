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


@interface SHVisitorProfileViewController () <UIScrollViewDelegate>


@property (strong, nonatomic) SHVisitorProfileSegmentViewController *segmentController;
@property UIView *segmentContainer;
@property UIScrollView* scrollView;

@property (nonatomic, strong) Student *profStudent;

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
        
        
    }
    return self;
}

- (void)setStudent:(Student *)aProfStudent
{
    
    _profStudent = aProfStudent;
    
    [self.segmentController setStudent:aProfStudent];
    [self.profileImage setStudent:aProfStudent];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    //important coordinates
    float centerX = self.view.bounds.origin.x + self.view.bounds.size.width/2;
    
    float bottomOfNavBar = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
    //float middleHeight = (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height)/2;
    
    //background
    UIImageView* backGroundImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    [backGroundImg setFrame:self.view.frame];
    [self.view addSubview:backGroundImg];
    
    
    
    
    //set up portrait view
    CGRect profileFrame = CGRectMake(centerX-profileImageWidth/2, bottomOfNavBar + profileImageVerticalOffsetFromTop, profileImageWidth, profileImageHeight);
    
    //set up name label
    self.fullNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(centerX - fullNameWidth/2,profileFrame.origin.y + profileFrame.size.height + fullNameLabelVerticalOffsetFromPicture, fullNameWidth, fullNameHeight)];
    self.fullNameLabel.text = [self.profStudent.fullName uppercaseString];
    [self.fullNameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.fullNameLabel setFont: nameLabelFont];
    [self.fullNameLabel setTextColor:[UIColor grayColor]];
    [self.view addSubview:self.fullNameLabel];
    
    //set up major label
    self.majorLabel = [[UILabel alloc]initWithFrame:CGRectMake(centerX - majorLabelWidth/2,self.fullNameLabel.frame.origin.y + self.fullNameLabel.frame.size.height + majorLabelVerticalOffsetFromName, majorLabelWidth, majorLabelHeight)];
    self.majorLabel.text = [self.profStudent.major uppercaseString];
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
    CGRect scrollViewFrame = CGRectMake(self.view.bounds.origin.x, bottomOfNavBar, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.frame.size.height);
    self.scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    //self.scrollView.backgroundColor = [UIColor redColor];
    self.scrollView.delegate = self;
    CGSize sViewContentSize = scrollViewFrame.size;
    float heightOfTop = (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height)/2;
    sViewContentSize.height+=heightOfTop + 9999;
    [self.scrollView setContentSize:sViewContentSize];
    [self.view addSubview:self.scrollView];
    
    
    
    //set up segmented view
    self.segmentContainer = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.scrollView.bounds.origin.y + topPartSize, self.view.frame.size.width, self.view.frame.size.height*10)];
    self.segmentContainer.backgroundColor = [UIColor clearColor];
    self.segmentController = [[SHVisitorProfileSegmentViewController alloc]initWithStudent:(Student *)self.profStudent];
    
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
    SHStudyInviteViewController *studyInviteVC = [[SHStudyInviteViewController alloc]initWithFromStudent:[Student currentUser] toStudent:self.profStudent];
    studyInviteVC.owner = self;
    
    [self presentPopupViewController:studyInviteVC animationType:MJPopupViewAnimationSlideBottomBottom];
}

-(void)inviteToHuddlePressed
{
    SHHuddleInviteViewController *huddleInviteVC = [[SHHuddleInviteViewController alloc]initWithToStudent:self.profStudent fromStudent:[Student currentUser]];
    
    [self presentPopupViewController:huddleInviteVC animationType:MJPopupViewAnimationSlideBottomBottom];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    float distanceFromBottomToPortrait = topPartSize - (profileImageVerticalOffsetFromTop + self.profileImage.frame.size.height);
    
    
    
    if(scrollView.contentOffset.y>distanceFromBottomToPortrait)
    {
        [self.view bringSubviewToFront:self.scrollView];
        
    }
    else
    {
        [self.view bringSubviewToFront:self.profileImage];
        [self.view bringSubviewToFront:self.inviteToStudyButton];
        [self.view bringSubviewToFront:self.inviteToHuddleButton];
    }
    
    
    if(self.scrollView.contentOffset.y > distanceFromBottomToPortrait + self.profileImage.frame.size.height + profileImageVerticalOffsetFromTop )
    {
        NSLog(@"its at the top");
        [self.segmentController.tableView setScrollEnabled:YES];
        [self.scrollView setContentOffset:CGPointMake(0, distanceFromBottomToPortrait + self.profileImage.frame.size.height + profileImageVerticalOffsetFromTop)];
        [self.scrollView setScrollEnabled:NO];
        //[self.scrollView setBounces:NO];
    }
    
    if(self.scrollView.contentOffset.y<0)
    {
        NSLog(@"it moved down!!");
        //[self.segmentController loadStudentData];
    }
    
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
