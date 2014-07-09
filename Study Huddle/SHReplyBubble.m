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
    PFObject* creator = _replyObject[SHReplyCreator];
    [creator fetchIfNeeded];
    NSString* title = creator[SHStudentNameKey];
    NSString* content =  _replyObject[SHReplyAnswer];
    [self doLayoutWith:title andContent:content];
    
    return self;
    
}

-(id)initWithFrame:(CGRect)frame andTitle:(NSString*) title andContent: (NSString*)content
{
    self = [self initWithFrame:frame andTitle:title andContent:content andParent:nil];
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
    
    //the edit button (if its the current user)
    PFUser* creator = self.replyObject[SHReplyCreator];
    PFUser* currentUser = [PFUser currentUser];
    
    BOOL shouldSeeEditButton = ([[currentUser objectId] isEqual:[creator objectId]]);
    if(shouldSeeEditButton)
    {
        
        CGRect editFrame = CGRectMake(width-sideButtonOffsetFromRightEdge - buttonsWidth, self.titleLabel.frame.origin.y, buttonsWidth, buttonsHeight);
        UIButton* editButton = [[UIButton alloc]initWithFrame:editFrame];
        [editButton setTitle:@"EDIT POST" forState:UIControlStateNormal];
        [editButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [editButton setTitleColor:[UIColor huddleBlue] forState:UIControlStateNormal];
        [editButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        editButton.backgroundColor = [UIColor whiteColor];
        [self addSubview:editButton];
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
    NSLog(@"Reply tappped");
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
