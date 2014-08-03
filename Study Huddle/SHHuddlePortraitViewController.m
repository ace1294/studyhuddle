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
