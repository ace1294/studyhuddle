//
//  SHDocumentView.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/2/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SHDocumentView : UIView

@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) UIButton *addDocumentButton;
@property (nonatomic, strong) UIImageView *documentImageView;
@property (nonatomic, strong) id owner;
@property NSString* defaultImageName;

@end
