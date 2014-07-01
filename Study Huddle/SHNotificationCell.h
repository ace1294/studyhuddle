//
//  SHNotificationCell.h
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/30/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHBaseTextCell.h"
#import <Parse/Parse.h>

@interface SHNotificationCell : SHBaseTextCell

- (void)setNotification:(PFObject *)aNotification;

@end
