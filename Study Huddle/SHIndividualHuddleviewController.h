//
//  SHIndividualHuddleviewController.h
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/25/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SHCreateHuddlePortraitView.h"
@class SHHuddleSegmentViewController;

@interface SHIndividualHuddleviewController : UIViewController

-(id)initWithHuddle: (PFObject*) huddle;

@end
