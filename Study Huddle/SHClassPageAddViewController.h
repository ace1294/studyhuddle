//
//  SHClassPageAddViewController.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 8/22/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHClassPageAddViewController : UIViewController

@property (strong, nonatomic) id delegate;

@end

@protocol SHClassPageAddDelegate <NSObject>

- (void)addThreadTapped;

@end
