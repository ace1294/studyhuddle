//
//  SHHuddlePortraitViewController.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/26/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHHuddlePortraitViewController.h"
#import "SHUtility.h"
#import "SHConstants.h"
#import "UIColor+HuddleColors.h"
#import "SHAppDelegate.h"
#import "SHCache.h"

@interface SHHuddlePortraitViewController ()

@end

@implementation SHHuddlePortraitViewController

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

-(void)updateImageWithInfo: (NSDictionary*)info
{
    [super updateImageWithInfo:info];
    UIImage* newImage =  self.imageView.image;
    NSData* imageData = UIImageJPEGRepresentation(newImage, 1.0f);
    PFFile *imageFile = [PFFile fileWithData:imageData];
    self.portraitHuddle[SHHuddleImageKey] = imageFile;

    [self.portraitHuddle saveInBackground];
    
}

-(void)setHuddle: (PFObject*)huddle;
{
    self.portraitHuddle = huddle;
}

#pragma UIAction sheet

- (void) didTapProfileButton: (UIImageView*)image
{
    NSLog(@"Create Huddle profile tapped");
    
    self.imageView = image;
    
    //present the UIAction sheet
    NSString *actionSheetTitle = @"What's it gonna be?"; //Action Sheet Title
    NSString *option1 = @"Take picture"; //Action Sheet Button Titles
    NSString *option2 = @"Choose Picture";
    NSString *option3 = @"Leave Huddle";
    NSString *cancelTitle = @"Cancel Button";
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:option1, option2,option3, nil];
    
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    //[actionSheet showInView:self.portraitView.owner.view];

    
}

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
    if ([buttonTitle isEqualToString:@"Leave Huddle"]) {
        [[SHCache sharedCache]removeHuddle:self.portraitHuddle];
        [[PFUser currentUser] removeObject:self.portraitHuddle forKey:SHStudentHuddlesKey];
        [[PFUser currentUser]save];
        
    }
    if ([buttonTitle isEqualToString:@"Cancel Button"]) {
        NSLog(@"Cancel clicked");
    }
    
    
}

@end
