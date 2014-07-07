//
//  SHNewResourceViewController.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/29/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <Parse/Parse.h>
#import "SHModalViewController.h"
#import "SHConstants.h"


@interface SHNewResourceViewController : SHModalViewController

@property (strong, nonatomic) id owner;



- (id)initWithHuddle:(PFObject *)aHuddle;

@end




#define headerHeight 30.0
#define headerWidth 200.0

#define fieldX horiViewSpacing+horiElemSpacing+documentWidth
#define fieldHeight 30.0
#define fieldWidth modalWidth-105

#define descriptionWidth 240.0
#define descriptionHeight 100.0

#define documentY aboutHeaderY+headerHeight
#define documentWidth 70.0
#define documentHeight 80.0



#define buttonX horiViewSpacing
#define buttonY categoryHeaderY+headerHeight
#define huddleButtonWidth 120.0
#define huddleButtonHeight 30.0

#define aboutHeaderY 30.0
#define descriptionHeaderY 140.0
#define categoryHeaderY 275.0

#define resourceNameY documentY+10.0
#define resourceLinkY resourceNameY+fieldHeight+vertElemSpacing

#define descriptionY descriptionHeaderY+headerHeight