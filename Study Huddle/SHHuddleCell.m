//
//  SHHuddleCell.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/14/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHHuddleCell.h"
#import "UIColor+HuddleColors.h"
#import "SHProfilePortraitView.h"
#import "SHConstants.h"
#import "SHUtility.h"
#import "SHPortraitView.h"

@interface SHHuddleCell ()


@property (nonatomic, strong) UILabel *membersLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *classLabel;
@property (nonatomic, strong) UIButton *arrowButton;
@property (nonatomic, strong) SHPortraitView *portrait;


- (void)didTapStudyButtonAction:(id)sender;

@end

@implementation SHHuddleCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        //[self.titleButton addTarget:self action:@selector(didTapTitleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //Avatar
        self.portrait = [[SHPortraitView alloc] initWithFrame:CGRectMake(cellPortraitX, cellPortraitY, cellPortraitDim, cellPortraitDim)];
        [self.portrait setBackgroundColor:[UIColor clearColor]];
        [self.portrait setOpaque:YES];
        [self.mainView addSubview:self.portrait];
        
        //Members
        self.membersLabel = [[UILabel alloc] init];
        [self.membersLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
        [self.membersLabel setTextColor:[UIColor huddleSilver]];
        [self.membersLabel setNumberOfLines:0];
        [self.membersLabel sizeToFit];
        [self.membersLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.membersLabel setBackgroundColor:[UIColor clearColor]];
        [self.mainView addSubview:self.membersLabel];
        
        //Status
        self.statusLabel = [[UILabel alloc] init];
        [self.statusLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
        [self.statusLabel setTextColor:[UIColor huddleSilver]];
        [self.statusLabel setNumberOfLines:0];
        [self.statusLabel sizeToFit];
        [self.statusLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.statusLabel setBackgroundColor:[UIColor clearColor]];
        [self.mainView addSubview:self.statusLabel];
        
        //Class
        self.classLabel = [[UILabel alloc] init];
        [self.classLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
        [self.classLabel setTextColor:[UIColor huddleSilver]];
        [self.classLabel setNumberOfLines:0];
        [self.classLabel sizeToFit];
        [self.classLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.classLabel setBackgroundColor:[UIColor clearColor]];
        [self.mainView addSubview:self.classLabel];
        
        self.arrowButton = [[UIButton alloc]init];
        [self.arrowButton setImage:[UIImage imageNamed:@"Right_Pointing_Arrow@2x.png"] forState:UIControlStateNormal];
        [self.arrowButton setImage:[UIImage imageNamed:@"Right_Pointing_Arrow@2x.png"] forState:UIControlStateHighlighted];
        [self.arrowButton setBackgroundColor:[UIColor clearColor]];
        //[arrowButton addTarget:self action:@selector(didTapArrowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:self.arrowButton];

        
        [self.contentView addSubview:self.mainView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    [self.portrait setFrame:CGRectMake(cellPortraitX, cellPortraitY, cellPortraitDim, cellPortraitDim)];
    
    
    
    CGSize titleSize = [self.titleButton.titleLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                            options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:16]}
                                                            context:nil].size;
    
    [self.titleButton setFrame:CGRectMake(huddleTitleX, huddleTitleY, titleSize.width, titleSize.height)];
    

    CGSize labelSize = [self.membersLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                                      options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                                   attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:12]}
                                                                      context:nil].size;
    
    [self.membersLabel setFrame:CGRectMake(huddleTitleX, huddleTitleY+self.titleButton.frame.size.height, labelSize.width, labelSize.height)];
    
    [self.classLabel setFrame:CGRectMake(huddleTitleX, self.membersLabel.frame.origin.y+self.membersLabel.frame.size.height + vertElemSpacing, labelSize.width, labelSize.height)];
    
    [self.statusLabel setFrame:CGRectMake(huddleTitleX  + self.classLabel.frame.size.width + horiElemSpacing, self.classLabel.frame.origin.y, labelSize.width, labelSize.height)];
    
    [self.arrowButton setFrame:CGRectMake(arrowX, arrowY, arrowDimX, arrowDimY)];
    
}

- (void)setHuddle:(PFObject *)aHuddle {
    
    _huddle = aHuddle;

    aHuddle[SHHuddleMembersKey] = @[[PFUser currentUser]];
    
    [self.titleButton setTitle:[aHuddle objectForKey:SHHuddleNameKey] forState:UIControlStateNormal];
    [self.titleButton setTitle:[aHuddle objectForKey:SHHuddleNameKey] forState:UIControlStateHighlighted];
    
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject: [UIFont fontWithName:@"Arial" size:12] forKey:NSFontAttributeName];

    NSMutableAttributedString *membersString = [SHUtility listOfMemberNames:[aHuddle objectForKey:SHHuddleMembersKey] attributes:arialDict];
    
    NSDictionary *arialBoldDict = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Arial-BoldMT" size:12] forKey:NSFontAttributeName];
    NSMutableAttributedString *membersTitleString = [[NSMutableAttributedString alloc]initWithString:@"Members: " attributes:arialBoldDict];
    
    
    [membersTitleString appendAttributedString:membersString];
    self.membersLabel.attributedText = membersTitleString;
    
    PFObject *tempClass = [aHuddle objectForKey:SHHuddleClassKey];
    [tempClass fetchIfNeeded];
    NSMutableAttributedString *huddleClassString = [[NSMutableAttributedString alloc] initWithString:[tempClass objectForKey:SHClassShortNameKey]  attributes: arialDict];
    NSMutableAttributedString *huddleClassTitleString = [[NSMutableAttributedString alloc]initWithString:@"Class: " attributes:arialBoldDict];
    
    [huddleClassTitleString appendAttributedString: huddleClassString];
    self.classLabel.attributedText = huddleClassTitleString;
    
    NSString *status = [[NSString alloc]init];
    
    if([[aHuddle objectForKey:SHHuddleStatusKey] isEqualToNumber:[NSNumber numberWithInt:1]])
        status = @"Open";
    else
        status  = @"Closed";
    
    NSMutableAttributedString *huddleStatusString = [[NSMutableAttributedString alloc] initWithString:status  attributes: arialDict];
    NSMutableAttributedString *huddleStatusTitleString = [[NSMutableAttributedString alloc]initWithString:@"Status: " attributes:arialBoldDict];
    
    [huddleStatusTitleString appendAttributedString:huddleStatusString];
    self.statusLabel.attributedText = huddleStatusTitleString;
    
}




#pragma mark - Delegate Methods

//- (void)didTapTitleButtonAction:(id)sender {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapTitleButton:)]) {
//        [self.delegate cell:self didTapTitleButton:self.user];
//    }
//}
//
//- (void)didTapStudyButtonAction:(id)sender {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapStudyButton:)]) {
//        [self.delegate cell:self didTapStudyButton:self.user];
//    }
//}




@end
