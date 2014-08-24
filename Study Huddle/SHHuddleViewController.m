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
#import "SHStudyInviteViewController.h"
#import "SHNewResourceViewController.h"
#import "SHHuddleStartStudyingViewController.h"
#import "SHVisitorProfileViewController.h"
#import "SHIndividualHuddleViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "SHHuddleAddViewController.h"
#import "WYPopoverController.h"
#import "SHNewHuddleViewController.h"
#import "UIColor+HuddleColors.h"
#import "SHCache.h"
#import "MBProgressHUD.h"

@interface SHHuddleViewController () <UITableViewDataSource, UITableViewDelegate, SHHuddlePageCellDelegate, SHModalViewControllerDelegate, SHHuddleAddDelegate, WYPopoverControllerDelegate,MBProgressHUDDelegate>
{
    WYPopoverController* popoverController;
}

@property (strong, nonatomic) PFUser* student;
@property (strong, nonatomic) NSMutableArray *huddles;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIBarButtonItem *addButton;

@end

@implementation SHHuddleViewController

- (id)init
{
    self = [self initWithStudent:[PFUser currentUser]];
    return self;
}

- (id)initWithStudent:(PFUser *)aStudent
{
    self = [super init];
    if (self) {
        self.student = aStudent;
        
        self.title = @"Huddles";
        self.navigationController.title = @"Huddles";
        self.tabBarItem.image = [UIImage imageNamed:@"NavHuddle.png"];
        
        self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
        
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PatternBackground.png"]];
        [tempImageView setFrame:self.tableView.frame];
        
        [self.tableView setBackgroundColor:[UIColor clearColor]];
        self.tableView.backgroundView = tempImageView;
        
        //Edit Button
        self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                   target:self
                                                                                   action:@selector(addItem)];
        
        self.navigationItem.rightBarButtonItem = self.addButton;
        
        
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
    
    self.huddles = [NSMutableArray arrayWithArray:[[SHCache sharedCache] huddles]];
    
    SHHuddleAddViewController *addVC = [[SHHuddleAddViewController alloc]init];
    [addVC.view setFrame:CGRectMake(305, 55.0, 100.0, 40.0)];
    addVC.preferredContentSize = CGSizeMake(120, 40);
    addVC.delegate = self;
    popoverController = [[WYPopoverController alloc]initWithContentViewController:addVC];
    popoverController.delegate = self;
    [WYPopoverController setDefaultTheme:[WYPopoverTheme theme]];
    
    WYPopoverBackgroundView *appearance = [WYPopoverBackgroundView appearance];
    [appearance setTintColor:[UIColor huddleSilver]];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.title = @"Huddles";
    
    [super viewWillAppear:animated];
    
    [self.huddles removeAllObjects];
    self.huddles = [NSMutableArray arrayWithArray:[[SHCache sharedCache] huddles]];
    
    [self.tableView reloadData];
    
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
	//MBProgressHUD* HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	//[self.navigationController.view addSubview:HUD];
	
	// Regiser for HUD callbacks so we can remove it from the window at the right time
	//HUD.delegate = self;
	
	// Show the HUD while the provided method executes in a new thread
	//[HUD showWhileExecuting:@selector(refreshSetup) onTarget:self withObject:nil animated:YES];

   
}

-(void)refreshSetup
{
    [self.student refresh];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate Methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *curHuddle = self.huddles[indexPath.row];
    
    if ([[[SHCache sharedCache]membersForHuddle:curHuddle]count]>5)
        return SHHuddlePageCellHeight + 60;
    else if ([[[SHCache sharedCache]membersForHuddle:curHuddle]count]>0)
        return SHHuddlePageCellHeight;

    return SHHuddlePageCellHeight - 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SHIndividualHuddleViewController *huddleVC = [[SHIndividualHuddleViewController alloc]initWithHuddle:self.huddles[indexPath.row]];
    
    [self.navigationController pushViewController:huddleVC animated:YES];
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
    
    
    cell = [[SHHuddlePageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SHHuddlePageCellIdentifier];
    
    cell.delegate = self;
    PFObject *huddleObject = [self.huddles objectAtIndex:indexPath.row];
     
    [cell setHuddle:huddleObject];
    
    cell.backgroundColor = [UIColor clearColor];
    [cell.mainView setBackgroundColor:[UIColor clearColor]];

    
    return cell;
    
}

#pragma mark - Actions

- (void)addItem
{
    [popoverController presentPopoverFromBarButtonItem:self.addButton permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
}

#pragma mark - HuddleAddViewControllerDelgate Methods

- (void)addHuddleTapped
{
    SHNewHuddleViewController *newHuddleVC = [[SHNewHuddleViewController alloc]initWithStudent:[PFUser currentUser]];
    
    [popoverController dismissPopoverAnimated:YES completion:^{
        [self.navigationController pushViewController:newHuddleVC animated:YES];
    }];
    
    
}

#pragma mark - SHHuddlePageCellDelegate Methods

- (void)didTapTitleCell:(SHHuddlePageCell *)cell
{
    SHIndividualHuddleViewController *huddleVC = [[SHIndividualHuddleViewController alloc]initWithHuddle:cell.huddle];
    
    [self.navigationController pushViewController:huddleVC animated:YES];
}

- (void)didTapInviteToStudy:(PFObject *)huddle
{
    SHIndividualHuddleViewController *huddleVC = [[SHIndividualHuddleViewController alloc]initWithHuddle:huddle];
    SHHuddleStartStudyingViewController *huddleStudyingVC = [[SHHuddleStartStudyingViewController alloc]initWithHuddle:huddle];
    huddleStudyingVC.delegate = huddleVC;
    
    [self presentPopupViewController:huddleStudyingVC animationType:MJPopupViewAnimationSlideBottomBottom dismissed:^{
        [self.navigationController pushViewController:huddleVC animated:YES];
    }];
}

- (void)didTapAddResource:(PFObject *)huddle
{
    SHNewResourceViewController *resourceVC = [[SHNewResourceViewController alloc]initWithHuddle:huddle];
    resourceVC.delegate = self;
    
    [self presentPopupViewController:resourceVC animationType:MJPopupViewAnimationSlideBottomBottom];
    
}

- (void)didTapMember:(PFUser *)member
{
    SHVisitorProfileViewController *visitorVC = [[SHVisitorProfileViewController alloc]initWithStudent:member];
    
    [self.navigationController pushViewController:visitorVC animated:YES];
}


#pragma mark - Popoover Delegate Methods

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)controller
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)controller
{
    //popoverController.delegate = nil;
    //popoverController = nil;
}


#pragma mark - Popup delegate methods

- (void)cancelTapped
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
    
}


@end
