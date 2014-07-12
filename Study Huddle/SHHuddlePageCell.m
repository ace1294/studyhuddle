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
@property (strong, nonatomic) NSMutableDictionary *memberPortraits;

@end

@implementation SHHuddlePageCell


#define huddlePortraitX horiViewSpacing
#define huddlePortraitY vertViewSpacing
#define huddlePortraitDim 100.0

#define buttonWidth 175.0
#define buttonHeight 30.0

#define inviteStudyX huddlePortraitX+huddlePortraitDim+horiViewSpacing
#define inviteStudyY 36.0

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
    [self.askToStudyButton setBackgroundColor:[UIColor clearColor]];
    [self.askToStudyButton setTitleColor:[UIColor huddleOrange] forState:UIControlStateNormal];
    //[self.askToStudyButton setTitleColor:[UIColor huddleOrangeAlpha] forState:UIControlStateHighlighted];
    [self.askToStudyButton.titleLabel setFont: self.titleFont];
    [self.askToStudyButton.layer setBorderWidth:1.0f];
    [self.askToStudyButton.layer setBorderColor:[UIColor huddleOrange].CGColor];
    self.askToStudyButton.layer.cornerRadius = 3;
    [self.askToStudyButton setTitle:@"Invite to Study" forState:UIControlStateNormal];
    [self.askToStudyButton addTarget:self action:@selector(didTapAskStudyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:self.askToStudyButton];
    
    self.addResouceButton = [[UIButton alloc] initWithFrame:CGRectMake(addResourceX, addResourceY, buttonWidth, buttonHeight)];
    [self.addResouceButton setBackgroundColor:[UIColor clearColor]];
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
        SHPortraitView *memberPortrait = [[SHPortraitView alloc] initWithFrame:CGRectMake(memberPortraitX + ((memberPortraitDim+horiBorderSpacing)*(i%5)), memberPortraitY + ((memberPortraitDim+vertBorderSpacing)*(i/5)), memberPortraitDim, memberPortraitDim)];
        [memberPortrait setBackgroundColor:[UIColor clearColor]];
        [memberPortrait setOpaque:YES];
        [memberPortrait setFile:student[SHStudentImageKey]];
        [memberPortrait.profileButton addTarget:self action:@selector(didTapMemberAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:memberPortrait];
        
        
        i++;
    }
    
}

- (void)setHuddle:(PFObject *)aHuddle
{
    _huddle = aHuddle;
    
    [self.huddlePortrait setFile:aHuddle[SHHuddleImageKey]];
    
    [self setMembers:aHuddle[SHHuddleMembersKey]];
    
    
}



#pragma mark - Actions

- (void)didTapAskStudyAction
{
    NSLog(@"ASK to STUDY");
}

- (void)didTapAddResourceAction
{
    NSLog(@"Add resource");
}

- (void)didTapMemberAction:(id)sender
{
    NSLog(@"member Tapped");
}

@end
