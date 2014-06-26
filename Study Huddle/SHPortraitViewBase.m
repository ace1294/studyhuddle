//
//  SHPortraitViewBase.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/14/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHPortraitViewBase.h"
#import "SHPortraitViewBaseViewController.h"
#import "Student.h"

#define imageScale 0.95

@interface SHPortraitViewBase()

@property (nonatomic, strong) UIImageView *borderImageview;

@end

@implementation SHPortraitViewBase

@synthesize borderImageview;

-(id)init
{
    self = [super init];
    self = [self initWithImage:NULL andFrame:CGRectMake(0, 0, 100, 100)];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor clearColor];
    
    CGRect profilePicFrame = CGRectMake(self.bounds.origin.x+(1-imageScale)/2*self.bounds.size.width, self.bounds.origin.y+(1-imageScale)/2*self.bounds.size.height, self.bounds.size.width*imageScale, self.bounds.size.height*imageScale);
        
    SHPortraitViewBaseViewController *controller =[[SHPortraitViewBaseViewController alloc]init];
    controller.portraitView = self;;
    self.delegate = controller;
    self.profileImageView = [[PFImageView alloc] initWithFrame:profilePicFrame];
    self.profileImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.profileImageView];
    
    self.profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.profileButton addTarget:self action:@selector(didTapProfileButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.profileButton];
    
    if (frame.size.width < 35.0f) {
        self.borderImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ringBehindProfPic@2x.png"]];
    } else if (frame.size.width < 43.0f) {
        self.borderImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ringBehindProfPic@2x.png"]];
    } else {
        self.borderImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ringBehindProfPic@2x.png"]];
    }
    
    self.borderImageview.frame = self.bounds;
    self.profileButton.frame = self.bounds;
    
    [self addSubview:self.borderImageview];
    
 
    return self;

}

- (id) initWithImage: (UIImage*)image andFrame:(CGRect)frame
{
    
    self = [self initWithFrame:frame];
    self.profileImageView.image = image;
    
    return self;
}

- (void)didTapProfileButtonAction:(id)sender
{
    NSLog(@"Profile button tapped imageview");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapProfileButton:)])
    {
        [self.delegate didTapProfileButton: self.profileImageView];
    }
    
}


-(UIImage *)prepareImage: (UIImage*)unpreparedImage
{

    return [self getRoundedRectImageFromImage:unpreparedImage onReferenceView:self.profileImageView withCornerRadius:self.profileImageView.frame.size.width/2];

}

- (UIImage *)getRoundedRectImageFromImage :(UIImage *)image onReferenceView :(UIImageView*)imageView withCornerRadius :(float)cornerRadius
{
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 0.0);
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds
                                cornerRadius:cornerRadius] addClip];
    [image drawInRect:imageView.bounds];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImage;
}

-(void)savePhotoToParse:(UIImage*)newProfileImage
{

        //should be implemented the by child class
}

-(BOOL) shouldUpdatePicture
{
    
    return true;
}


@end
