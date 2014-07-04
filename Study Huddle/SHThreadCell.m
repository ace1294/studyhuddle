//
//  SHNotificationCell.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/30/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHThreadCell.h"
#import "UIColor+HuddleColors.h"
#import "SHConstants.h"
#import "Student.h"

@interface SHThreadCell ()

@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic,strong) PFObject* threadObject;

@end

@implementation SHThreadCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //Members
        self.infoLabel = [[UILabel alloc] init];
        [self.infoLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
        [self.infoLabel setTextColor:[UIColor huddleSilver]];
        [self.infoLabel setNumberOfLines:0];
        [self.infoLabel sizeToFit];
        [self.infoLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.infoLabel setBackgroundColor:[UIColor clearColor]];
        [self.mainView addSubview:self.infoLabel];
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
    [self.titleButton setFrame:CGRectMake(titleX, titleY, titleSize.width, titleSize.height)];
    
    CGSize labelSize = [self.infoLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                         options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                      attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:12]}
                                                         context:nil].size;
    
    [self.infoLabel setFrame:CGRectMake(titleX, titleY+self.titleButton.frame.size.height, labelSize.width, labelSize.height)];
    
    CGRect arrowFrame = self.arrowButton.frame;
    arrowFrame.origin.y = self.frame.size.height/2-arrowFrame.size.height/2;
    self.arrowButton.frame = arrowFrame;
    
    
    
    
}

- (void)setThread:(PFObject *)aThread
{
    self.threadObject = aThread;
    
    //Title Button
    [self.titleButton setTitle:[aThread objectForKey:SHThreadQuestion] forState:UIControlStateNormal];
    [self.titleButton setTitle:[aThread objectForKey:SHThreadQuestion] forState:UIControlStateHighlighted];
    
    Student* student = [aThread objectForKey:SHThreadCreator];
    [student fetchIfNeeded];
    [self.infoLabel setText:student.fullName];
    
    
    
    [self layoutSubviews];
}

-(PFObject*)getThread
{
    return self.threadObject;
}

@end
