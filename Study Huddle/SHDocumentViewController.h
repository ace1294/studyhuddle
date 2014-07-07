//
//  SHDocumentViewController.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/2/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHDocumentView.h"

@interface SHDocumentViewController : UIViewController <SHDocumentiewDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property SHDocumentView *documentView;
@property UIImageView* imageView;

-(void) takePicture:(UIImageView*)imageView;
-(void) choosePicture:(UIImageView*)imageView;

@end
