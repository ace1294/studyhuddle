//
//  SHResourceCell.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/25/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHBaseTextCell.h"
#import <Parse/Parse.h>
#import "SHConstants.h"

@interface SHResourceCell : SHBaseTextCell

@property  (strong, nonatomic) PFObject *resource;

- (void)setResource:(PFObject *)aResource;

@end

#define resourceTitleX titleX
#define resourceTitleY titleY
