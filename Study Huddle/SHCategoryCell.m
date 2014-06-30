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
#import "Student.h"
#import "SHUtility.h"

@interface SHCategoryCell ()

@property (nonatomic, strong) UILabel *categoryInfoLabel;

@end

@implementation SHCategoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        //Members
        self.categoryInfoLabel = [[UILabel alloc] init];
        [self.categoryInfoLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
        [self.categoryInfoLabel setTextColor:[UIColor huddleSilver]];
        [self.categoryInfoLabel setNumberOfLines:0];
        [self.categoryInfoLabel sizeToFit];
        [self.categoryInfoLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.categoryInfoLabel setBackgroundColor:[UIColor clearColor]];
        [self.mainView addSubview:self.categoryInfoLabel];
        
        
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize titleSize = [self.titleButton.titleLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                                      options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                                   attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:16]}
                                                                      context:nil].size;
    [self.titleButton setFrame:CGRectMake(categoryTitleX, categoryTitleY, titleSize.width, titleSize.height)];
    
    CGSize labelSize = [self.categoryInfoLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                            options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:12]}
                                                            context:nil].size;
    
    [self.categoryInfoLabel setFrame:CGRectMake(categoryTitleX, categoryTitleY+self.titleButton.frame.size.height, labelSize.width, labelSize.height)];
    
    
}

- (void)setCategory:(NSString *)aCategory withHuddle:(PFObject *)huddle
{
    _category = aCategory;
    
    
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject: [UIFont fontWithName:@"Arial" size:12] forKey:NSFontAttributeName];
    NSDictionary *arialBoldDict = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Arial-BoldMT" size:12] forKey:NSFontAttributeName];
    
    [self.titleButton setTitle:aCategory forState:UIControlStateNormal];
    
    NSInteger resourceCount = [SHUtility resourcesInCategory:aCategory inHuddle:huddle];
    
    NSMutableAttributedString *categoryInfoString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld Resources", (long)resourceCount] attributes:arialDict];
    NSMutableAttributedString *categoryInfoTitleString = [[NSMutableAttributedString alloc]initWithString:@"Info: " attributes:arialBoldDict];
    
    [categoryInfoTitleString appendAttributedString:categoryInfoString];
    self.categoryInfoLabel.attributedText = categoryInfoTitleString;
    
}


@end
