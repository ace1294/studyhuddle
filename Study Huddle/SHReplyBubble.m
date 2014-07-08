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
#define buttonsWidth 50

#define charWidth 4
#define lineHeight 15

#define roundness 3.0f

#define lineThickness 2
#define spaceBetweenTextAndLine 3


@interface SHReplyBubble()

@property UILabel* titleLabel;
@property UILabel* userLabel;
@property UILabel* contentLabel;
@property UIButton* replyButton;
@property UIButton* editButton;
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
    frame.size.height = titleHeight + contentCalcHeight + buttonsHeight + lineThickness + spaceBetweenTextAndLine;
    self.frame = frame;
    [self addSubview:self.contentLabel];
    
    //make a frame around it
    //[self.layer setBorderWidth:1.0];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = roundness;
    //[self.layer setBorderColor:[UIColor grayColor].CGColor];
    
    //add a line
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + spaceBetweenTextAndLine, self.frame.size.width,lineThickness)];
    lineView.backgroundColor = [UIColor huddleLightSilver];
    [self addSubview:lineView];
    
    
    //edit button
    self.editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.editButton.frame = CGRectMake(horizontalOffest, self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height + lineThickness + spaceBetweenTextAndLine, buttonsWidth, buttonsHeight);
    [self.editButton setTitle:@"EDIT" forState:UIControlStateNormal];
    [self.editButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [self.editButton setTitleColor:[UIColor huddleBlue] forState:UIControlStateNormal];
    [self.editButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    self.editButton.backgroundColor = [UIColor whiteColor];
    //[self.editButton.layer setBorderColor:[UIColor grayColor].CGColor];
    //[self.editButton.layer setBorderWidth:1.0];
    [self addSubview:self.editButton];
    [self.editButton addTarget:self action:@selector(replyTapped) forControlEvents:UIControlEventTouchUpInside];
    
 
    
    
    
    //reply button im leaving this just in case we change our minds
//    self.replyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    self.replyButton.frame = CGRectMake(horizontalOffest, self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height, width, replyHeight);
//    self.replyButton.titleLabel.text = @"Reply";
//    [self.replyButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
//    self.replyButton.backgroundColor = [UIColor blueColor];
//    //[self addSubview:self.replyButton];
//    [self.replyButton addTarget:self action:@selector(replyTapped) forControlEvents:UIControlEventTouchUpInside];
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
