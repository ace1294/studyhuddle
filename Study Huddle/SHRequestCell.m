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

        //[self.titleButton addTarget:self action:@selector(didTapTitleButtonAction:) forControlEvents:UIControlEventTouchUpInside];

        
        acceptButton = [[UIButton alloc]init];
        [acceptButton setImage:[UIImage imageNamed:@"Accept@2x.png"] forState:UIControlStateNormal];
        [acceptButton addTarget:self action:@selector(didTapAcceptButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:self.acceptButton];
        
        denyButton = [[UIButton alloc]init];
        [denyButton setImage:[UIImage imageNamed:@"Deny@2x.png"] forState:UIControlStateNormal];
        [denyButton addTarget:self action:@selector(didTapDenyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:self.denyButton];
        
        descriptionLabel = [[UILabel alloc]init];
        [descriptionLabel setFont:[UIFont fontWithName:@"Arial" size:10]];
        [descriptionLabel setTextColor:[UIColor huddleSilver]];
        [descriptionLabel setNumberOfLines:0];
        [descriptionLabel sizeToFit];
        [descriptionLabel setBackgroundColor:[UIColor clearColor]];
        [self.mainView addSubview:self.descriptionLabel];
        
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    //[self.avatarImageView setHidden:YES];
    [self.acceptButton setFrame:CGRectMake(acceptX, acceptY, acceptDimX, acceptDimY)];
    
    [self.denyButton setFrame:CGRectMake(denyX, denyY, denyDimX, denyDimY)];
    
    [self.descriptionLabel setFrame:CGRectMake(20.0, 20.0, 100.0, 20.0)];
    self.descriptionLabel.text = @"Jason wants to study with you";
    
}

#pragma mark - Delegate methods

///* Inform delegate that a user image or name was tapped */
//- (void)didTapAcceptButtonAction:(id)sender {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapAcceptButton:)]) {
//        [self.delegate cell:self didTapAcceptButton:self.user];
//    }
//}
//
///* Inform delegate that a user image or name was tapped */
//- (void)didTapDenyButtonAction:(id)sender {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapDenyButton:)]) {
//        [self.delegate cell:self didTapDenyButton:self.user];
//    }
//}

@end
