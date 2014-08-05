//
//  SHUserSettingsViewController.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/17/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHPushNotificationsSetting.h"
#import <Parse/Parse.h>


#define cellHeight 50
#define switchesX 240
#define switchesY 12
#define switchesHeight 20
#define switchesWidth 40

@interface SHPushNotificationsSetting()<UITableViewDelegate,UITextFieldDelegate>


@property NSMutableArray *tableData;
@property UISwitch* memberHuddleSwitch;
@property UISwitch* huddleIsStudyingSwitch;
@property UISwitch* threadPostSwitch;
@property UISwitch* resourceAddedSwitch;
@property UISwitch* postSwitch;
@property UISwitch* memberClassSwitch;
@property UISwitch* replyToPostSwitch;

@end

@implementation SHPushNotificationsSetting

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Settings";
    PFUser* currentStudent = [PFUser currentUser];
    
    //set up the content in the dictionary
    self.tableData = [[NSMutableArray alloc]init];
    //preferences
    NSArray* huddleData = [[NSArray alloc]initWithObjects:@"New Member",@"Huddle is Studying",@"New Thread Post",@"Resource Added",nil];
    NSArray* classData = [[NSArray alloc]initWithObjects:@"New Post",@"New Member",@"Reply to Your Post", nil];
    
    [self.tableData addObject:huddleData];
    [self.tableData addObject:classData];
    
    
    //create the switches
    self.memberHuddleSwitch = [[UISwitch alloc] init];
    [self.memberHuddleSwitch setOn:[currentStudent[@"receiveNewHuddleMemberNotifications"] boolValue]];
    self.huddleIsStudyingSwitch = [[UISwitch alloc] init];
    [self.huddleIsStudyingSwitch setOn:[currentStudent[@"receiveHuddleIsStudyingNotifications"] boolValue]];
    self.threadPostSwitch = [[UISwitch alloc] init];
    [self.threadPostSwitch setOn:[currentStudent[@"receiveNewThreadPostNotifications"] boolValue]];
    self.resourceAddedSwitch = [[UISwitch alloc] init];
    [self.resourceAddedSwitch setOn:[currentStudent[@"receiveResourceAddedNotifications"] boolValue]];
    self.postSwitch = [[UISwitch alloc] init];
    [self.postSwitch setOn:[currentStudent[@"receiveNewPostNotifications"] boolValue]];
    self.memberClassSwitch = [[UISwitch alloc] init];
    [self.memberClassSwitch setOn:[currentStudent[@"receiveNewClassMemberNotifications"] boolValue]];
    self.replyToPostSwitch = [[UISwitch alloc] init];
    [self.replyToPostSwitch setOn:[currentStudent[@"receiveReplyToYourPostNotifications"] boolValue]];
    
    
    //create BackButton
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed)];
    backButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[self.tableData objectAtIndex:section]count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return @"Huddles";
    else if(section == 1)
        return @"Class";
    else
        return @"This shouldn't of happened";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSArray* itemsInGroup = [self.tableData objectAtIndex:indexPath.section];
    cell.textLabel.text = [itemsInGroup objectAtIndex:indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //This doesnt work when the user pulls the table very hard
    //CGRect switchesFrame = CGRectMake(cell.frame.origin.x + cell.frame.size.width - switchesDistanceFromRightBorder - switchesWidth, cell.frame.origin.y + cell.frame.size.height/2-switchesHeight/2, switchesWidth, switchesHeight);
    CGRect switchesFrame = CGRectMake(switchesX, switchesY, switchesWidth, switchesHeight);
    
    NSLog(@"switchesFrame: x: %f, y: %f",switchesFrame.origin.x,switchesFrame.origin.y);
    
    if([[itemsInGroup objectAtIndex:indexPath.row] isEqualToString:@"New Member"] && indexPath.section == 0)
    {
        
        [self.memberHuddleSwitch setFrame:switchesFrame];
        [cell.contentView addSubview:self.memberHuddleSwitch];
    }
    if([[itemsInGroup objectAtIndex:indexPath.row] isEqualToString:@"Huddle is Studying"])
    {
        [self.huddleIsStudyingSwitch setFrame:switchesFrame];
        [cell.contentView addSubview:self.huddleIsStudyingSwitch];
    }
    if([[itemsInGroup objectAtIndex:indexPath.row] isEqualToString:@"New Thread Post"])
    {
        [self.threadPostSwitch setFrame:switchesFrame];
        [cell.contentView addSubview:self.threadPostSwitch];
    }
    if([[itemsInGroup objectAtIndex:indexPath.row] isEqualToString:@"Resource Added"])
    {
        [self.resourceAddedSwitch setFrame:switchesFrame];
        [cell.contentView addSubview:self.resourceAddedSwitch];
    }
    if([[itemsInGroup objectAtIndex:indexPath.row] isEqualToString:@"New Post"])
    {
        [self.postSwitch setFrame:switchesFrame];
        [cell.contentView addSubview:self.postSwitch];
    }
    if([[itemsInGroup objectAtIndex:indexPath.row] isEqualToString:@"New Member"] && indexPath.section == 1)
    {
        [self.memberClassSwitch setFrame:switchesFrame];
        [cell.contentView addSubview:self.memberClassSwitch];
    }
    if([[itemsInGroup objectAtIndex:indexPath.row] isEqualToString:@"Reply to Your Post"])
    {
        [self.replyToPostSwitch setFrame:switchesFrame];
        [cell.contentView addSubview:self.replyToPostSwitch];
    }
    
    [cell layoutSubviews];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}

-(void)displayHoursChanged:(id)sender
{
    NSLog(@"displayHoursChanged");
}

-(void)pokeChanged:(id)sender
{
    NSLog(@"pokeChanged");
}

-(void)viewWillDisappear:(BOOL)animated
{
    PFUser* currentUser = [PFUser currentUser];
    

    
    currentUser[@"receiveNewHuddleMemberNotifications"] = [NSNumber numberWithBool:self.memberHuddleSwitch.isOn];
    currentUser[@"receiveHuddleIsStudyingNotifications"] = [NSNumber numberWithBool:self.huddleIsStudyingSwitch.isOn];
    currentUser[@"receiveNewThreadPostNotifications"] = [NSNumber numberWithBool:self.threadPostSwitch.isOn];
    currentUser[@"receiveResourceAddedNotifications"] = [NSNumber numberWithBool:self.resourceAddedSwitch.isOn];
    
    currentUser[@"receiveNewPostNotifications"] = [NSNumber numberWithBool:self.postSwitch.isOn];
    currentUser[@"receiveNewClassMemberNotifications"] = [NSNumber numberWithBool:self.memberClassSwitch.isOn];
    currentUser[@"receiveReplyToYourPostNotifications"] = [NSNumber numberWithBool:self.replyToPostSwitch.isOn];
    
    [currentUser saveInBackground];
}


-(void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}





@end
