//
//  SHCreateHuddlePortraitViewController.h
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/23/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBasePortraitView.h"

@interface SHBasePortraitViewController : UIViewController <SHCreateHuddlePortraitViewDelegate,UIActionSheetDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>

@property SHBasePortraitView* portraitView;
@property UIImageView* imageView;

-(void)updateImageWithInfo: (NSDictionary*)info;
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void) didTapProfileButton: (UIImageView*)image;
-(void) takePictureAndPutIn:(UIImageView*)imageView;
-(void) choosePictureAndPutIn:(UIImageView*)imageView;

@end
