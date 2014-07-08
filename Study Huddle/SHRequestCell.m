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
@property (nonatomic, strong) UILabel *descriptionLabel;

@end

@implementation SHRequestCell

@synthesize acceptButton;
@synthesize denyButton;
@synthesize descriptionLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        acceptButton = [[UIButton alloc]init];
        [acceptButton setImage:[UIImage imageNamed:@"Accept@2x.png"] forState:UIControlStateNormal];
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
    //[self.avatarImageView setHidden:YES];
    [self.acceptButton setFrame:CGRectMake(acceptX, requestButtonY, requestButtonWidth, requestButtonWidth)];
    
    [self.denyButton setFrame:CGRectMake(denyX, requestButtonY, requestButtonWidth, requestButtonWidth)];
    
}

- (void)setRequest:(PFObject *)aRequest
{
    _request = aRequest;
    
    //self.titleButton.titleLabel.text = aRequest;
}

#pragma mark - Delegate methods

/* Inform delegate that a user image or name was tapped */
- (void)didTapAcceptButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapAcceptCell:)]) {
        [self.delegate didTapAcceptCell:self];
    }
}
- (void)didTapDenyButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapDenyCell:)]) {
        [self.delegate didTapDenyCell:self];
    }
}


@end
