//
//  SHDocumentView.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/2/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHDocumentView.h"

@interface SHDocumentView ()

@end

@implementation SHDocumentView

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor clearColor];
    
    //set up the controller that will handle the stuff
//    SHBasePortraitViewController *controller =[[SHBasePortraitViewController alloc]init];
//    controller.portraitView = self;
//    self.delegate = controller;
    
    
    //set up the huddle image
    /*CGRect huddlePicFrame = CGRectMake(self.bounds.origin.x+(1-imageScale)/2*self.bounds.size.width, self.bounds.origin.y+(1-imageScale)/2*self.bounds.size.height, self.bounds.size.width*imageScale, self.bounds.size.height*imageScale);
    self.documentImageView = [[PFImageView alloc] initWithFrame:huddlePicFrame];
    self.documentImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.documentImageView];
    
    //set up the button to recognize the click
    self.addDocumentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addDocumentButton addTarget:self action:@selector(didTapAddDocument:) forControlEvents:UIControlEventTouchUpInside];
    self.addDocumentButton.frame = self.bounds;
    [self addSubview:self.addDocumentButton];
    
    //set up the border
    if (frame.size.width < 35.0f) {
        self.borderImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ringBehindProfPic@2x.png"]];
    } else if (frame.size.width < 43.0f) {
        self.borderImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ringBehindProfPic@2x.png"]];
    } else {
        self.borderImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ringBehindProfPic@2x.png"]];
    }
    self.borderImageview.frame = self.bounds;
    [self addSubview:self.borderImageview];*/
    
    
    
    
    return self;
    
}


- (void)didTapAddDocument:(id)sender
{
    
}



@end
