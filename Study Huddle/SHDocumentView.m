//
//  SHDocumentView.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/2/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHDocumentView.h"
#import "SHDocumentViewController.h"

@interface SHDocumentView ()

@end

@implementation SHDocumentView

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor whiteColor];
    self.documentSet = NO;
    
    //set up the controller that will handle the stuff
    SHDocumentViewController *controller =[[SHDocumentViewController alloc]init];
    controller.documentView = self;
    self.delegate = controller;
    
    
    //set up the huddle image
    CGRect documentFrame = CGRectMake(self.bounds.origin.x+2.0, self.bounds.origin.y+2.0, self.bounds.size.width-4.0, self.bounds.size.height-4.0);

    self.documentImageView = [[PFImageView alloc] initWithFrame:documentFrame];
    self.documentImageView.image = [UIImage imageNamed:@"newDocBlue.png"];
    self.documentImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.documentImageView];
    
    //set up the button to recognize the click
    self.addDocumentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addDocumentButton addTarget:self action:@selector(didTapAddDocumentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.addDocumentButton.frame = self.bounds;
    [self addSubview:self.addDocumentButton];
    
    
    
    return self;
    
}


- (void)didTapAddDocumentButtonAction:(id)sender
{
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapAddDocumentButton:)])
    {
        [self.delegate didTapAddDocumentButton: self.documentImageView];
    }
}



@end
