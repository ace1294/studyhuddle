//
//  SHHuddlePageCell.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/12/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHHuddlePageCell.h"
#import "SHPortraitView.h"
#import "UIColor+HuddleColors.h"
#import "SHConstants.h"

@interface SHHuddlePageCell ()

//Huddle Prof Portrait
@property (strong, nonatomic) SHPortraitView *huddlePortrait;

//Buttons
@property (strong, nonatomic) UIButton *askToStudyButton;
@property (strong, nonatomic) UIButton *addResouceButton;

//Members
@property (strong, nonatomic) NSMutableArray *memberPortraits;
@property (strong, nonatomic) NSMutableArray *memberObjects;

@end

@implementation SHHuddlePageCell


#define huddlePortraitX horiViewSpacing
#define huddlePortraitY vertViewSpacing
#define huddlePortraitDim 100.0

#define buttonWidth 175.0
#define buttonHeight 30.0

#define huddleTitleX huddlePortraitX+huddlePortraitDim+horiViewSpacing
#define huddleTitleY huddlePortraitY

#define inviteStudyX huddleTitleX
#define inviteStudyY 40.0

#define addResourceX inviteStudyX
#define addResourceY inviteStudyY+buttonHeight+vertElemSpacing

#define memberPortraitX horiViewSpacing
#define memberPortraitY huddlePortraitY+huddlePortraitDim+vertBorderSpacing
#define memberPortraitDim 50.0

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initButtons];
        
        self.memberObjects = [[NSMutableArray alloc]init];
        self.memberPortraits = [[NSMutableArray alloc]init];
        
        
        
        [self.arrowButton setHidden:YES];
        
                
    }
    return self;
}

- (void)initButtons
{
    [self.titleButton.titleLabel setFont:[UIFont fontWithName:@"Arial" size:18.0]];
    
    self.huddlePortrait = [[SHPortraitView alloc] initWithFrame:CGRectMake(huddlePortraitX, huddlePortraitY, huddlePortraitDim, huddlePortraitDim)];
    [self.huddlePortrait setBackgroundColor:[UIColor clearColor]];
    [self.huddlePortrait setOpaque:YES];
    [self.huddlePortrait.profileButton addTarget:self action:@selector(didTapTitleButtonAction:) forControlEvents:UIControlEventTouchDragInside];
    [self.mainView addSubview:self.huddlePortrait];

    
    self.askToStudyButton = [[UIButton alloc] initWithFrame:CGRectMake(inviteStudyX, inviteStudyY, buttonWidth, buttonHeight)];
    [self.askToStudyButton setBackgroundColor:[UIColor whiteColor]];
    [self.askToStudyButton setTitleColor:[UIColor huddleOrange] forState:UIControlStateNormal];
    //[self.askToStudyButton setTitleColor:[UIColor huddleOrangeAlpha] forState:UIControlStateHighlighted];
    [self.askToStudyButton.titleLabel setFont: self.titleFont];
    [self.askToStudyButton.layer setBorderWidth:1.0f];
    [self.askToStudyButton.layer setBorderColor:[UIColor huddleOrange].CGColor];
    self.askToStudyButton.layer.cornerRadius = 3;
    [self.askToStudyButton setTitle:@"Invite to Study" forState:UIControlStateNormal];
    [self.askToStudyButton addTarget:self action:@selector(didTapInviteToStudyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:self.askToStudyButton];
    
    self.addResouceButton = [[UIButton alloc] initWithFrame:CGRectMake(addResourceX, addResourceY, buttonWidth, buttonHeight)];
    [self.addResouceButton setBackgroundColor:[UIColor whiteColor]];
    [self.addResouceButton setTitleColor:[UIColor huddlePurple] forState:UIControlStateNormal];
    //[self.addResouceButton setTitleColor:[UIColor huddleOrangeAlpha] forState:UIControlStateHighlighted];
    [self.addResouceButton.titleLabel setFont: self.titleFont];
    [self.addResouceButton.layer setBorderWidth:1.0f];
    [self.addResouceButton.layer setBorderColor:[UIColor huddlePurple].CGColor];
    self.addResouceButton.layer.cornerRadius = 3;
    [self.addResouceButton setTitle:@"Add Resources" forState:UIControlStateNormal];
    [self.addResouceButton addTarget:self action:@selector(didTapAddResourceAction) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:self.addResouceButton];
}

- (void)setMembers:(NSArray *)students
{
    int i = 0;
    
    for (PFObject *student in students)
    {
        [student fetchIfNeeded];
        [self.memberObjects addObject:student];
        
        SHPortraitView *memberPortrait = [[SHPortraitView alloc] initWithFrame:CGRectMake(memberPortraitX + ((memberPortraitDim+horiBorderSpacing)*(i%5)), memberPortraitY + ((memberPortraitDim+vertBorderSpacing)*(i/5)), memberPortraitDim, memberPortraitDim)];
        [memberPortrait setBackgroundColor:[UIColor clearColor]];
        [memberPortrait setOpaque:YES];
        [memberPortrait setFile:student[SHStudentImageKey]];
        [memberPortrait.profileButton addTarget:self action:@selector(didTapMemberAction:) forControlEvents:UIControlEventTouchUpInside];
        memberPortrait.profileButton.tag = i;
        [self.memberPortraits addObject:memberPortrait];
        [self.mainView addSubview:memberPortrait];
        
        
        i++;
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.mainView setFrame:CGRectMake(0.0, self.contentView.frame.origin.y, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    
    CGSize titleSize = [self.titleButton.titleLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                                      options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                                   attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:18]}
                                                                      context:nil].size;
    
    
    CGFloat offset = (buttonWidth-titleSize.width)/2;
    [self.titleButton setFrame:CGRectMake(huddleTitleX+offset, huddleTitleY, titleSize.width, titleSize.height)];
    
}

- (void)setHuddle:(PFObject *)aHuddle
{
    _huddle = aHuddle;
    
    [self.huddlePortrait setFile:aHuddle[SHHuddleImageKey]];
    
    [self setMembers:aHuddle[SHHuddleMembersKey]];
    
    [self.titleButton setTitle:aHuddle[SHHuddleNameKey] forState:UIControlStateNormal];
    
    [self layoutSubviews];
}



#pragma mark - Actions

- (void)didTapInviteToStudyAction
{
    [self.delegate didTapInviteToStudy:self.huddle];
}

- (void)didTapAddResourceAction
{
    [self.delegate didTapAddResource:self.huddle];
}

- (void)didTapMemberAction:(id)sender
{
    PFObject *member = self.memberObjects[[sender tag]];
    
    [self.delegate didTapMember:member];
}

@end
