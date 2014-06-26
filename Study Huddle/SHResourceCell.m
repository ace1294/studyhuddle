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

@property (nonatomic, strong) SHPortraitView *portrait;
@property (nonatomic, strong) UILabel *resourceNameLabel;

@end

@implementation SHResourceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //Avatar
        self.portrait = [[SHPortraitView alloc] initWithFrame:CGRectMake(cellPortraitX, cellPortraitY, cellPortraitDim, cellPortraitDim)];
        [self.portrait setBackgroundColor:[UIColor clearColor]];
        [self.portrait setOpaque:YES];
        [self.mainView addSubview:self.portrait];
        
        //Members
        self.resourceNameLabel = [[UILabel alloc] init];
        [self.resourceNameLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
        [self.resourceNameLabel setTextColor:[UIColor huddleSilver]];
        [self.resourceNameLabel setNumberOfLines:0];
        [self.resourceNameLabel sizeToFit];
        [self.resourceNameLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.resourceNameLabel setBackgroundColor:[UIColor clearColor]];
        [self.mainView addSubview:self.resourceNameLabel];
        

        
        
    }
    return self;
}

- (void)layoutSubviews
{
    CGSize titleSize = [self.titleButton.titleLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                                      options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                                   attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:16]}
                                                                      context:nil].size;
    [self.titleButton setFrame:CGRectMake(resourceTitleX, resourceTitleY, titleSize.width, titleSize.height)];
    
    CGSize labelSize = [self.resourceNameLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                         options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                      attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:12]}
                                                             context:nil].size;
    
    [self.resourceNameLabel setFrame:CGRectMake(resourceTitleX, resourceTitleY+self.titleButton.frame.size.height, labelSize.width, labelSize.height)];
    
    
}

- (void)setResource:(PFObject *)aResource
{
    _resource = aResource;
    
    PFImageView *catImage = [[PFImageView alloc] initWithImage:[UIImage imageNamed:[aResource objectForKey:SHRequestCategoryImageKey]]];
    
    self.portrait.profileImageView = catImage;
    
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject: [UIFont fontWithName:@"Arial" size:12] forKey:NSFontAttributeName];
    NSDictionary *arialBoldDict = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Arial-BoldMT" size:12] forKey:NSFontAttributeName];
    
    [self.titleButton setTitle:[aResource objectForKey:SHRequestOwnerKey] forState:UIControlStateNormal];
    
    NSMutableAttributedString *categoryString = [[NSMutableAttributedString alloc] initWithString:[aResource objectForKey:SHRequestNameKey] attributes:arialDict];
    NSMutableAttributedString *categoryTitleString = [[NSMutableAttributedString alloc]initWithString:@"Category: " attributes:arialBoldDict];
    
    [categoryTitleString appendAttributedString:categoryString];
    self.resourceNameLabel.attributedText = categoryTitleString;
    
}


@end
