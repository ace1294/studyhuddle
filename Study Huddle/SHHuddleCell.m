//
//  SHHuddleCell.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/14/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHHuddleCell.h"
#import "UIColor+HuddleColors.h"
#import "SHProfilePortraitViewToBeDeleted.h"
#import "SHConstants.h"
#import "SHUtility.h"
#import "SHPortraitView.h"

@interface SHHuddleCell ()

@property (nonatomic, strong) UILabel *statusLabel;
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
        [self.portrait.profileButton addTarget:self action:@selector(didTapTitleButtonAction:) forControlEvents:UIControlEventTouchDragInside];
        [self.mainView addSubview:self.portrait];
        
        //Status
        self.statusLabel = [[UILabel alloc] init];
        [self.statusLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
        [self.statusLabel setTextColor:[UIColor huddleSilver]];
        [self.statusLabel setNumberOfLines:0];
        [self.statusLabel sizeToFit];
        [self.statusLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.statusLabel setBackgroundColor:[UIColor clearColor]];
        [self.mainView addSubview:self.statusLabel];
        

        
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
    

    CGSize labelSize = [self.statusLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                                      options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                                   attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:12]}
                                                                      context:nil].size;
    

    
    [self.statusLabel setFrame:CGRectMake(huddleTitleX, huddleTitleY+self.titleButton.frame.size.height, labelSize.width, labelSize.height)];
    
    
}

- (void)setHuddle:(PFObject *)aHuddle {
    
    _huddle = aHuddle;

    PFFile* imageFile = aHuddle[SHHuddleImageKey];
    
    [self.portrait setFile:imageFile];

    [self.titleButton setTitle:[aHuddle objectForKey:SHHuddleNameKey] forState:UIControlStateNormal];
    [self.titleButton setTitle:[aHuddle objectForKey:SHHuddleNameKey] forState:UIControlStateHighlighted];
    
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject: [UIFont fontWithName:@"Arial" size:12] forKey:NSFontAttributeName];
    NSDictionary *arialBoldDict = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Arial-BoldMT" size:12] forKey:NSFontAttributeName];
    
    NSString *status = [[NSString alloc]init];
    
    if([[aHuddle objectForKey:SHHuddleStatusKey] isEqualToNumber:[NSNumber numberWithInt:1]])
        status = @"Open";
    else
        status  = @"Closed";
    
    NSMutableAttributedString *statusString = [[NSMutableAttributedString alloc] initWithString:status  attributes: arialDict];
    NSMutableAttributedString *statusTitleString = [[NSMutableAttributedString alloc]initWithString:@"Status: " attributes:arialBoldDict];
    
    [statusTitleString appendAttributedString:statusString];
    self.statusLabel.attributedText = statusTitleString;
    
}

- (void)setOnline
{
    [self.portrait setGreen];
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
