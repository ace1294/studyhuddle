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
#import "Student.h"
#import "SHPortraitView.h"

@interface SHStudentCell ()

@property (nonatomic, strong) SHPortraitView *portrait;
@property (nonatomic, strong) UILabel *classesLabel;
@property (nonatomic, strong) UILabel *majorLabel;

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
        
        //Classes
        self.classesLabel = [[UILabel alloc] init];
        [self.classesLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
        [self.classesLabel setTextColor:[UIColor huddleSilver]];
        [self.classesLabel setNumberOfLines:0];
        [self.classesLabel sizeToFit];
        [self.classesLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.classesLabel setBackgroundColor:[UIColor clearColor]];
        [self.mainView addSubview:self.classesLabel];
        
        //Major
        self.majorLabel = [[UILabel alloc] init];
        [self.majorLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
        [self.majorLabel setTextColor:[UIColor huddleSilver]];
        [self.majorLabel setNumberOfLines:0];
        [self.majorLabel sizeToFit];
        [self.majorLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.majorLabel setBackgroundColor:[UIColor clearColor]];
        [self.mainView addSubview:self.majorLabel];
        

        
        
        [self.contentView addSubview:self.mainView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    
    
    CGSize titleSize = [self.titleButton.titleLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                                      options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                                   attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:16]}
                                                                      context:nil].size;
    
    [self.titleButton setFrame:CGRectMake(studentTitleX, studentTitleY, titleSize.width, titleSize.height)];
    
    
    CGSize labelSize = [self.classesLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                            options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:12]}
                                                            context:nil].size;
    
    [self.classesLabel setFrame:CGRectMake(studentTitleX, self.titleButton.frame.size.height, 2*labelSize.width, labelSize.height)];
    
    [self.majorLabel setFrame:CGRectMake(studentTitleX, self.classesLabel.frame.origin.y+self.classesLabel.frame.size.height, 2*labelSize.width, labelSize.height)];
    
}

- (void)setStudent:(PFObject *)aStudent
{
    _student = aStudent;
    
    
    PFFile* imageFile = aStudent[SHStudentImageKey];

    
    [self.portrait setFile:imageFile];
    
    
    [self.titleButton setTitle:[aStudent objectForKey:SHStudentNameKey] forState:UIControlStateNormal];
    //[self.titleButton setTitle:[student objectForKey:SHStudentNameKey] forState:UIControlStateHighlighted];
    
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject: [UIFont fontWithName:@"Arial" size:12] forKey:NSFontAttributeName];
    NSMutableAttributedString *classesString = [SHUtility listOfClasses:[aStudent objectForKey:SHStudentClassesKey] attributes:arialDict];
    
    NSDictionary *arialBoldDict = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Arial-BoldMT" size:12] forKey:NSFontAttributeName];
    NSMutableAttributedString *classesTitleString = [[NSMutableAttributedString alloc]initWithString:@"Classes: " attributes:arialBoldDict];
    
    [classesTitleString appendAttributedString:classesString];
    self.classesLabel.attributedText = classesTitleString;
    
    NSMutableAttributedString *majorString = [[NSMutableAttributedString alloc] initWithString:[aStudent objectForKey:SHStudentMajorKey]  attributes: arialDict];
    NSMutableAttributedString *majorTitleString = [[NSMutableAttributedString alloc]initWithString:@"Major: " attributes:arialBoldDict];
    
    [majorTitleString appendAttributedString:majorString];
    self.majorLabel.attributedText = majorTitleString;
    
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
