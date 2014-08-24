//
//  SHProfilePortraitView.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/26/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHProfilePortraitView.h"
#import "SHProfilePortraitViewController.h"
#import "SHUtility.h"

@interface SHProfilePortraitView()


@property (nonatomic,strong) PFObject* portraitStudent;
@property (nonatomic,strong) SHProfilePortraitViewController* controller;

@end

@implementation SHProfilePortraitView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        SHProfilePortraitViewController *controller =[[SHProfilePortraitViewController alloc]init];
        controller.portraitView = self;
        self.delegate = controller;
    }
    return self;
}

-(void)setStudent: (PFObject*)student
{
    NSLog(@"setHuddle called");
    self.portraitStudent = student;
    
    //get the image
    PFFile* imageFile = [student objectForKey:@"userImage"];
    UIImage* profileImage = [UIImage imageWithData:[imageFile getData]];
    if(profileImage)
        self.huddleImageView.image = [SHUtility getRoundedRectImageFromImage:profileImage onReferenceView:self.huddleImageView withCornerRadius:self.huddleImageView.frame.size.width/2];
    else
        self.huddleImageView.image = [UIImage imageNamed:@"DefaultProfPic.png"];

    [self.delegate setStudent:student];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
