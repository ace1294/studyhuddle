//
//  SHNotificationViewController.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/30/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHNotificationViewController.h"
#import "SHNotificationSegmentViewController.h"



@interface SHNotificationViewController ()

@property (nonatomic,strong) Student* studentObj;
@property (nonatomic,strong) SHNotificationSegmentViewController* segmentController;
@property (nonatomic,strong) UIView* segmentContainer;

@end

@implementation SHNotificationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithStudent:(Student*) aStudent
{
    self = [super init];
    if (self) {
        self.studentObj = aStudent;
        
        self.title = @"Notifications";
        self.tabBarItem.image = [UIImage imageNamed:@"notification.png"];
        
        
        //set up the navigation options
        //settings button
        
        
    }
    return self;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    float bottomOfNavBar = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;

    
    self.segmentContainer = [[UIView alloc]initWithFrame:CGRectMake(0, bottomOfNavBar+10, self.view.frame.size.width, self.view.frame.size.height)];
    self.segmentContainer.backgroundColor = [UIColor clearColor];
    
    self.segmentController = [[SHNotificationSegmentViewController alloc]initWithStudent:self.studentObj];
    [self addChildViewController:self.segmentController];
    
    self.segmentController.view.frame = self.segmentContainer.bounds;
    self.segmentContainer.backgroundColor = [UIColor whiteColor];
    [self.segmentContainer addSubview:self.segmentController.view];
    [self.segmentController didMoveToParentViewController:self];
    self.segmentController.owner = self;
    
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
