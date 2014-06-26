//
//  SHUserSettingsViewController.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/17/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHVisibilitySetting.h"
#import "Student.h"


#define cellHeight 50
#define switchesDistanceFromRightBorder 40
#define switchesHeight 20
#define switchesWidth 40
#define switchesX 240
#define switchesY 10

@interface SHVisibilitySetting()<UITableViewDelegate,UITextFieldDelegate>


@property NSMutableArray *tableData;
@property UISwitch* displayHoursSwitch;
@property UISwitch* pokeSwitch;

@end

@implementation SHVisibilitySetting

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
    Student* currentStudent = (Student*)[PFUser currentUser];
    
    //set up the content in the dictionary
    self.tableData = [[NSMutableArray alloc]init];
    //preferences
    NSArray* studyVisibilityData = [[NSArray alloc]initWithObjects:@"Display Study Hours",@"Poke to Study", nil];

    [self.tableData addObject:studyVisibilityData];

    
    //create the switches
    self.displayHoursSwitch = [[UISwitch alloc]init];
    [self.displayHoursSwitch setOn:[currentStudent.displayHoursToStudyEnabled boolValue]];
    [self.displayHoursSwitch  addTarget:self action:@selector(displayHoursChanged:) forControlEvents:UIControlEventValueChanged];
    self.pokeSwitch = [[UISwitch alloc]init];
    [self.pokeSwitch setOn:[currentStudent.pokeToStudyEnabled boolValue]];
    [self.pokeSwitch  addTarget:self action:@selector(pokeChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    
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
        return @"Study Visibility";
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    CGRect switchesFrame = CGRectMake(switchesX, switchesY, switchesWidth, switchesHeight);
    if([[itemsInGroup objectAtIndex:indexPath.row] isEqualToString:@"Display Study Hours"])
    {
        
        [self.displayHoursSwitch setFrame:switchesFrame];
        [cell.contentView addSubview:self.displayHoursSwitch];
    }
    if([[itemsInGroup objectAtIndex:indexPath.row] isEqualToString:@"Poke to Study"])
    {
        [self.pokeSwitch setFrame:switchesFrame];
        [cell.contentView addSubview:self.pokeSwitch];
        
    }
    
    
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
    Student* currentUser = (Student*)[PFUser currentUser];
    currentUser.pokeToStudyEnabled = [NSNumber numberWithBool:self.pokeSwitch.isOn];
    currentUser.displayHoursToStudyEnabled = [NSNumber numberWithBool:self.displayHoursSwitch.isOn];
    
    [currentUser saveInBackground];
}


-(void)backPressed
{
    [self.navigationController popViewControllerAnimated:YES];
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
