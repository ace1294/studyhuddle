//
//  SHNotificationCell.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/30/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHThreadCell.h"
#import "UIColor+HuddleColors.h"
#import "SHConstants.h"

@interface SHThreadCell ()

@property (nonatomic,strong) PFObject* threadObject;


@end

@implementation SHThreadCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}


- (void)setThread:(PFObject *)aThread
{
    _threadObject = aThread;
    
    //Title Button
    [self.titleButton setTitle:[aThread objectForKey:SHThreadTitle] forState:UIControlStateNormal];
    
    PFUser* student = [aThread objectForKey:SHThreadCreator];
    [student fetchIfNeeded];
    [self.descriptionLabel setText:student[SHStudentNameKey]];
    
    
    
    [self layoutSubviews];
}

-(PFObject*)getThread
{
    return self.threadObject;
}

@end
