//
//  SHClassCell.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/14/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHClassCell.h"
#import "UIColor+HuddleColors.h"
#import "SHConstants.h"

@interface SHClassCell ()

@end

@implementation SHClassCell



- (void)setClass:(PFObject *)aClass
{
    _huddleClass = aClass;
    
    //Title Button
    [self.titleButton setTitle:[aClass objectForKey:SHClassFullNameKey] forState:UIControlStateNormal];
    [self.titleButton setTitle:[aClass objectForKey:SHClassFullNameKey] forState:UIControlStateHighlighted];
    
    
    NSMutableAttributedString *teacherString = [[NSMutableAttributedString alloc] initWithString:[aClass objectForKey:SHClassTeacherKey]  attributes: self.descriptionDict];
    NSMutableAttributedString *teacherTitleString = [[NSMutableAttributedString alloc]initWithString:@"Teacher: " attributes:self.descriptionDict];
    
    [teacherTitleString appendAttributedString:teacherString];
    self.descriptionLabel.attributedText = teacherTitleString;

    
    [self layoutSubviews];
    
}




@end
