//
//  SHStudyCell.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/20/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHStudyCell.h"
#import "UIColor+HuddleColors.h"
#import "SHConstants.h"
#import "SHUtility.h"

@interface SHStudyCell ()

@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *timeLabel;


@end

@implementation SHStudyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //Members
        self.dateLabel = [[UILabel alloc] init];
        [self.dateLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
        [self.dateLabel setTextColor:[UIColor huddleSilver]];
        [self.dateLabel setNumberOfLines:0];
        [self.dateLabel sizeToFit];
        [self.dateLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.dateLabel setBackgroundColor:[UIColor clearColor]];
        [self.mainView addSubview:self.dateLabel];
        
        //Status
        self.timeLabel = [[UILabel alloc] init];
        [self.timeLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
        [self.timeLabel setTextColor:[UIColor huddleSilver]];
        [self.timeLabel setNumberOfLines:0];
        [self.timeLabel sizeToFit];
        [self.timeLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.timeLabel setBackgroundColor:[UIColor clearColor]];
        [self.mainView addSubview:self.timeLabel];
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    CGSize titleSize = [self.titleButton.titleLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                                      options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                                   attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:16]}
                                                                      context:nil].size;
    [self.titleButton setFrame:CGRectMake(studyTitleX, studyTitleY, titleSize.width, titleSize.height)];
    
    CGSize labelSize = [self.dateLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                            options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:12]}
                                                            context:nil].size;
    [self.dateLabel setFrame:CGRectMake(studyTitleX, studyTitleY+self.titleButton.frame.size.height, labelSize.width, labelSize.height)];
    
    [self.timeLabel setFrame:CGRectMake(studyTitleX + self.dateLabel.frame.size.width+horiElemSpacing, self.dateLabel.frame.origin.y, labelSize.width, labelSize.height)];
    
}

- (void)setStudy:(PFObject *)aStudy
{
    _study = aStudy;
    
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject: [UIFont fontWithName:@"Arial" size:12] forKey:NSFontAttributeName];
    NSDictionary *arialBoldDict = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Arial-BoldMT" size:12] forKey:NSFontAttributeName];
    
    NSMutableAttributedString *classesString = [SHUtility listOfClasses:[aStudy relationForKey:SHStudyClassesKey] attributes:arialBoldDict];
    [self.titleButton setAttributedTitle:classesString forState:UIControlStateNormal];
    
    NSDate *studyDate = [aStudy objectForKey:SHStudyDateKey];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"mm/dd/yy"];
    NSMutableAttributedString *dateString = [[NSMutableAttributedString alloc] initWithString:[formatter stringFromDate:studyDate] attributes:arialDict];
    NSMutableAttributedString *dateTitleString = [[NSMutableAttributedString alloc]initWithString:@"Date: " attributes:arialBoldDict];
    
    [dateTitleString appendAttributedString:dateString];
    self.dateLabel.attributedText = dateTitleString;
    
//    NSMutableAttributedString *timeString = [[NSMutableAttributedString alloc] initWithString:[aStudy objectForKey:SHStudentMajorKey]  attributes: arialDict];
//    NSMutableAttributedString *timeTitleString = [[NSMutableAttributedString alloc]initWithString:@"Time: " attributes:arialBoldDict];
//
//    
//    [timeTitleString appendAttributedString:timeString];
//    self.timeLabel.attributedText = timeTitleString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
