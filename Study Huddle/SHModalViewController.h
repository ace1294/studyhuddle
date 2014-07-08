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

@property (strong, nonatomic) UIFont *headerFont;
@property (strong, nonatomic) UIFont *buttonFont;

- (void)cancelAction;

@end


@protocol SHModalViewControllerDelegate <NSObject>


@end


#define firstHeader 40.0
#define modalHeaderHeight 35.0

#define huddleButtonWidth 120.0
#define huddleButtonHeight 30.0

#define continueX 225.0


#define modalButtonWidth 40.0
#define modalButtonHeight 20.0
#define modalButtonY (modalHeaderHeight-modalButtonHeight)/2