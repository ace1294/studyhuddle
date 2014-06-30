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
        
        //Title Button
        self.titleButton = [[UIButton alloc] init];
        [self.titleButton setBackgroundColor:[UIColor clearColor]];
        [self.titleButton setTitleColor:[UIColor huddleOrange] forState:UIControlStateNormal];
        [self.titleButton setTitleColor:[UIColor huddleOrangeAlpha] forState:UIControlStateHighlighted];
        [self.titleButton.titleLabel setFont: [UIFont fontWithName:@"Arial-BoldMT" size:16]];
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
        
        [self.mainView setBackgroundColor:[UIColor huddleCell]];
        [self.contentView addSubview:self.mainView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //self.contentView.frame.size.width-2*cellInsetWidth
    [self.mainView setFrame:CGRectMake(0.0, self.contentView.frame.origin.y, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    
    
    [self.titleButton setFrame:CGRectMake(10.0, 10.0, 200.0, 40.0)];

    [self.arrowButton setFrame:CGRectMake(arrowX, arrowY, arrowDimX, arrowDimY)];
}

- (void)didTapTitleButtonAction:(id)sender
{
if (self.delegate && [self.delegate respondsToSelector:@selector(didTapTitleCell:)]) {
        [self.delegate didTapTitleCell:self];
    }
}


@end