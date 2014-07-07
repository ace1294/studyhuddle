//
//  SHModalViewController.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/6/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHConstants.h"

@interface SHModalViewController : UIViewController

@property (strong, nonatomic) id delegate;
@property (strong, nonatomic) UILabel *headerLabel;
@property (strong, nonatomic) UIButton *continueButton;
@property (strong, nonatomic) UIButton *cancelButton;
@property float modalFrameHeight;

@end


@protocol SHModalViewControllerDelegate <NSObject>
@optional

- (void)didTapContinue;
- (void)didTapCancel;

@end