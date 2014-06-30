//
//  SHCreateHuddlePortraitViewController.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/23/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHBasePortraitViewController.h"
#import "Student.h"
#import "DZNPhotoPickerController.h"
#import "UIImagePickerControllerExtended.h"
#import "SHAppDelegate.h"
#import "UIColor+HuddleColors.h"
#import "SHUtility.h"

@interface SHBasePortraitViewController () 




@end

@implementation SHBasePortraitViewController

@synthesize imageView;



- (void) didTapProfileButton: (UIImageView*)image
{
    NSLog(@"Create Huddle profile tapped");
    
    self.imageView = image;
    
    //present the UIAction sheet
    NSString *actionSheetTitle = @"What's it gonna be?"; //Action Sheet Title
    NSString *option1 = @"Take picture"; //Action Sheet Button Titles
    NSString *option2 = @"Choose Picture";
    NSString *cancelTitle = @"Cancel Button";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:option1, option2, nil];
    
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];

    
}



-(void) choosePictureAndPutIn:(UIImageView*)imageView
{
    

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


-(void) takePictureAndPutIn:(UIImageView*)imageView
{
    
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.cropMode = DZNPhotoEditorViewControllerCropModeCircular;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
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
    UIImage *chosenUnpreparedImage = info[UIImagePickerControllerEditedImage];
    UIImage* preparedImage = [SHUtility getRoundedRectImageFromImage:chosenUnpreparedImage onReferenceView:self.imageView withCornerRadius:self.imageView.frame.size.width/2];
    self.imageView.image = preparedImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma UIActionSheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];

    if ([buttonTitle isEqualToString:@"Take picture"]) {
       [self takePictureAndPutIn:self.imageView];
    }
    if ([buttonTitle isEqualToString:@"Choose Picture"]) {
        NSLog(@"Choose picture called");
        [self choosePictureAndPutIn:self.imageView];
    }
    if ([buttonTitle isEqualToString:@"Cancel Button"]) {
        NSLog(@"Cancel clicked");
    }
    
    
}




@end
