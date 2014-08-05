//
//  SHPortraitViewBaseViewController.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/14/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHPortraitViewBaseViewController.h"
#import "SHPortraitViewBase.h"
#import "DZNPhotoPickerController.h"
#import "UIImagePickerControllerExtended.h"
#import "SHAppDelegate.h"
#import "SHUserSettingsViewController.h"
#import "UIColor+HuddleColors.h"

@interface SHPortraitViewBaseViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate,UIActionSheetDelegate>


@property UIImageView* imageView;

@end

@implementation SHPortraitViewBaseViewController

@synthesize imageView;

- (id)init
{
    self = [super init];
    if(self)
    {
        
        imageView = [[UIImageView alloc] init];
        
    }
    return self;
}


- (void) didTapProfileButton: (UIImageView*)image
{
    NSLog(@"PROFILE BUTTON TAPPED!!!!!!!!!");
   
    if([self.portraitView shouldUpdatePicture])
        [self updatePicture:image];
    
}



-(void) updatePicture:(UIImageView*)image
{
    
    //self.imageView = image;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.cropMode = DZNPhotoEditorViewControllerCropModeCircular;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.finalizationBlock = ^(UIImagePickerController *picker, NSDictionary *info) {
        [self handleImagePicker:picker withMediaInfo:info];
    };
    picker.cancellationBlock = ^(UIImagePickerController *picker) {
        [self dismissController:picker];
    };
    
    [self.portraitView.owner presentViewController:picker animated:YES completion:NULL];
}


- (void)handleImagePicker:(UIImagePickerController *)picker withMediaInfo:(NSDictionary *)info
{
    NSLog(@"handleImagePicker called");
    if(picker.cropMode == DZNPhotoEditorViewControllerCropModeNone)
    {
        NSLog(@"second");
        [self updateImageWithInfo:info];
        [self dismissController:picker];
    }
    else
    {
        NSLog(@"first");
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        DZNPhotoEditorViewController *editor = [[DZNPhotoEditorViewController alloc] initWithImage:image cropMode:picker.cropMode];
        [picker pushViewController:editor animated:YES];
    }
}

- (void)dismissController:(UIViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    NSLog(@"returned form dismisscontroller");
}


-(void)updateImageWithInfo: (NSDictionary*)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    //self.imageView.image = chosenImage;
    UIImage* newProfileImage = [self.portraitView prepareImage:chosenImage];
    self.portraitView.profileImageView.image = newProfileImage;

    [self.portraitView savePhotoToParse:chosenImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma UIActionSheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    
    NSLog(@"%@",self.portraitView.owner.navigationController.topViewController);
    
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    SHAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    

    
    if  ([buttonTitle isEqualToString:@"Edit Profile"]) {
            NSLog(@"Edit Profile cliked");
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
    if ([buttonTitle isEqualToString:@"Modify picture"]) {
        NSLog(@"Modify Picture called");
        [self updatePicture:self.portraitView.profileImageView];
    }
    if ([buttonTitle isEqualToString:@"Cancel Button"]) {
        NSLog(@"Cancel clicked");
    }
    
    
}



@end
