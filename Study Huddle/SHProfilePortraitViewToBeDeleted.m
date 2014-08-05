//
//  SHProfilePortraitView.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/14/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHProfilePortraitViewToBeDeleted.h"
#import "SHConstants.h"

@implementation SHProfilePortraitViewToBeDeleted

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)savePhotoToParse:(UIImage *)newProfileImage
{
    NSLog(@"save photo parse called");
    PFUser* currentUser = [PFUser currentUser];
    NSData* imageData = UIImageJPEGRepresentation(newProfileImage, 1.0f);
    PFFile *imageFile = [PFFile fileWithData:imageData];
    currentUser[SHStudentImageKey] = imageFile;
    
    [currentUser saveInBackground];
    
}

-(id)initWithImage:(UIImage *)image andFrame:(CGRect)frame
{
    self = [super initWithImage:image andFrame:frame];
    
    PFUser* student = [PFUser currentUser];
    NSLog(@"users image was: %@",student[SHStudentImageKey]);
    
    if (student[SHStudentImageKey]) {
        PFFile* imageFile = student[SHStudentImageKey];
        UIImage* unprepImage = [UIImage imageWithData:[imageFile getData] ];
        self.profileImageView.image = [self prepareImage:unprepImage];
    }
    
    
    return self;
}

-(BOOL)shouldUpdatePicture
{
    
    NSString *actionSheetTitle = @"What's it gonna be?"; //Action Sheet Title
    NSString *modifyTitle = @"Modify picture"; //Action Sheet Button Titles
    NSString *other1 = @"Edit Profile";
    NSString *other2 = @"Logout";
    NSString *cancelTitle = @"Cancel Button";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self.delegate
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:modifyTitle, other1, other2, nil];
    
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
    return NO;

}

@end
