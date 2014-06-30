//
//  SHHuddlePortraitView.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/26/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHHuddlePortraitView.h"
#import "SHHuddlePortraitViewController.h"
#import <Parse/Parse.h>

@interface SHHuddlePortraitView()

@property (nonatomic,strong) PFObject* portraitHuddle;
@property (nonatomic,strong) SHHuddlePortraitViewController* controller;

@end

@implementation SHHuddlePortraitView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        SHHuddlePortraitViewController *controller =[[SHHuddlePortraitViewController alloc]init];
        controller.portraitView = self;
        self.delegate = controller;
    }
    return self;
}

-(void)setHuddle: (PFObject*)huddle
{
    NSLog(@"setHuddle called");
    self.portraitHuddle = huddle;
    
    //get the image
    PFFile* imageFile = [huddle objectForKey:@"huddleImage"];
    UIImage* huddleImage = [UIImage imageWithData:[imageFile getData]];
    self.huddleImageView.image = huddleImage;
    NSLog(@"huddle that will be passed to controllerL %@",huddle);
    [self.delegate setHuddle:huddle];
    
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
