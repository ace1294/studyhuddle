//
//  SHStudentCell.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/19/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHStudentCell.h"
#import "UIColor+HuddleColors.h"
#import "SHProfilePortraitViewToBeDeleted.h"
#import "SHUtility.h"
#import "SHPortraitView.h"

@interface SHStudentCell ()

@property (nonatomic, strong) SHPortraitView *portrait;
@end

@implementation SHStudentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        //[self.titleButton addTarget:self action:@selector(didTapTitleButtonAction:) forControlEvents:UIControlEventTouchUpInside];

        
        //Avatar
        self.portrait = [[SHPortraitView alloc]initWithFrame:CGRectMake(cellPortraitX, cellPortraitY, cellPortraitDim, cellPortraitDim)];
        [self.portrait setBackgroundColor:[UIColor clearColor]];
        [self.portrait setOpaque:YES];
        [self.portrait.profileButton addTarget:self action:@selector(didTapTitleButtonAction:) forControlEvents:UIControlEventTouchDragInside];
        [self.mainView addSubview:self.portrait];
        
        [self.contentView addSubview:self.mainView];
    }
    return self;
}

- (void) layoutSubviews
{
    CGSize titleSize = [self.titleButton.titleLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                                      options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                                   attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:18]}
                                                                      context:nil].size;
    
    
    
    [self.titleButton setFrame:CGRectMake(studentTitleX, studentTitleY, titleSize.width, titleSize.height)];
    
    CGSize descriptionSize = [self.descriptionLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                                      options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                                   attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:14]}
                                                                      context:nil].size;
    CGFloat descriptionY = self.titleButton.frame.origin.y+self.titleButton.frame.size.height;
    [self.descriptionLabel setFrame:CGRectMake(studentTitleX, descriptionY, descriptionSize.width, descriptionSize.height)];
}

- (void)setStudent:(PFUser *)aStudent
{
    _student = aStudent;
    
    
    PFFile* imageFile = aStudent[SHStudentImageKey];

    
    [self.portrait setFile:imageFile];
    
    
    [self.titleButton setTitle:[aStudent objectForKey:SHStudentNameKey] forState:UIControlStateNormal];
    
    NSMutableAttributedString *majorString = [[NSMutableAttributedString alloc] initWithString:[aStudent objectForKey:SHStudentMajorKey]  attributes: self.descriptionDict];
    NSMutableAttributedString *majorTitleString = [[NSMutableAttributedString alloc]initWithString:@"Major: " attributes:self.descriptionDict];
    
    [majorTitleString appendAttributedString:majorString];
    self.descriptionLabel.attributedText = majorTitleString;
    
    [self layoutSubviews];
}

- (void)setOnline
{
    [self.portrait setGreen];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
