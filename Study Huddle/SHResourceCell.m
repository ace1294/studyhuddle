//
//  SHResourceCell.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/25/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHResourceCell.h"
#import "SHPortraitView.h"
#import "SHConstants.h"
#import "UIColor+HuddleColors.h"

@interface SHResourceCell ()


@end

@implementation SHResourceCell


- (void)setResource:(PFObject *)aResource
{
    _resource = aResource;
    
    PFUser *creator = aResource[SHResourceCreatorKey];
    [creator fetchIfNeeded];
    
    [self.titleButton setTitle:[aResource objectForKey:SHResourceNameKey] forState:UIControlStateNormal];

    NSMutableAttributedString *creatorString = [[NSMutableAttributedString alloc] initWithString:creator[SHStudentNameKey] attributes:self.descriptionDict];
    NSMutableAttributedString *creatorTitleString = [[NSMutableAttributedString alloc]initWithString:@"Creator: " attributes:self.descriptionDict];
    
    [creatorTitleString appendAttributedString:creatorString];
    self.descriptionLabel.attributedText = creatorTitleString;
    
    [self layoutSubviews];
}


@end
