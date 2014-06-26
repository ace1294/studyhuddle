//
//  SHUserSettingsViewController.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/17/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHUserSettingsViewController.h"
#import "Student.h"
#import "SHProfileViewController.h"

@interface SHUserSettingsViewController ()<UITableViewDelegate,UITextFieldDelegate>

@property NSArray *tableData;
@property UITextField* nameTF;
@property UITextField* majorTF;
@property UITextField* emailTF;


@end

@implementation SHUserSettingsViewController

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
    
    self.title = @"Edit Profile";
    
    Student* currentStudent = (Student*)[PFUser currentUser];
    
    self.nameTF = [[UITextField alloc]init];
    self.majorTF = [[UITextField alloc]init];
    self.emailTF = [[UITextField alloc]init];
    
    self.nameTF.borderStyle = UITextBorderStyleRoundedRect;
    self.nameTF.textColor = [UIColor blackColor];
    self.nameTF.font = [UIFont systemFontOfSize:17.0];
    self.nameTF.backgroundColor = [UIColor clearColor];
    self.nameTF.placeholder = currentStudent.fullName;
    
    self.majorTF.borderStyle = UITextBorderStyleRoundedRect;
    self.majorTF.textColor = [UIColor blackColor];
    self.majorTF.font = [UIFont systemFontOfSize:17.0];
    self.majorTF.backgroundColor = [UIColor clearColor];
    self.majorTF.placeholder = currentStudent.major;
    
    self.emailTF.borderStyle = UITextBorderStyleRoundedRect;
    self.emailTF.textColor = [UIColor blackColor];
    self.emailTF.font = [UIFont systemFontOfSize:17.0];
    self.emailTF.backgroundColor = [UIColor clearColor];
    self.emailTF.placeholder = currentStudent.email;
    
    
    
    
    //create cancelButton
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed)];
    cancelButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    //done button
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(donePressed)];
    doneButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = doneButton;


    
    self.tableData = [NSArray arrayWithObjects:self.nameTF,self.majorTF,self.emailTF, nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.tableData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    CGRect textFieldFrame = CGRectMake(cell.frame.origin.x + cell.frame.size.width/3, cell.frame.origin.y, cell.frame.size.width/3*2,  cell.frame.size.height);
    UITextField* currentTF = [self.tableData objectAtIndex:indexPath.row];
    [currentTF setFrame:textFieldFrame];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width/3,  cell.frame.size.height)];
 

    if(currentTF == self.nameTF)
        label.text = @"Name";
    if(currentTF == self.majorTF)
        label.text = @"Major";
    if(currentTF == self.emailTF)
        label.text = @"Email";

    [cell.contentView addSubview:[self.tableData objectAtIndex:indexPath.row]];
    [cell.contentView addSubview:label];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"clicked %@",[self.tableData objectAtIndex:indexPath.row] );
}



-(void)cancelPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)donePressed
{
    Student* currentUser = (Student*)[Student currentUser];
    if(self.nameTF.text.length > 0)
        currentUser.fullName = self.nameTF.text;
    if(self.majorTF.text.length > 0)
        currentUser.major = self.majorTF.text;
    
    //special case for email because we need to check if someone with that email already exists
    if(self.emailTF.text.length > 0)
    {
        
        PFQuery *query = [Student query];
        [query whereKey:@"username" equalTo:self.emailTF.text];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error)
            {
                if(objects.count>0 && ![self.emailTF.text isEqualToString:currentUser.email])
                {
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Email was not changed", nil) message:NSLocalizedString(@"Huddler with that email already exists", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
                }
                else
                {
                    currentUser.email = self.emailTF.text;
                    currentUser.username = self.emailTF.text;
                }
            } else {
                // Log details of the failure
                
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Could not complete operation", nil) message:NSLocalizedString(@"Internetz must be down or something", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];            }
            
            [currentUser saveInBackground];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
            
    }
    else
    {
        [currentUser saveInBackground];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
  
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
