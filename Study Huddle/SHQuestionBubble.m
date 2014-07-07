
//  SHThreadBubble.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 7/5/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHQuestionBubble.h"
#import "SHConstants.h"

#define titleHeight 40
#define titleWidth 250
#define horizontalOffest 10

#define contentWidth 250


#define replyHeight 40
#define replyWidth 250

#define charWidth 12
#define lineHeight 23


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
    self.backgroundColor = [UIColor yellowColor];
    
    float width = self.frame.size.width;
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(horizontalOffest, 0, width, titleHeight)];
    self.titleLabel.backgroundColor = [UIColor orangeColor];
    self.titleLabel.text = title;
    [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:self.titleLabel];
    
    
    //calculate the height the contentLabel will take up
    int textLength = content.length;
    float charsPerLine = width/charWidth;
    float numLines = ceil(textLength/charsPerLine);
    float contentCalcHeight = numLines*lineHeight;
    
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(horizontalOffest, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height, width, contentCalcHeight)];
    self.contentLabel.backgroundColor = [UIColor purpleColor];
    self.contentLabel.text = content;
    [self.contentLabel setTextAlignment:NSTextAlignmentLeft];
    [self.contentLabel setNumberOfLines:0];
    
    //adjust the views size
    CGRect frame = self.frame;
    frame.size.height = titleHeight + contentCalcHeight + replyHeight;
    self.frame = frame;
    [self addSubview:self.contentLabel];
    
    //reply button
    self.replyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.replyButton.frame = CGRectMake(horizontalOffest, self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height, width, replyHeight);
    self.replyButton.titleLabel.text = @"Reply";
    [self.replyButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
    self.replyButton.backgroundColor = [UIColor blueColor];
    [self addSubview:self.replyButton];
    [self.replyButton addTarget:self action:@selector(replyTapped) forControlEvents:UIControlEventTouchUpInside];
}

-(void)replyTapped
{
    [self.delegate didTapReply:self.questionObject];
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
