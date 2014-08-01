//
//  SHReplyBubble.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 7/6/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHReplyBubble.h"
#import "SHConstants.h"
#import "UIColor+HuddleColors.h"

#define titleHeight 40
#define titleWidth 250
#define horizontalOffest 20

#define contentWidth 250


#define buttonsHeight 20
#define buttonsWidth 80

#define charWidth 4
#define lineHeight 15

#define roundness 3.0f

#define lineThickness 2
#define spaceBetweenTextAndLine 3

#define sideButtonOffsetFromRightEdge 20



@interface SHReplyBubble()

@property UILabel* titleLabel;
@property UILabel* userLabel;
@property UILabel* contentLabel;
@property PFObject* replyObject;
@property PFObject* parent;

@end

@implementation SHReplyBubble


- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame andTitle:@"blank" andContent:@"blank" andParent:nil];
    return self;
}

-(id)initWithReply: (PFObject*)replyObject andFrame: (CGRect)frame
{
    self = [super initWithFrame:frame];
    
    _replyObject = replyObject;
    [_replyObject fetchIfNeeded];
    [self doLayout];
    
    return self;
    
}


-(void)doLayout
{
    self.backgroundColor = [UIColor lightGrayColor];
    
    float width = self.frame.size.width;
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(horizontalOffest, 0, width-horizontalOffest-roundness, titleHeight)];
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    self.titleLabel.text = self.replyObject[SHReplyCreatorName];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.titleLabel.textColor = [UIColor huddleSilver];
    [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
    self.titleLabel.layer.cornerRadius = roundness;
    
    //the edit button (if its the current user)
    NSString* creatorID = self.replyObject[SHReplyCreatorID];
    NSString* currentUserID = [[PFUser currentUser] objectId];
    
    BOOL shouldSeeEditButton = ([currentUserID isEqualToString:creatorID]);
    UIButton* editButton;
    if(shouldSeeEditButton)
    {
        
        CGRect editFrame = CGRectMake(width-sideButtonOffsetFromRightEdge - buttonsWidth, self.titleLabel.frame.origin.y + (titleHeight-buttonsHeight)/2, buttonsWidth, buttonsHeight);
        editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        editButton.frame = editFrame;
        [editButton setTitle:@"EDIT POST" forState:UIControlStateNormal];
        [editButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [editButton setTitleColor:[UIColor huddleBlue] forState:UIControlStateNormal];
        [editButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        editButton.backgroundColor = [UIColor whiteColor];
        
        [editButton addTarget:self action:@selector(editTaped) forControlEvents:UIControlEventTouchUpInside];
        
        
        
    }
    
    

    
    
    self.contentLabel = [[UILabel alloc]init];
    //self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(horizontalOffest, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height, width-horizontalOffest-roundness, contentCalcHeight)];
    self.contentLabel.backgroundColor = [UIColor whiteColor];
    self.contentLabel.text = self.replyObject[SHReplyAnswer];
    CGSize descriptionSize = [self.contentLabel.text boundingRectWithSize:CGSizeMake(width-horizontalOffest-roundness, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.textColor = [UIColor huddleSilver];
    [self.contentLabel setTextAlignment:NSTextAlignmentLeft];
    [self.contentLabel setNumberOfLines:0];
    self.contentLabel.layer.cornerRadius = roundness;
    self.contentLabel.frame = CGRectMake(horizontalOffest, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height-2, width-horizontalOffest-roundness, descriptionSize.height);

    
    //adjust the views size
    CGRect frame = self.frame;
    frame.size.height = titleHeight + descriptionSize.height + buttonsHeight + spaceBetweenTextAndLine;
    self.frame = frame;
    [self addSubview:self.contentLabel];
    [self addSubview:self.titleLabel];
    [self addSubview:editButton];
    
    //make a frame around it
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = roundness;
    
}

-(void)editTaped
{
    [self.delegate didTapEditReply:self.replyObject];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
