//
//  SHUserSettingsViewController.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/17/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHProfileSettingsController.h"
#import "SHProfileViewController.h"
#import "SHVisibilitySetting.h"
#import "SHPushNotificationsSetting.h"

#define cellHeight 50

@interface SHProfileSettingsController ()<UITableViewDelegate,UITextFieldDelegate>


@property NSMutableArray *tableData;

@end

@implementation SHProfileSettingsController

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
    
    self.title = @"Profile Settings";
    
    //set up the content in the dictionary
    self.tableData = [[NSMutableArray alloc]init];
    //preferences
    NSArray* preferencesData = [[NSArray alloc]initWithObjects:@"Push Notifications",@"Study Visibility", nil];
    NSArray* supportData = [[NSArray alloc]initWithObjects:@"Report a Problem",@"Terms of Service",@"Privacy Policy",@"About Study Huddle", nil];
    [self.tableData addObject:preferencesData];
    [self.tableData addObject:supportData];
    
    

 
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
        return @"Preferences";
    if(section == 1)
        return @"Support";
    else
        return @"This shouldnt have happened";
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        //its in Preferences
        if(indexPath.row == 0)
            [self doPushNotifications];
        if (indexPath.row == 1) {
            [self doStudyVisibility];
        }
    }
    else if(indexPath.section == 1)
    {
        //its in Support
    }
    
  
}



-(void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doPushNotifications
{
    SHPushNotificationsSetting* pushSettings = [[SHPushNotificationsSetting alloc]init];
    [self.navigationController pushViewController:pushSettings animated:YES];
}

-(void)doStudyVisibility
{
    SHVisibilitySetting* visibilitySettings = [[SHVisibilitySetting alloc]init];
    [self.navigationController pushViewController:visibilitySettings animated:YES];
    
}

-(void)doReportAProblem
{
    
}

-(void)doTermsOfService
{
    
}

-(void)doPrivacyPolicy
{
    
}

-(void)doAboutStudyHuddle
{
    
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

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
