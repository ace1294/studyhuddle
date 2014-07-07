//
//  SHDocumentViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/2/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHDocumentViewController.h"

@interface SHDocumentViewController ()

@end

@implementation SHDocumentViewController

- (void) didTapAddDocumentButton: (UIImageView*)image
{
    NSLog(@"Create Huddle profile tapped");
    
    self.imageView = image;
    
    //present the UIAction sheet
    NSString *actionSheetTitle = @"Add Document"; //Action Sheet Title
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

- (void)takePicture:(UIImageView *)imageView
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self.documentView.owner presentViewController:picker animated:YES completion:NULL];
}

-(void) choosePicture:(UIImageView*)imageView
{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    
    [self.documentView.root presentViewController:picker animated:YES completion:NULL];
    

    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    

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
        [self takePicture:self.imageView];
    }
    if ([buttonTitle isEqualToString:@"Choose Picture"]) {
        NSLog(@"Choose picture called");
        [self choosePicture:self.imageView];
    }
    if ([buttonTitle isEqualToString:@"Cancel Button"]) {
        
    }
    
    
}

@end
