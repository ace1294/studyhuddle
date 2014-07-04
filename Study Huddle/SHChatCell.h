//
//  SHChatCell.h
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 7/3/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHBaseTextCell.h"
#import <Parse/Parse.h>

@interface SHChatCell : SHBaseTextCell

- (void)setChatEntry:(PFObject *)aChatEntry;
-(PFObject*)getChatEntryObj;

@end
