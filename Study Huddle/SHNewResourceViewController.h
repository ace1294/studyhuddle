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



- (id)initWithHuddle:(PFObject *)aHuddle;

@end





#define fieldX horiViewSpacing+horiElemSpacing+documentWidth
#define fieldHeight 30.0
#define fieldWidth modalWidth-105

#define descriptionWidth modalContentWidth
#define descriptionHeight 100.0

#define documentY aboutHeaderY+headerHeight
#define documentWidth 70.0
#define documentHeight 80.0



#define buttonX horiViewSpacing
#define buttonY categoryHeaderY+headerHeight


#define aboutHeaderY firstHeader
#define descriptionHeaderY 145.0
#define categoryHeaderY 275.0

#define resourceNameY documentY+10.0
#define resourceLinkY resourceNameY+fieldHeight+vertElemSpacing

#define descriptionY descriptionHeaderY+headerHeight