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

@end

@implementation SHStudyCell

- (void)setStudy:(PFObject *)aStudy
{
    _study = aStudy;
    
    if([aStudy[SHStudyOnlineKey] boolValue])
        [self.mainView setBackgroundColor:[UIColor huddleOrangeAlpha]];
    else
        [self.mainView setBackgroundColor:[UIColor whiteColor]];
    
    NSDate *studyDate = [aStudy objectForKey:SHStudyStartKey];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd/yy"];
    NSMutableAttributedString *dateString = [[NSMutableAttributedString alloc] initWithString:[formatter stringFromDate:studyDate] attributes:self.titleDict];
    
    [formatter setDateFormat:@"EEEE"];
    NSMutableAttributedString *dayString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" - %@", [formatter stringFromDate:studyDate]] attributes:self.titleDict];
    
    [dateString appendAttributedString:dayString];
    
    [dateString addAttribute:NSForegroundColorAttributeName
                   value:[UIColor huddleOrange]
                   range:NSMakeRange(0,[dateString length])];
    
    [self.titleButton setAttributedTitle:dateString forState:UIControlStateNormal];
    
    NSMutableAttributedString *classesString = [SHUtility listOfClasses:aStudy[SHStudyClassesKey] attributes:self.descriptionDict];
    NSMutableAttributedString *classesTitleString;
    if([[aStudy objectForKey:SHStudyClassesKey]count] > 1)
        classesTitleString = [[NSMutableAttributedString alloc]initWithString:@"Classes: " attributes:self.descriptionDict];
    else
        classesTitleString = [[NSMutableAttributedString alloc]initWithString:@"Class: " attributes:self.descriptionDict];
    
    [classesTitleString appendAttributedString:classesString];
    self.descriptionLabel.attributedText = classesTitleString;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
