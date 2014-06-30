//
//  SHClassPageViewController.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/29/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHClassPageViewController.h"
#import "SHClassSegmentViewController.h"

#define topPartSize 170


@interface SHClassPageViewController ()

@property (nonatomic,strong) PFObject* classObj;
@property (nonatomic,strong) SHClassSegmentViewController* segmentController;
@property (nonatomic,strong) UIView* segmentContainer;
@property (nonatomic,strong) UIScrollView* scrollView;

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
        
        self.title = @"Class";
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
    UIImageView* backGroundImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    [backGroundImg setFrame:self.view.frame];
    [self.view addSubview:backGroundImg];
    
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
    self.segmentController = [[SHClassSegmentViewController alloc]initWithClass:self.classObj];
    
    [self addChildViewController:self.segmentController];
    self.segmentController.view.frame = self.segmentContainer.bounds;
    self.segmentContainer.backgroundColor = [UIColor whiteColor];
    [self.segmentContainer addSubview:self.segmentController.view];
    [self.segmentController didMoveToParentViewController:self];
    self.segmentController.owner = self;
    [self.scrollView addSubview:self.segmentContainer];
    self.segmentController.parentScrollView = self.scrollView;
    
    
    
    
    
    [self.view addSubview:self.scrollView];

    

    
    
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
