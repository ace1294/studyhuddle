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

@interface SHRequestCell ()


@property (nonatomic, strong) UIButton *acceptButton;
@property (nonatomic, strong) UIButton *denyButton;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation SHRequestCell

@synthesize acceptButton;
@synthesize denyButton;
@synthesize descriptionLabel;

#define acceptX 245.0
#define denyX acceptX+requestButtonDim+horiElemSpacing
#define requestButtonY (SHRequestCellHeight-requestButtonDim)/2
#define requestButtonDim 25.0

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.arrowButton setHidden:YES];
        
        self.messageLabel = [[UILabel alloc] init];
        [self.messageLabel setFont:self.descriptionFont];
        [self.messageLabel setTextColor:[UIColor huddleSilver]];
        [self.messageLabel setNumberOfLines:0];
        [self.messageLabel sizeToFit];
        [self.messageLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.messageLabel setBackgroundColor:[UIColor clearColor]];
        [self.mainView addSubview:self.messageLabel];

        acceptButton = [[UIButton alloc]init];
        [acceptButton setImage:[UIImage imageNamed:@"Approve@2x.png"] forState:UIControlStateNormal];
        [acceptButton addTarget:self action:@selector(didTapAcceptButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:self.acceptButton];
        
        denyButton = [[UIButton alloc]init];
        [denyButton setImage:[UIImage imageNamed:@"Deny@2x.png"] forState:UIControlStateNormal];
        [denyButton addTarget:self action:@selector(didTapDenyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:self.denyButton];
        
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize messageSize = [self.messageLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                                      options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                                   attributes:@{NSFontAttributeName:self.descriptionFont}
                                                                      context:nil].size;
    
    CGFloat messageY = self.descriptionLabel.frame.origin.y+self.descriptionLabel.frame.size.height;
    
    [self.messageLabel setFrame:CGRectMake(horiViewSpacing, messageY, messageSize.width, messageSize.height)];
    
    [self.acceptButton setFrame:CGRectMake(acceptX, requestButtonY, requestButtonDim, requestButtonDim)];
    
    [self.denyButton setFrame:CGRectMake(denyX, requestButtonY, requestButtonDim, requestButtonDim)];
    
}

- (void)setRequest:(PFObject *)aRequest
{
    _request = aRequest;
    
    NSString *type = aRequest[SHRequestTypeKey];
    
    if([type isEqualToString:SHRequestSSInviteStudy])
    {
        PFObject *student1 = aRequest[SHRequestStudent1Key];
        [student1 fetchIfNeeded];
        
        [self.titleButton setTitle:student1[SHStudentNameKey] forState:UIControlStateNormal];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mm a"];
        NSString *timeString = [formatter stringFromDate:aRequest[SHRequestTimeKey]];
        NSString *timeLocation = [NSString stringWithFormat:@"%@; %@", timeString, aRequest[SHRequestLocationKey]];
        
        [self.descriptionLabel setText:timeLocation];
        
        [self.messageLabel setText:aRequest[SHRequestDescriptionKey]];
        
    } else if([type isEqualToString:SHRequestSHJoin])
    {
        
    } else if([type isEqualToString:SHRequestHSJoin])
    {
        
    }
    
    
    [self layoutSubviews];
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
