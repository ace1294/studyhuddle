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
#import "SHIndividualHuddleviewController.h"
#import "UIViewController+MJPopupViewController.h"

@interface SHHuddleViewController () <UITableViewDataSource, UITableViewDelegate, SHHuddlePageCellDelegate, SHModalViewControllerDelegate>

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
        
        self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
        
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shBackground.png"]];
        [tempImageView setFrame:self.tableView.frame];
        
        [self.tableView setBackgroundColor:[UIColor clearColor]];
        self.tableView.backgroundView = tempImageView;
        
        
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
    
    cell.backgroundColor = [UIColor clearColor];
    [cell.mainView setBackgroundColor:[UIColor clearColor]];

    
    return cell;
    
}

- (void)didTapTitleCell:(SHHuddlePageCell *)cell
{
    SHIndividualHuddleviewController *huddleVC = [[SHIndividualHuddleviewController alloc]initWithHuddle:cell.huddle];
    
    [self.navigationController pushViewController:huddleVC animated:YES];
}

#pragma mark - Huddle Page Cell Deleagte Methods



- (void)didTapInviteToStudy:(PFObject *)huddle
{
    //SHStudyInviteViewController *studyInviteVC = [[SHStudyInviteViewController alloc]init]
}

-(void)didTapAddResource:(PFObject *)huddle
{
    SHNewResourceViewController *newResourceVC = [[SHNewResourceViewController alloc]initWithHuddle:huddle];
    newResourceVC.delegate = self;
    
    [self presentPopupViewController:newResourceVC animationType:MJPopupViewAnimationSlideBottomBottom dismissed:^{
        //
    }];
    
}

- (void)didTapMember:(PFObject *)member
{
    SHVisitorProfileViewController *visitorVC = [[SHVisitorProfileViewController alloc]initWithStudent:(Student *)member];
    
    [self.navigationController pushViewController:visitorVC animated:YES];
    
}

#pragma mark - Popup delegate methods

- (void)cancelTapped
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
}


@end
