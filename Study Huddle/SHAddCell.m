//
//  SHAddCell.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/14/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHAddCell.h"
#import "UIColor+HuddleColors.h"
#import "SHConstants.h"

@interface SHAddCell ()

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIButton *titleButton;




@end

@implementation SHAddCell

@synthesize addButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.titleButton addTarget:self action:@selector(didTapAddButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleButton.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
        [self.titleButton setTitle:@"Add Class" forState:UIControlStateNormal];
        
        
        //Avatar Button
        self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addButton setBackgroundColor:[UIColor clearColor]];
        [self.addButton setImage:[UIImage imageNamed:@"plusSign@2x.png"] forState:UIControlStateNormal];
        [self.addButton setImage:[UIImage imageNamed:@"plusSign@2x.png"] forState:UIControlStateHighlighted];
        [self.addButton addTarget:self action:@selector(didTapAddButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:self.addButton];
        
        [self.arrowButton setHidden:YES];
        
        self.typeIdentifier = [[NSString alloc]init];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize titleSize = [self.titleButton.titleLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                                      options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                                   attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:16]}
                                                                      context:nil].size;
    
    [self.titleButton setFrame:CGRectMake(addTitleX, addTitleY, titleSize.width, titleSize.height)];
    
    [self.addButton setFrame:CGRectMake(addTitleX + self.titleButton.frame.size.width +vertBorderSpacing +vertBorderSpacing, addTitleY, addDim, addDim)];
    
    
    
}

- (void)setAdd:(NSString *)addTitle identifier:(NSString *)cellID
{
    CGSize titleSize = [self.titleButton.titleLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                                      options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                                   attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:16]}
                                                                      context:nil].size;
    
    [self.titleButton setTitle:addTitle forState:UIControlStateNormal];
    [self.titleButton setFrame:CGRectMake(addTitleX, addTitleY, titleSize.width, titleSize.height)];
    
    [self.addButton setFrame:CGRectMake(addTitleX + self.titleButton.frame.size.width +vertBorderSpacing +vertBorderSpacing, addTitleY, addDim, addDim)];

    self.typeIdentifier = cellID;
}

#pragma mark - Delegate Methods

- (void)didTapAddButtonAction:(id)sender;
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapAddButton:)]) {
        [self.delegate didTapAddButton:self];
    }
}

@end
