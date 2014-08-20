//
//  SHRequestCell.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/14/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHRequestCell.h"
#import "UIColor+HuddleColors.h"
#import "SHConstants.h"
#import "NSDateFormatter+RelativeString.h"

@interface SHRequestCell ()

@property (strong, nonatomic) UILabel *timeLabel;

@end

@implementation SHRequestCell

@synthesize acceptButton;
@synthesize denyButton;
@synthesize descriptionLabel;

#define vertArrowY (SHNotificationCellHeight-arrowDimX)/2
#define vertExpandedArrowY vertElemSpacing+2.0

#define acceptX 245.0
#define denyX acceptX+requestButtonDim+horiElemSpacing
#define requestButtonY (SHRequestCellHeight-requestButtonDim)/2
#define requestButtonDim 25.0

#define vertButtonX arrowX-((requestButtonDim-arrowDimY)/2)
#define vertAcceptY vertExpandedArrowY+arrowDimX+vertElemSpacing
#define vertDenyY vertAcceptY+requestButtonDim+vertElemSpacing

BOOL expandable;
BOOL expanded;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.arrowButton setHidden:YES];
        
        acceptButton = [[UIButton alloc]init];
        [acceptButton setImage:[UIImage imageNamed:@"Approve@2x.png"] forState:UIControlStateNormal];
        [acceptButton addTarget:self action:@selector(didTapAcceptButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:self.acceptButton];
        
        denyButton = [[UIButton alloc]init];
        [denyButton setImage:[UIImage imageNamed:@"Deny@2x.png"] forState:UIControlStateNormal];
        [denyButton addTarget:self action:@selector(didTapDenyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:self.denyButton];
        
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


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize timeSize = [self.timeLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                              options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                           attributes:@{NSFontAttributeName:self.descriptionFont}
                                                              context:nil].size;
    

    CGSize messageSize = [self.expandedMessageLabel.text boundingRectWithSize:CGSizeMake(descriptionMaxWidth, CGFLOAT_MAX)
                                                                  options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                               attributes:@{NSFontAttributeName:self.descriptionFont}
                                                                  context:nil].size;
        
    CGFloat messageY = self.descriptionLabel.frame.origin.y+self.descriptionLabel.frame.size.height;
        
    [self.expandedMessageLabel setFrame:CGRectMake(horiViewSpacing, messageY, messageSize.width, messageSize.height)];
        
    [self.acceptButton setFrame:CGRectMake(vertButtonX, vertAcceptY, requestButtonDim, requestButtonDim)];
    [self.denyButton setFrame:CGRectMake(vertButtonX, vertDenyY, requestButtonDim, requestButtonDim)];
        
    if(expanded){
        CGFloat timeY = self.expandedMessageLabel.frame.origin.y+self.expandedMessageLabel.frame.size.height+2.0;
        [self.timeLabel setFrame:CGRectMake(horiViewSpacing, timeY, timeSize.width, timeSize.height)];
        [self.arrowButton setFrame:CGRectMake(arrowX, vertExpandedArrowY, arrowDimY, arrowDimX)];
        
    } else{
        CGFloat timeY = self.descriptionLabel.frame.origin.y+self.descriptionLabel.frame.size.height+2.0;
        [self.timeLabel setFrame:CGRectMake(horiViewSpacing, timeY, timeSize.width, timeSize.height)];
        [self.arrowButton setFrame:CGRectMake(arrowX, vertArrowY, arrowDimY, arrowDimX)];
    }
    
    
}

- (void)setRequest:(PFObject *)aRequest
{
    _request = aRequest;
    
    [self.titleButton setTitle:aRequest[SHRequestTitleKey] forState:UIControlStateNormal];
    NSDate *created = [aRequest updatedAt];
    [self.timeLabel setText:[NSDateFormatter relativeDateStringFromDate:created toDate:[NSDate date]]];
    
    [self initExpandedContent];
    [self.descriptionLabel setText:aRequest[SHRequestDescriptionKey]];
        
    [self.expandedMessageLabel setText:aRequest[SHRequestMessageKey]];
    
    [self layoutSubviews];
}

- (void)setSentRequest:(PFObject *)aSentRequest
{
    _request = aSentRequest;
    
    [self.titleButton setTitle:aSentRequest[SHRequestSentTitleKey] forState:UIControlStateNormal];
    NSDate *created = [aSentRequest updatedAt];
    [self.timeLabel setText:[NSDateFormatter relativeDateStringFromDate:created toDate:[NSDate date]]];

    [self.descriptionLabel setText:aSentRequest[SHRequestSentDescriptionKey]];
    
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
    [self.expandedMessageLabel setHidden:YES];
    [self.acceptButton setHidden:YES];
    [self.denyButton setHidden:YES];
    

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


#pragma mark - Delegate methods

/* Inform delegate that a user image or name was tapped */
- (void)didTapAcceptButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapAccept:)]) {
        [self.delegate didTapAccept:self.request];
    }
}
- (void)didTapDenyButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapDeny:)]) {
        [self.delegate didTapDeny:self.request];
    }
}


@end
