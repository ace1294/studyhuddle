//
//  SHCreateHuddlePortraitView.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/23/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHBasePortraitView.h"
#import "SHBasePortraitViewController.h"
#import <Parse/Parse.h>

#define imageScale 0.95


@interface SHBasePortraitView()

@property (nonatomic, strong) UIImageView *borderImageview;

@end

@implementation SHBasePortraitView


- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor clearColor];
    self.isClickable = YES;
   
    //set up the controller that will handle the stuff
    SHBasePortraitViewController *controller =[[SHBasePortraitViewController alloc]init];
    controller.portraitView = self;
    self.delegate = controller;
    
    
    //set up the huddle image
    CGRect huddlePicFrame = CGRectMake(self.bounds.origin.x+(1-imageScale)/2*self.bounds.size.width, self.bounds.origin.y+(1-imageScale)/2*self.bounds.size.height, self.bounds.size.width*imageScale, self.bounds.size.height*imageScale);
    self.huddleImageView = [[PFImageView alloc] initWithFrame:huddlePicFrame];
    self.huddleImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.huddleImageView];
    
    //set up the button to recognize the click
    self.profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.profileButton addTarget:self action:@selector(didTapProfileButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.profileButton.frame = self.bounds;
    [self addSubview:self.profileButton];
    
    //set up the border
    if (frame.size.width < 35.0f) {
        self.borderImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OfflineRing90.png"]];
    } else if (frame.size.width < 43.0f) {
        self.borderImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OfflineRing90.png"]];
    } else {
        self.borderImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OfflineRing90.png"]];
    }
    self.borderImageview.frame = self.bounds;
    [self addSubview:self.borderImageview];
    
    
    
    
    return self;
    
}



- (void)didTapProfileButtonAction:(id)sender
{
    if(!self.isClickable) return;
    NSLog(@"Profile button tapped SHCreateHuddlePortraitView");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapProfileButton:)])
    {
        [self.delegate didTapProfileButton: self.huddleImageView];
    }
    
}





@end


