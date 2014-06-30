//
//  SHPortraitView.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/19/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SHPortraitView : UIView

@property (nonatomic, strong) UIButton *profileButton;
@property (nonatomic, strong) PFImageView *profileImageView;

- (void)setFile:(PFFile *)file;
- (void)hideButton;
- (void)setGreen;

@end
