//
//  SHPageHeaderViewController.h
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/14/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
#import "SHProfilePortraitView.h"

@interface SHPageHeaderViewController : UIViewController



@property UILabel* middleLabel;
@property UILabel* leftLabel;
@property UILabel* rightLabel;
@property UILabel* nameLabel;

@property SHProfilePortraitView* profileImage;


@property UIButton* editProfileButton;


-(void)doLayout;
-(void)updateFromParse;

@end
