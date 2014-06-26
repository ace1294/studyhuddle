//
//  SHHuddleViewController.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/25/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHHuddleViewController.h"

@interface SHHuddleViewController ()

@property Student* student;

@end

@implementation SHHuddleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [self initWithStudent:(Student *)[PFUser currentUser]];
    return self;
}

- (id)initWithStudent:(Student *)aStudent
{
    self = [super init];
    if (self) {
        self.student = aStudent;
        
        self.title = @"Huddles";
        self.tabBarItem.image = [UIImage imageNamed:@"huddles.png"];
        
        
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

-(void)settingsPressed
{
    NSLog(@"settings pressed");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
