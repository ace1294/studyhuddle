//
//  SHIndividualHuddleviewController.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/25/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHIndividualHuddleviewController.h"
#import "UIColor+HuddleColors.h"
#import "SHHuddleSegmentViewController.h"



#define schoolLabelWidth 85
#define schoolLabelHeight 21
#define schoolLabelFont [UIFont systemFontOfSize:7]



#define nameLabelWidth 150
#define nameLabelHeight 21
#define nameLabelFont [UIFont systemFontOfSize:17]


#define profileImageWidth 100
#define profileImageHeight 100

#define editProfileButtonWidth 50
#define editProfileButtonHeight 10
#define editPorifleButtonVerticalOffsetFromTop 10
#define editProfileButtonFont [UIFont systemFontOfSize:7]
#define editProfileButtonColor [UIColor whiteColor]
#define editProfileCornerRadius 1


#define profileImageVerticalOffsetFromTop 10
#define nameLabelVerticalOffsetFromImage 10
#define infoLabelsVerticalOffsetFromNameLabel 1
#define horizontalOffsetFromEdge 30


@interface SHIndividualHuddleviewController ()

@property PFObject* huddle;
@property UILabel* huddleNameLabel;
@property SHCreateHuddlePortraitView* portraitView;
@property (nonatomic, strong) SHHuddleSegmentViewController *segmentController;
@property (nonatomic, strong) UIView *segmentContainer;

@end

@implementation SHIndividualHuddleviewController


-(id)initWithHuddle: (PFObject*) huddle
{
    NSLog(@"initWithHuddle called");
    self = [super init];
    if(self)
    {
        NSLog(@"made it inside if(self)");
        self.huddle = huddle;
        NSLog(@"huddle: %@",self.huddle);
        
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    float centerX = self.view.bounds.origin.x + self.view.bounds.size.width/2;
    
    //background
    UIImageView* backGroundImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    [backGroundImg setFrame:self.view.frame];
    [self.view addSubview:backGroundImg];
    
    //portrait setup
    self.portraitView = [[SHCreateHuddlePortraitView alloc]initWithFrame:CGRectMake(centerX-profileImageWidth/2, self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height + profileImageVerticalOffsetFromTop, profileImageWidth, profileImageHeight)];
    self.portraitView.owner = self;
    [self.view addSubview:self.portraitView];
    
    
    //namelabel setup
    self.huddleNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(centerX-nameLabelWidth/2, self.portraitView.frame.origin.y + self.portraitView.frame.size.height , nameLabelWidth, nameLabelHeight)];
    self.huddleNameLabel.text = [self.huddle objectForKey:@"huddleName"];
    [self.huddleNameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.huddleNameLabel];
    
    //set up segmented view
    self.segmentContainer = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.portraitView.bounds.size.height + self.view.bounds.origin.y  , self.view.frame.size.width, self.view.frame.size.height*10)];
    self.segmentContainer.backgroundColor = [UIColor clearColor];
    self.segmentController = [[SHHuddleSegmentViewController alloc]initWithHuddle:self.huddle];
    
                              
                              
    [self addChildViewController:self.segmentController];
    self.segmentController.view.frame = self.segmentContainer.bounds;
    self.segmentContainer.backgroundColor = [UIColor whiteColor];
    [self.segmentContainer addSubview:self.segmentController.view];
    [self.segmentController didMoveToParentViewController:self];
    
    
    [self.view addSubview:self.segmentContainer];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
