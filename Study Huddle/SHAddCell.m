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
        [self.titleButton setTitle:@"Add Huddle" forState:UIControlStateNormal];
        
        
        //Avatar Button
        self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addButton setBackgroundColor:[UIColor clearColor]];
        [self.addButton setImage:[UIImage imageNamed:@"plusSign@2x.png"] forState:UIControlStateNormal];
        [self.addButton setImage:[UIImage imageNamed:@"plusSign@2x.png"] forState:UIControlStateHighlighted];
        [self.addButton addTarget:self action:@selector(didTapAddButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:self.addButton];
        
        
        
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
    
    [self.addButton setFrame:CGRectMake(addTitleX + self.titleButton.frame.size.width +vertBorderSpacing, addTitleY, addDim, addDim)];
    
    
    
}

#pragma mark - Delegate Methods

- (void)didTapAddButtonAction:(id)sender;
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapAddButton)]) {
        [self.delegate didTapAddButton];
    }
}

@end
