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
#import "SHProfileSegmentViewController.h"
#import "SHStartStudyingViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "SHUtility.h"

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


@interface SHProfileViewController () <UIScrollViewDelegate, SHStartStudyingDelegate>


@property (strong, nonatomic) SHProfileSegmentViewController *segmentController;
@property UIView *segmentContainer;
@property UIScrollView* scrollView;

@property (nonatomic, strong) Student *profStudent;

@property (nonatomic, strong) UILabel* fullNameLabel;
@property (nonatomic, strong) UILabel* majorLabel;
@property (nonatomic, strong) UILabel* hoursStudiedLabel;
@property (nonatomic, strong) UILabel* collegeLabel;
@property (nonatomic,strong) UILabel* startStudyingLabel;

@property (nonatomic, strong) SHStartStudyingViewController *startStudyingVC;
@property (nonatomic, strong) PFObject *study;

@property (nonatomic,strong) UIButton* startStudyingButton;
@property BOOL isStudying;
@property BOOL didContinue; //if when the study pop up showed, the user pressed continue

@property (nonatomic,strong) NSDate* lastStart;

@property float previousOffset;


@end

@implementation SHProfileViewController

- (id)initWithStudent:(Student *)aStudent
{
    self = [super init];
    if (self) {
        _profStudent = aStudent;
        [_profStudent refresh];
        self.title = @"Profile";
        self.tabBarItem.image = [UIImage imageNamed:@"profile.png"];
     
        
    }
    return self;
}

-(id) init
{
    self = [super init];
    if(self)
    {
        self.title = @"Profile";
        self.tabBarItem.image = [UIImage imageNamed:@"profile.png"];

    }
    return self;
}

- (void)setStudent:(Student *)aProfStudent
{
    
    _profStudent = aProfStudent;
    [_profStudent refresh];
    [self.segmentController setStudent:aProfStudent];
    [self.profileImage setStudent:aProfStudent];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    

    //register for the continueNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activateStudy) name:@"studySuccess" object:nil] ;
    
    
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
    self.startStudyingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.startStudyingButton addTarget:self action:@selector(setStudy) forControlEvents:UIControlEventTouchUpInside];
    [self.startStudyingButton setFrame:CGRectMake(leftMidPoint, midYPoint, sideItemDiameters, sideItemDiameters)];
    [self.startStudyingButton setImage:[UIImage imageNamed:@"startStudying.png"] forState:UIControlStateNormal];
   //[self.startStudyingButton setBackgroundColor:[UIColor yellowColor]];
    self.startStudyingLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.startStudyingButton.frame.origin.x + self.startStudyingButton.frame.size.width/2 - sideLabelsWidth/2, self.startStudyingButton.frame.origin.y + self.startStudyingButton.frame.size.height + sideItemLabelsVerticalOffsetFromCircle, sideLabelsWidth, sideLabelHeight)];
    self.startStudyingLabel.text = @"START STUDYING";
    [self.startStudyingLabel setTextAlignment:NSTextAlignmentCenter];
    [self.startStudyingLabel setFont:sideItemsFont];
   // [self.startStudyingLabel setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:self.startStudyingLabel];

    
    UIImageView* hoursStudiedCircle = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hoursStudying.png"]];
    [hoursStudiedCircle setFrame:CGRectMake(rightMidPoint, midYPoint, sideItemDiameters, sideItemDiameters)];
    [self.view addSubview:hoursStudiedCircle];
    
    //a label to display the #hours studied
    self.hoursStudiedLabel = [[UILabel alloc]initWithFrame:CGRectMake(hoursStudiedCircle.frame.origin.x + hoursStudiedCircle.frame.size.width/2 - hoursStudiedLabelWidth/2, hoursStudiedCircle.frame.origin.y + hoursStudiedCircle.frame.size.height/2 - hoursStudiedLabelHeight/2, hoursStudiedLabelWidth, hoursStudiedLabelHeight)];
    double secondsStudied = [self.profStudent.hoursStudied doubleValue];
    int hoursStudied = secondsStudied/3600;
    self.hoursStudiedLabel.text = [NSString stringWithFormat:@"%d",hoursStudied];
    [self.hoursStudiedLabel setTextAlignment:NSTextAlignmentCenter];
    [self.hoursStudiedLabel setTextColor:[UIColor grayColor]];
    [self.view addSubview:self.hoursStudiedLabel];
    
    UILabel* hoursStudiedBelowLabel =[[UILabel alloc]initWithFrame:CGRectMake(hoursStudiedCircle.frame.origin.x+ hoursStudiedCircle.frame.size.width/2 - sideLabelsWidth/2, hoursStudiedCircle.frame.origin.y + hoursStudiedCircle.frame.size.height + sideItemLabelsVerticalOffsetFromCircle, sideLabelsWidth, sideLabelHeight)];
    hoursStudiedBelowLabel.text = @"HOURS STUDIED";
    [hoursStudiedBelowLabel setTextAlignment:NSTextAlignmentCenter];
    [hoursStudiedBelowLabel setFont:sideItemsFont];
    //[self.startStudyingLabel setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:hoursStudiedBelowLabel];

    
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
    [self.segmentContainer setBackgroundColor:[UIColor blueColor]];
    self.segmentController = [[SHProfileSegmentViewController alloc]initWithStudent:(Student *)self.profStudent];
    [self.navigationController setDelegate:self.segmentController];
    
    [self addChildViewController:self.segmentController];
    self.segmentController.view.frame = self.segmentContainer.bounds;
    self.segmentContainer.backgroundColor = [UIColor clearColor];
    [self.segmentContainer addSubview:self.segmentController.view];
    [self.segmentController didMoveToParentViewController:self];
    self.segmentController.owner = self;
    [self.scrollView addSubview:self.segmentContainer];
    self.segmentController.parentScrollView = self.scrollView;

    
    self.profileImage = [[SHProfilePortraitView alloc]initWithFrame:profileFrame];
    self.profileImage.owner = self;
    [self.profileImage setStudent:self.profStudent];
    
    //add it in the right order
    //[self.view addSubview:extendedBG];
    
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.profileImage];
    [self.view addSubview:self.startStudyingButton];
    
    //get the last study date
    self.lastStart = self.profStudent[SHStudentLastStartKey];
    
    
  
    
    //set timer
    [self updateHoursStudied];
    [NSTimer scheduledTimerWithTimeInterval:60
                                     target:self
                                   selector:@selector(updateHoursStudied)
                                   userInfo:nil
                                    repeats:YES];
    
    
}

-(void)updateHoursStudied
{

    if(self.isStudying)
    {
        NSDate* date = [NSDate date];
        NSTimeInterval diff = [date timeIntervalSinceDate:self.lastStart];

        self.lastStart = date;
        self.profStudent[SHStudentLastStartKey] = date;
        NSString* hoursPrevStudied = self.profStudent.hoursStudied;
        double previousTimeStudied = [hoursPrevStudied doubleValue];
        double secondsStudied = diff + previousTimeStudied;
        int hoursStudied = secondsStudied/3600;
        self.hoursStudiedLabel.text = [NSString stringWithFormat:@"%d",hoursStudied];

        self.profStudent.hoursStudied = [NSString stringWithFormat:@"%f",(diff+previousTimeStudied)];
        [self.profStudent save];

    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setNavigationBarItems];
    self.isStudying = [self.profStudent[@"isStudying"] boolValue];
    //update the studying button
    if(self.isStudying)
    {
        [self.startStudyingButton setImage:[UIImage imageNamed:@"stopStudying.png"] forState:UIControlStateNormal];
        [self.startStudyingLabel setTextColor:[UIColor redColor]];
        self.startStudyingLabel.text = @"STOP STUDYING";
    }
    else
    {
        [self.startStudyingButton setImage:[UIImage imageNamed:@"startStudying.png"] forState:UIControlStateNormal];
        [self.startStudyingLabel setTextColor:[UIColor greenColor]];
        self.startStudyingLabel.text = @"START STUDYING";
    }
    
    [self.segmentController loadStudentData];
    
}

-(void)setStudy
{
    [self updateHoursStudied];
    if(self.isStudying)
    {
        //the user will stop their studying session
        self.profStudent[@"isStudying"] = [NSNumber numberWithBool:false];
        //[self.profStudent save];
        self.isStudying =   NO;
        [self.startStudyingButton setImage:[UIImage imageNamed:@"startStudying.png"] forState:UIControlStateNormal];
        [self.startStudyingLabel setTextColor:[UIColor greenColor]];
        self.startStudyingLabel.text = @"START STUDYING";
        
        [self.study fetchIfNeeded];
        self.study[SHStudyOnlineKey] = [NSNumber numberWithBool:false];
        self.study[SHStudyEndKey] = [NSDate date];
        if(self.study)
        {

            [PFObject saveAll:@[self.study,self.profStudent]];
            
        }
        else
            [PFObject saveAll:@[self.profStudent]];
        
        [self.segmentController.tableView reloadData];
    }
    else
    {
        //the user will start studying
        self.study = [PFObject objectWithClassName:SHStudyParseClass];
        self.startStudyingVC = [[SHStartStudyingViewController alloc]initWithStudent:[Student currentUser] studyObject:self.study];
        self.startStudyingVC.delegate = self;
        [self presentPopupViewController:self.startStudyingVC animationType:MJPopupViewAnimationSlideBottomBottom];
        
        //check if the user actually put continue
       /* if(self.didContinue)
        {
            
            self.lastStart = [NSDate date];
            self.profStudent[SHStudentLastStartKey] = self.lastStart;
            self.profStudent[@"isStudying"] =[NSNumber numberWithBool:true];
            self.isStudying = YES;
            [self.startStudyingButton setImage:[UIImage imageNamed:@"stopStudying.png"] forState:UIControlStateNormal];
            [self.startStudyingLabel setTextColor:[UIColor redColor]];
            self.startStudyingLabel.text = @"STOP STUDYING";
            [PFObject saveAll:@[self.profStudent]];
            self.didContinue = NO;
        }*/

    }
    
   
}

-(void)activateStudy
{
    self.lastStart = [NSDate date];
    self.profStudent[SHStudentLastStartKey] = self.lastStart;
    self.profStudent[@"isStudying"] =[NSNumber numberWithBool:true];
    self.isStudying = YES;
    [self.startStudyingButton setImage:[UIImage imageNamed:@"stopStudying.png"] forState:UIControlStateNormal];
    [self.startStudyingLabel setTextColor:[UIColor redColor]];
    self.startStudyingLabel.text = @"STOP STUDYING";
    [PFObject saveAll:@[self.profStudent]];
    self.didContinue = NO;
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
        [self.view bringSubviewToFront:self.startStudyingButton];
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

-(void) settingsPressed
{
    SHProfileSettingsController* settingsController = [[SHProfileSettingsController alloc]init];
    [self.navigationController pushViewController:settingsController animated:YES];
}

-(void)setNavigationBarItems
{

    UIImage* cogWheelImg = [UIImage imageNamed:@"cogwheel.png"];
    UIBarButtonItem* settingsButton = [[UIBarButtonItem alloc]initWithImage:cogWheelImg landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:@selector(settingsPressed)];
    settingsButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = settingsButton;
    
}

#pragma mark - Popup delegate methods

- (void)cancelTapped
{
    //cancel the whole study process
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
}

- (void)startedStudying:(PFObject *)study
{
    [self.segmentController currentStudy:study];
}




@end
