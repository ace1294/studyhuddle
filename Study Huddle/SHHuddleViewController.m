//
//  SHHuddleViewController.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/25/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHHuddleViewController.h"
#import "SHHuddlePageCell.h"
#import "SHConstants.h"

@interface SHHuddleViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Student* student;
@property (strong, nonatomic) NSMutableArray *huddles;

@property (strong, nonatomic) UITableView *tableView;

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
        self.huddles = aStudent[SHStudentHuddlesKey];
        
        self.title = @"Huddles";
        self.tabBarItem.image = [UIImage imageNamed:@"huddles.png"];
        
        
        //set up the navigation options
        
        //settings button
        UIBarButtonItem* settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(settingsPressed)];
        UIImage* cogWheelImg = [UIImage imageNamed:@"cogwheel.png"];
        [settingsButton setImage:cogWheelImg];
        settingsButton.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = settingsButton;
        
        self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
        
        
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
    
}


#pragma mark - UITableViewDelegate Methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *curHuddle = self.huddles[indexPath.row];
    [curHuddle fetchIfNeeded];
    
    if ([[curHuddle objectForKey:SHHuddleMembersKey]count]>5) {
        return SHHuddlePageCellHeight + 60;
    }
    
    
    
    return SHHuddlePageCellHeight;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.huddles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHHuddlePageCell *cell = [tableView dequeueReusableCellWithIdentifier:SHHuddlePageCellIdentifier];
    
    if(!cell)
        cell = [[SHHuddlePageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SHHuddlePageCellIdentifier];
    
    cell.delegate = self;
    PFObject *huddleObject = [self.huddles objectAtIndex:indexPath.row];
    
    [huddleObject fetchIfNeeded];
     
    [cell setHuddle:huddleObject];
    
    
    
    
    return cell;
    
}

- (void)didTapTitleCell:(SHHuddlePageCell *)cell
{
    if ([cell isKindOfClass:[SHHuddlePageCell class]] ) {
    }
    
}


@end
