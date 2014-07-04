//
//  SHProfilePortraitViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/26/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHProfilePortraitViewController.h"
#import "SHProfileViewController.h"
#import "SHUserSettingsViewController.h"
#import "UIColor+HuddleColors.h"
#import "SHAppDelegate.h"

@interface SHProfilePortraitViewController ()

@end

@implementation SHProfilePortraitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (void) didTapProfileButton: (UIImageView*)image
{
    NSLog(@"Create Huddle profile tapped");
    
    self.imageView = image;
    
    //present the UIAction sheet
    NSString *actionSheetTitle = @"What's it gonna be?"; //Action Sheet Title
    NSString *option1 = @"Take picture"; //Action Sheet Button Titles
    NSString *option2 = @"Choose Picture";
    NSString *option3 = @"Edit Profile";
    NSString *option4 = @"Logout";
    NSString *cancelTitle = @"Cancel Button";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:option1, option2,option3,option4, nil];
    
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    //[actionSheet showInView:self.portraitView.owner.view];
    [self.portraitView.owner setNavigationBarItems];
    
}



-(void)updateImageWithInfo: (NSDictionary*)info
{
    [super updateImageWithInfo:info];
    UIImage *chosenUnpreparedImage = info[UIImagePickerControllerEditedImage];
    NSData* imageData = UIImageJPEGRepresentation(chosenUnpreparedImage, 1.0f);
    PFFile *imageFile = [PFFile fileWithData:imageData];
    self.portraitStudent[@"userImage"] = imageFile;
    
    NSLog(@"student: %@",self.portraitStudent);
    NSLog(@"about to save to parse!!!!!!!!!!!!!!!!!1111");
    [self.portraitStudent saveInBackground];
    
}

-(void)setStudent:(PFObject *)student
{
    self.portraitStudent = student;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    SHAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [self.portraitView.owner setNavigationBarItems];

    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Take picture"]) {
        [self takePictureAndPutIn:self.imageView];
    }
    if ([buttonTitle isEqualToString:@"Choose Picture"]) {
        NSLog(@"Choose picture called");
        [self choosePictureAndPutIn:self.imageView];
    }
    if ([buttonTitle isEqualToString:@"Edit Profile"]) {
        NSLog(@"Edit Profile called");
        SHUserSettingsViewController* userSettingsVC = [[SHUserSettingsViewController alloc]initWithStyle:UITableViewStyleGrouped];
        
        UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:userSettingsVC];
        navController.navigationBar.barTintColor = [UIColor huddleOrange];
        [navController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        
        
        //[self.portraitView.owner.navigationController pushViewController:userSettingsVC animated:NO];
        [self.portraitView.owner presentViewController:navController animated:YES completion:nil];

    }
    if ([buttonTitle isEqualToString:@"Logout"]) {
        NSLog(@"logout clicked");
        NSLog(@"%@",self.portraitView.owner);
        [appDelegate logout];
    }
    
    if ([buttonTitle isEqualToString:@"Cancel Button"]) {
        NSLog(@"Cancel clicked");
    }
    
    
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
