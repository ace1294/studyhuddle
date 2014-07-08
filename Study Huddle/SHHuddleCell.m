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

@property (nonatomic, strong) SHPortraitView *portrait;

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

    }
    return self;
}

- (void) layoutSubviews
{
    CGSize titleSize = [self.titleButton.titleLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                                      options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                                   attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:18]}
                                                                      context:nil].size;
    
    
    
    [self.titleButton setFrame:CGRectMake(huddleTitleX, huddleTitleY, titleSize.width, titleSize.height)];
    
    CGSize descriptionSize = [self.descriptionLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                                      options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                                   attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:14]}
                                                                      context:nil].size;
    CGFloat descriptionY = self.titleButton.frame.origin.y+self.titleButton.frame.size.height;
    [self.descriptionLabel setFrame:CGRectMake(huddleTitleX, descriptionY, descriptionSize.width, descriptionSize.height)];
}



- (void)setHuddle:(PFObject *)aHuddle {
    
    _huddle = aHuddle;

    PFFile* imageFile = aHuddle[SHHuddleImageKey];
    
    [self.portrait setFile:imageFile];

    [self.titleButton setTitle:[aHuddle objectForKey:SHHuddleNameKey] forState:UIControlStateNormal];
    
    NSString *status = [[NSString alloc]init];
    
    if([[aHuddle objectForKey:SHHuddleStatusKey] isEqualToNumber:[NSNumber numberWithInt:1]])
        status = @"Open";
    else
        status  = @"Closed";
    
    NSMutableAttributedString *statusString = [[NSMutableAttributedString alloc] initWithString:status  attributes: self.descriptionDict];
    NSMutableAttributedString *statusTitleString = [[NSMutableAttributedString alloc]initWithString:@"Status: " attributes:self.descriptionDict];
    
    [statusTitleString appendAttributedString:statusString];
    self.descriptionLabel.attributedText = statusTitleString;
    
    [self layoutSubviews];
    
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
