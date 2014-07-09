
//  SHThreadBubble.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 7/5/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHQuestionBubble.h"
#import "SHConstants.h"
#import "UIColor+HuddleColors.h"

#define titleHeight 40
#define titleWidth 250
#define horizontalOffest 20

#define contentWidth 250


#define buttonsHeight 20
#define buttonsWidth 80

#define charWidth 12
#define lineHeight 23

#define roundness 3.0f

#define sideButtonOffsetFromRightEdge 20
#define spaceBetweenTextAndLine 3

@interface SHQuestionBubble()

@property UILabel* titleLabel;
@property UILabel* userLabel;
@property UILabel* contentLabel;
@property UIButton* replyButton;
@property PFObject* questionObject;
@property PFObject* parent;

@end

@implementation SHQuestionBubble


- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame andTitle:@"blank" andContent:@"blank" andParent:nil];
    return self;
}

-(id)initWithFrame:(CGRect)frame andTitle:(NSString*) title andContent: (NSString*)content
{
    self = [self initWithFrame:frame andTitle:title andContent:content andParent:nil];
    return self;
}

-(id)initWithQuestion: (PFObject*)questionObject andFrame: (CGRect)frame
{
    self = [super initWithFrame:frame];
    
    _questionObject = questionObject;
    [_questionObject fetchIfNeeded];
    PFObject* creator = _questionObject[SHQuestionCreator];
    [creator fetchIfNeeded];
    NSString* title = creator[SHStudentNameKey];
    NSString* content =  _questionObject[SHQuestionQuestion];
    [self doLayoutWith:title andContent:content];
    
    return self;
    
}

-(id)initWithFrame:(CGRect)frame andTitle:(NSString*) title andContent: (NSString*)content andParent:(PFObject*)parent
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _parent = parent;
        [self doLayoutWith:title andContent:content];
    }
    return self;
}

-(void)doLayoutWith:(NSString*)title andContent: (NSString*)content
{
    self.backgroundColor = [UIColor lightGrayColor];
    
    float width = self.frame.size.width;
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(horizontalOffest, 0, width-horizontalOffest-roundness, titleHeight)];
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    self.titleLabel.text = title;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.titleLabel.textColor = [UIColor huddleSilver];
    [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:self.titleLabel];
    self.titleLabel.layer.cornerRadius = roundness;
    
    
    //the edit button/replyButton
    PFUser* creator = self.questionObject[SHReplyCreator];
    PFUser* currentUser = [PFUser currentUser];
    CGRect editFrame = CGRectMake(width-sideButtonOffsetFromRightEdge - buttonsWidth, self.titleLabel.frame.origin.y, buttonsWidth, buttonsHeight);
    UIButton* editButton = [[UIButton alloc]initWithFrame:editFrame];
    editButton.backgroundColor = [UIColor whiteColor];
    [editButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [editButton setTitleColor:[UIColor huddleBlue] forState:UIControlStateNormal];
    [editButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self addSubview:editButton];
    
    BOOL shouldSeeEditButton = ([[currentUser objectId] isEqual:[creator objectId]]);
    if(shouldSeeEditButton)
    {
        [editButton setTitle:@"EDIT POST" forState:UIControlStateNormal];
        [editButton addTarget:self action:@selector(editTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [editButton setTitle:@"REPLY TO POST" forState:UIControlStateNormal];
        [editButton addTarget:self action:@selector(replyTapped) forControlEvents:UIControlEventTouchUpInside];
    }

    
    
    //calculate the height the contentLabel will take up
    int textLength = content.length;
    float charsPerLine = (width-horizontalOffest-roundness)/charWidth;
    float numLines = ceil(textLength/charsPerLine);
    float contentCalcHeight = numLines*lineHeight;
    
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(horizontalOffest, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height, width-horizontalOffest-roundness, contentCalcHeight)];
    self.contentLabel.backgroundColor = [UIColor whiteColor];
    self.contentLabel.text = content;
    self.contentLabel.font = [UIFont systemFontOfSize:12];
    self.contentLabel.textColor = [UIColor huddleSilver];
    [self.contentLabel setTextAlignment:NSTextAlignmentLeft];
    [self.contentLabel setNumberOfLines:0];
    self.contentLabel.layer.cornerRadius = roundness;
    
    
    //adjust the views size
    CGRect frame = self.frame;
    frame.size.height = titleHeight + contentCalcHeight + buttonsHeight + spaceBetweenTextAndLine;
    self.frame = frame;
    [self addSubview:self.contentLabel];
    
    //make a frame around it
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = roundness;
    
}

-(void)replyTapped
{
    [self.delegate didTapReply:self.questionObject];
}

-(void)editTapped
{
    
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
