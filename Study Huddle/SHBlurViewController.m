//
//  SHBlurViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/29/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHBlurViewController.h"

@interface SHBlurViewController ()

@property (nonatomic, strong) UINavigationBar *lenderBar;

@end

@implementation SHBlurViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.lenderBar = [[UINavigationBar alloc] initWithFrame:self.view.bounds];
    self.lenderBar.barStyle = UIBarStyleDefault;
    [self.view.layer insertSublayer:self.lenderBar.layer atIndex:0];
    
    UIInterpolatingMotionEffect *centerX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    centerX.maximumRelativeValue = @20;
    centerX.minimumRelativeValue = @-20;
    
    UIInterpolatingMotionEffect *centerY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    centerY.maximumRelativeValue = @20;
    centerY.minimumRelativeValue = @-20;
    
    UIMotionEffectGroup *effectGroup = [UIMotionEffectGroup new];
    effectGroup.motionEffects = @[centerX, centerY];
    [self.view addMotionEffect:effectGroup];
    
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    //Hackity hack?
    self.lenderBar.frame = self.view.bounds;
}



@end
