//
//  SHHuddlePageCell.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/12/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHBaseTextCell.h"
#import <Parse/Parse.h>

@interface SHHuddlePageCell : SHBaseTextCell

@property (strong, nonatomic) PFObject *huddle;
- (void)setHuddle:(PFObject *)aHuddle;

@end
