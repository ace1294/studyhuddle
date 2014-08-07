//
//  SHResourceCell.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/25/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHCategoryCell.h"
#import "SHPortraitView.h"
#import "SHConstants.h"
#import "UIColor+HuddleColors.h"
#import "SHUtility.h"

@interface SHCategoryCell ()


@end

@implementation SHCategoryCell


- (void)setCategory:(PFObject *)aCategory
{
    _category = aCategory;
    
    
    
    [self.titleButton setTitle:[aCategory objectForKey:SHResourceCategoryNameKey] forState:UIControlStateNormal];
    
    NSInteger resourceCount = [[aCategory objectForKey:SHResourceCategoryResourcesKey] count];
    
    NSMutableAttributedString *categoryInfoString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld Resources", (long)resourceCount] attributes:self.descriptionDict];
    NSMutableAttributedString *categoryInfoTitleString = [[NSMutableAttributedString alloc]initWithString:@"Info: " attributes:self.descriptionDict];
    
    [categoryInfoTitleString appendAttributedString:categoryInfoString];
    self.descriptionLabel.attributedText = categoryInfoTitleString;
    
    [self layoutSubviews];
}


@end
