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
#import "Student.h"

@interface SHResourceCell ()

@property (nonatomic, strong) UILabel *creatorLabel;

@end

@implementation SHResourceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        //Members
        self.creatorLabel = [[UILabel alloc] init];
        [self.creatorLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
        [self.creatorLabel setTextColor:[UIColor huddleSilver]];
        [self.creatorLabel setNumberOfLines:0];
        [self.creatorLabel sizeToFit];
        [self.creatorLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.creatorLabel setBackgroundColor:[UIColor clearColor]];
        [self.mainView addSubview:self.creatorLabel];
        

        
        
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
    [self.titleButton setFrame:CGRectMake(resourceTitleX, resourceTitleY, titleSize.width, titleSize.height)];
    
    CGSize labelSize = [self.creatorLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                         options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                      attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:12]}
                                                             context:nil].size;
    
    [self.creatorLabel setFrame:CGRectMake(resourceTitleX, resourceTitleY+self.titleButton.frame.size.height, labelSize.width, labelSize.height)];
    
    
}

- (void)setResource:(PFObject *)aResource
{
    _resource = aResource;
    
    Student *creator = aResource[SHResourceCreatorKey];
    [creator fetchIfNeeded];

    NSDictionary *arialDict = [NSDictionary dictionaryWithObject: [UIFont fontWithName:@"Arial" size:12] forKey:NSFontAttributeName];
    NSDictionary *arialBoldDict = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Arial-BoldMT" size:12] forKey:NSFontAttributeName];
    
    [self.titleButton setTitle:[aResource objectForKey:SHResourceNameKey] forState:UIControlStateNormal];
    
    NSMutableAttributedString *creatorString = [[NSMutableAttributedString alloc] initWithString:creator[SHStudentNameKey] attributes:arialDict];
    NSMutableAttributedString *creatorTitleString = [[NSMutableAttributedString alloc]initWithString:@"Creator: " attributes:arialBoldDict];
    
    [creatorTitleString appendAttributedString:creatorString];
    self.creatorLabel.attributedText = creatorTitleString;
    
}


@end
