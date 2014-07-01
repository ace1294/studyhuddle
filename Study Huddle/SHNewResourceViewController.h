//
//  SHNewResourceViewController.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/29/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <Parse/Parse.h>
#import "SHConstants.h"


@interface SHNewResourceViewController : UIViewController

- (id)initWithHuddle:(PFObject *)aHuddle;

@end



#define newResourceWidth 270
#define headerHeight 35.0
#define headerWidth 200.0

#define fieldHeight 35.0
#define fieldWidth 240.0

#define descriptionHeight 100.0

#define addPictureButtonDimX 50.0
#define addPictureButtonDimY 50.0

#define horiViewSpacing 15.0

#define buttonX 15.0
#define buttonY 300.0
#define buttonWidth 120.0
#define buttonHeight 30.0

#define aboutHeaderY 55.0
#define descriptionHeaderY 190.0
#define categoryHeaderY 315.0

#define resourceTitleY aboutHeaderY+vertElemSpacing
#define resourceLinkY resourceTitleY+fieldHeight
#define selectPictureY resourceLinkY+fieldHeight