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
#import "SHVisitorProfileViewController.h"
#import "SHIndividualHuddleViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "SHHuddleAddViewController.h"
#import "WYPopoverController.h"
#import "SHNewHuddleViewController.h"
#import "UIColor+HuddleColors.h"
#import "SHCache.h"

@interface SHHuddleViewController () <UITableViewDataSource, UITableViewDelegate, SHHuddlePageCellDelegate, SHModalViewControllerDelegate, SHHuddleAddDelegate, WYPopoverControllerDelegate>
{
    WYPopoverController* popoverController;
}

@property (strong, nonatomic) Student* student;
@property (strong, nonatomic) NSMutableArray *huddles;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIBarButtonItem *addButton;

@end

@implementation SHHuddleViewController

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
        self.huddles = [NSMutableArray arrayWithArray:[[SHCache sharedCache] huddles]];
        
        self.title = @"Huddles";
        self.tabBarItem.image = [UIImage imageNamed:@"huddles.png"];
        
        self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
        
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shBackground.png"]];
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
    [super viewWillAppear:animated];
    [self.student refresh];
    [self.tableView reloadData];
}


#pragma mark - UITableViewDelegate Methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *curHuddle = self.huddles[indexPath.row];
    
    if ([[[SHCache sharedCache]membersForHuddle:curHuddle]count]>5) {
        return SHHuddlePageCellHeight + 60;
    }

    return SHHuddlePageCellHeight;
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
    
    if(!cell)
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

#pragma mark - SHHuddlePageCellDelegate Methods

- (void)didTapTitleCell:(SHHuddlePageCell *)cell
{
    SHIndividualHuddleViewController *huddleVC = [[SHIndividualHuddleViewController alloc]initWithHuddle:cell.huddle];
    
    [self.navigationController pushViewController:huddleVC animated:YES];
}

- (void)addHuddleTapped
{
    SHNewHuddleViewController *newHuddleVC = [[SHNewHuddleViewController alloc]initWithStudent:[Student currentUser]];
    
    [popoverController dismissPopoverAnimated:YES completion:^{
        [self.navigationController pushViewController:newHuddleVC animated:YES];
    }];
    
    
}

- (void)didTapInviteToStudy:(PFObject *)huddle
{
    
}

- (void)didTapAddResource:(PFObject *)huddle
{
    
}

- (void)didTapMember:(PFUser *)member
{
    SHVisitorProfileViewController *visitorVC = [[SHVisitorProfileViewController alloc]initWithStudent:(Student *)member];
    
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
