//
//  SHBaseTextCell.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/20/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHBaseTextCell.h"
#import "UIColor+HuddleColors.h"
#import "SHConstants.h"

@interface SHBaseTextCell ()



@end

@implementation SHBaseTextCell

#pragma mark - NSObject
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.clipsToBounds = YES;
        //horizontalTextSpace =  [SHBaseTextCell horizontalTextSpaceForInsetWidth:cellInsetWidth];
        
        self.opaque = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        //self.backgroundColor = [UIColor clearColor];
        
        self.mainView = [[UIView alloc] initWithFrame:self.contentView.frame];
        
        //Fonts
        self.titleFont = [UIFont fontWithName:@"Arial" size:15];
        self.descriptionFont = [UIFont fontWithName:@"Arial" size:13];
        self.titleDict = [NSDictionary dictionaryWithObject:self.titleFont forKey:NSFontAttributeName];
        self.descriptionDict = [NSDictionary dictionaryWithObject:self.descriptionFont forKey:NSFontAttributeName];
        
        //Title Button
        self.titleButton = [[UIButton alloc] init];
        [self.titleButton setBackgroundColor:[UIColor clearColor]];
        [self.titleButton setTitleColor:[UIColor huddleOrange] forState:UIControlStateNormal];
        [self.titleButton setTitleColor:[UIColor huddleOrangeAlpha] forState:UIControlStateHighlighted];
        [self.titleButton.titleLabel setFont: self.titleFont];
        [self.titleButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        self.titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.titleButton.titleLabel setNumberOfLines:0];
        [self.titleButton.titleLabel sizeToFit];
        [self.titleButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.titleButton addTarget:self action:@selector(didTapTitleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:self.titleButton];
        
        self.arrowButton = [[UIButton alloc]init];
        [self.arrowButton setImage:[UIImage imageNamed:@"Right_Pointing_Arrow@2x.png"] forState:UIControlStateNormal];
        [self.arrowButton setImage:[UIImage imageNamed:@"Right_Pointing_Arrow@2x.png"] forState:UIControlStateHighlighted];
        [self.arrowButton setBackgroundColor:[UIColor clearColor]];
        //[arrowButton addTarget:self action:@selector(didTapArrowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:self.arrowButton];
        
        
        //Members
        self.descriptionLabel = [[UILabel alloc] init];
        [self.descriptionLabel setFont:self.descriptionFont];
        [self.descriptionLabel setTextColor:[UIColor huddleSilver]];
        [self.descriptionLabel setNumberOfLines:0];
        [self.descriptionLabel sizeToFit];
        [self.descriptionLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.descriptionLabel setBackgroundColor:[UIColor clearColor]];
        [self.mainView addSubview:self.descriptionLabel];
        
        [self.mainView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.mainView];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.mainView setFrame:CGRectMake(0.0, self.contentView.frame.origin.y, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    
    CGSize titleSize = [self.titleButton.titleLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                                      options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                                   attributes:@{NSFontAttributeName:self.titleFont}
                                                                      context:nil].size;
    
    
    
    [self.titleButton setFrame:CGRectMake(horiViewSpacing, vertViewSpacing-5.0, titleSize.width, titleSize.height)];
    
    CGSize descriptionSize = [self.descriptionLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                                      options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                                   attributes:@{NSFontAttributeName:self.descriptionFont}
                                                                      context:nil].size;
    
    CGFloat descriptionY = self.titleButton.frame.origin.y+self.titleButton.frame.size.height;
    [self.descriptionLabel setFrame:CGRectMake(horiViewSpacing, descriptionY, descriptionSize.width, descriptionSize.height)];
    
    [self.arrowButton setFrame:CGRectMake(arrowX, arrowY-10.0, arrowDimX, arrowDimY)];
}

- (void)didTapTitleButtonAction:(id)sender
{
if (self.delegate && [self.delegate respondsToSelector:@selector(didTapTitleCell:)]) {
        [self.delegate didTapTitleCell:self];
    }
}


@end