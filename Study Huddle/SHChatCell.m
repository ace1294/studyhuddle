//
//  SHNotificationCell.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/30/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHChatCell.h"
#import "UIColor+HuddleColors.h"
#import "SHConstants.h"

@interface SHChatCell ()

@property (nonatomic,strong) PFObject* chatEntryObj;

@end

@implementation SHChatCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //Members
    }
    return self;
}



- (void)setChatEntry:(PFObject *)aChatEntry
{
    _chatEntryObj = aChatEntry;
    
    //Title Button
    [self.titleButton setTitle:[aChatEntry objectForKey:SHChatEntryCategoryKey] forState:UIControlStateNormal];
    
    [self.descriptionLabel setText:@"something cool will go here"];
    
    
    [self layoutSubviews];
}

-(PFObject*)getChatEntryObj
{
    return self.chatEntryObj;
}

@end
