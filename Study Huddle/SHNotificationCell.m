//
//  SHNotificationCell.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/30/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHNotificationCell.h"
#import "UIColor+HuddleColors.h"
#import "SHConstants.h"

@interface SHNotificationCell ()



@end

@implementation SHNotificationCell




- (void)setNotification:(PFObject *)aNotification
{
    _notification = aNotification;
    
    //Title Button
    [self.titleButton setTitle:[aNotification objectForKey:SHNotificationTitleKey] forState:UIControlStateNormal];
    [self.descriptionLabel setText:aNotification[SHNotificationDescriptionKey]];
    
    [self.descriptionLabel setText:[aNotification objectForKey:SHNotificationDescriptionKey]];
    if([aNotification[SHNotificationReadKey] boolValue])
    {
        [self.titleButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.descriptionLabel setTintColor:[UIColor grayColor]];
    }
    
//    NSString *type = aNotification[SHNotificationTypeKey];
//    
//    if([type isEqualToString:SHNotificationSSStudyRequestType]){
//        
//    } else if([type isEqualToString:SHRequestSSInviteStudy]){
//        
//    } else if([type isEqualToString:SHRequestSSInviteStudy]){
//        
//    } else if([type isEqualToString:SHRequestSSInviteStudy]){
//        
//    } else if([type isEqualToString:SHRequestSSInviteStudy]){
//        
//    } else if([type isEqualToString:SHRequestSSInviteStudy]){
//        
//    }
    
    
    [self layoutSubviews];
}

@end
