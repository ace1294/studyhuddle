//
//  SHNotificationCell.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/30/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHNotificationCell.h"
#import "UIColor+HuddleColors.h"
#import "SHConstants.h"
#import "NSDateFormatter+RelativeString.h"

@interface SHNotificationCell ()

@property (strong, nonatomic) UILabel *timeLabel;


@end

#define vertArrowY (SHNotificationCellHeight-arrowDimX)/2

BOOL expandable;
BOOL expanded;

@implementation SHNotificationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.arrowButton setHidden:YES];
        
        //Members
        self.timeLabel = [[UILabel alloc] init];
        [self.timeLabel setFont:self.descriptionFont];
        [self.timeLabel setTextColor:[UIColor huddleLightGrey]];
        [self.timeLabel setNumberOfLines:0];
        [self.timeLabel sizeToFit];
        [self.timeLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.timeLabel setBackgroundColor:[UIColor clearColor]];
        [self.mainView addSubview:self.timeLabel];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize timeSize = [self.descriptionLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                                      options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                                   attributes:@{NSFontAttributeName:self.descriptionFont}
                                                                      context:nil].size;
    
    if(expandable)
    {
        CGSize messageSize = [self.expandedMessageLabel.text boundingRectWithSize:CGSizeMake(descriptionMaxWidth, CGFLOAT_MAX)
                                                                          options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                                       attributes:@{NSFontAttributeName:self.descriptionFont}
                                                                          context:nil].size;
        
        CGFloat messageY = self.descriptionLabel.frame.origin.y+self.descriptionLabel.frame.size.height;
        
        [self.expandedMessageLabel setFrame:CGRectMake(horiViewSpacing, messageY, messageSize.width, messageSize.height)];
        
        [self.arrowButton setFrame:CGRectMake(arrowX, vertArrowY, arrowDimY, arrowDimX)];
    }
    
    if(expanded){
        CGFloat timeY = self.expandedMessageLabel.frame.origin.y+self.expandedMessageLabel.frame.size.height+2.0;
        [self.timeLabel setFrame:CGRectMake(horiViewSpacing, timeY, timeSize.width, timeSize.height)];
        
    } else{
        CGFloat timeY = self.descriptionLabel.frame.origin.y+self.descriptionLabel.frame.size.height+2.0;
        [self.timeLabel setFrame:CGRectMake(horiViewSpacing, timeY, timeSize.width, timeSize.height)];
    }
}


- (void)setNotification:(PFObject *)aNotification
{
    _notification = aNotification;
    
    NSString *type = aNotification[SHNotificationTypeKey];
    
    //Title Button
    [self.titleButton setTitle:[aNotification objectForKey:SHNotificationTitleKey] forState:UIControlStateNormal];
    [self.descriptionLabel setText:aNotification[SHNotificationDescriptionKey]];
    
    [self.descriptionLabel setText:[aNotification objectForKey:SHNotificationDescriptionKey]];
    
    if([aNotification[SHNotificationReadKey] boolValue])
    {
        [self.titleButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.descriptionLabel setTintColor:[UIColor grayColor]];
    }
    
    NSDate *created = [aNotification updatedAt];
    [self.timeLabel setText:[NSDateFormatter relativeDateStringFromDate:created toDate:[NSDate date]]];
    
    if([type isEqual:SHNotificationHSStudyRequestType] || [type isEqual:SHNotificationAnswerType])
    {
        [self initExpandedContent];
        self.expandedMessageLabel.text = aNotification[SHNotificationMessageKey];
    }
    
    
    [self layoutSubviews];
}

- (void)initExpandedContent
{
    expandable = true;
    
    //Members
    if (!self.expandedMessageLabel) {
        self.expandedMessageLabel = [[UILabel alloc] init];
        [self.expandedMessageLabel setFont:self.descriptionFont];
        [self.expandedMessageLabel setTextColor:[UIColor huddleSilver]];
        [self.expandedMessageLabel setNumberOfLines:0];
        [self.expandedMessageLabel sizeToFit];
        [self.expandedMessageLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.expandedMessageLabel setBackgroundColor:[UIColor clearColor]];
        [self.mainView addSubview:self.expandedMessageLabel];
        
        [self.arrowButton setImage:[UIImage imageNamed:@"DownwardArrow.png"] forState:UIControlStateNormal];
        [self.arrowButton setImage:[UIImage imageNamed:@"UpwardArrow.png"] forState:UIControlStateSelected];
        [self.arrowButton setHidden:NO];
    }
    
    [self collapse];
}

- (void)expand
{
    expanded = true;
    
    [self.arrowButton setSelected:YES];
    [self.acceptButton setHidden:NO];
    [self.denyButton setHidden:NO];
    [self.expandedMessageLabel setHidden:NO];
}

- (void)collapse
{
    expanded = false;
    
    [self.arrowButton setSelected:NO];
    [self.acceptButton setHidden:YES];
    [self.denyButton setHidden:YES];
    [self.expandedMessageLabel setHidden:YES];
    
}

- (CGFloat)heightForExpandedCell:(NSString *)message
{
    CGSize messageSize = [message boundingRectWithSize:CGSizeMake(descriptionMaxWidth, CGFLOAT_MAX)
                                               options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                            attributes:@{NSFontAttributeName:self.descriptionFont}
                                               context:nil].size;
    
    CGSize timeSize = [@"1 hour ago" boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                  options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                               attributes:@{NSFontAttributeName:self.descriptionFont}
                                                  context:nil].size;
    
    CGFloat height = self.descriptionLabel.frame.origin.y+self.descriptionLabel.frame.size.height+messageSize.height+timeSize.height+vertBorderSpacing;
    
    
    return height;
}

- (CGFloat)heightForCollapsedCell:(NSString *)message
{
    CGSize messageSize = [message boundingRectWithSize:CGSizeMake(descriptionMaxWidth, CGFLOAT_MAX)
                                               options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                            attributes:@{NSFontAttributeName:self.descriptionFont}
                                               context:nil].size;
    
    CGSize timeSize = [@"1 hour ago" boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                  options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                               attributes:@{NSFontAttributeName:self.descriptionFont}
                                                  context:nil].size;
    
    CGFloat height = self.titleButton.frame.origin.y+self.titleButton.frame.size.height+messageSize.height+timeSize.height+vertBorderSpacing;
    
    
    return height;
}

@end
