//
//  SHThreadCell.h
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 7/4/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHBaseTextCell.h"
#import <Parse/Parse.h>

@interface SHThreadCell : SHBaseTextCell

- (void)setThread:(PFObject *)aThread;
-(PFObject*)getThread;

@end
