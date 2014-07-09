//
//  SHTextBar.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 7/8/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHTextBar.h"
#import "UIColor+HuddleColors.h"

#define textFieldWidthBigness 0.6f
#define textFieldHeightBigness 0.65f
#define postButtonWidthBigness 0.8



@interface SHTextBar()


@end

@implementation SHTextBar


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        
        self.backgroundColor = [UIColor lightGrayColor];
        
        //math intensive shit about to take place
        CGFloat textFieldHeight = frame.size.height*textFieldHeightBigness;
        CGFloat textFieldWidth = frame.size.width*textFieldWidthBigness;
        CGFloat textFieldX = frame.size.width*(1-textFieldWidthBigness)/2;
        CGFloat textFieldY = frame.size.height - textFieldHeight - (textFieldHeight*(1-textFieldHeightBigness)/2);
        
        self.textField = [[UITextField alloc]initWithFrame:CGRectMake(textFieldX, textFieldY, textFieldWidth, textFieldHeight)];
        self.textField.text = @"W00h";
        self.textField.backgroundColor = [UIColor whiteColor];
        self.textField.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:self.textField];
        
        //that button
        CGFloat postButtonHeight = frame.size.height*textFieldHeightBigness;
        CGFloat postButtonWidth = frame.size.width*(1-textFieldWidthBigness)/2 * postButtonWidthBigness;
        CGFloat buttonSegmentWidth = frame.size.width - (self.textField.frame.size.width  + self.textField.frame.origin.x);
        CGFloat postButtonX = self.textField.frame.size.width  + self.textField.frame.origin.x + buttonSegmentWidth*(1-postButtonWidthBigness)/2;
        CGFloat postButtonY = self.textField.frame.origin.y;

        self.postButton = [[UIButton alloc]initWithFrame:CGRectMake(postButtonX, postButtonY, postButtonWidth, postButtonHeight)];
        self.postButton.backgroundColor = [UIColor whiteColor];
        [self.postButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [self.postButton setTitleColor:[UIColor huddleBlue] forState:UIControlStateNormal];
        [self.postButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self addSubview:self.postButton];
        [self.postButton setTitle:@"POST" forState:UIControlStateNormal];
        //[postButton addTarget:self action:@selector(postTapped) forControlEvents:UIControlEventTouchUpInside];

        
        
    }
    return self;
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
