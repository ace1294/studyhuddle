//
//  SHCategoryCell.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/29/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHBaseTextCell.h"
#import <Parse/Parse.h>

@interface SHCategoryCell : SHBaseTextCell

@property  (strong, nonatomic) NSString *category;

- (void)setCategory:(NSString *)aCategory withHuddle:(PFObject *)huddle;

@end


#define categoryTitleX titleX
#define categoryTitleY titleY