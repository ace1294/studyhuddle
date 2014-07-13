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
        
        self.textField = [[HPGrowingTextView alloc]initWithFrame:CGRectMake(textFieldX, textFieldY, textFieldWidth, textFieldHeight)];
        NSLog(@"textField height: %f(%f), testBar height: %f",textFieldHeight,textFieldY,frame.size.height);
        //self.textField.text = @"W00h";
        self.textField.backgroundColor = [UIColor whiteColor];
        self.textField.minNumberOfLines = 1;
        self.textField.maxNumberOfLines = 6;
        self.textField.font = [UIFont systemFontOfSize:15.0f];
        self.textField.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        self.textField.placeholder = @"Live impeccably";
        self.textField.layer.cornerRadius = 3.0f;
        //self.textField.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:self.textField];
        
        //that button
        CGFloat postButtonHeight = self.textField.frame.size.height;
        CGFloat postButtonWidth = frame.size.width*(1-textFieldWidthBigness)/2 * postButtonWidthBigness;
        CGFloat buttonSegmentWidth = frame.size.width - (self.textField.frame.size.width  + self.textField.frame.origin.x);
        CGFloat postButtonX = self.textField.frame.size.width  + self.textField.frame.origin.x + buttonSegmentWidth*(1-postButtonWidthBigness)/2;
        CGFloat postButtonY = self.textField.frame.origin.y;

        self.postButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.postButton.frame =CGRectMake(postButtonX, postButtonY, postButtonWidth, postButtonHeight);
        self.postButton.backgroundColor = [UIColor whiteColor];
        [self.postButton.titleLabel setFont:[UIFont boldSystemFontOfSize:10]];
        [self.postButton setTitleColor:[UIColor huddleBlue] forState:UIControlStateNormal];
        [self addSubview:self.postButton];
        [self.postButton setTitle:@"POST" forState:UIControlStateNormal];
        [self.postButton.layer setCornerRadius:3.0f];
        
        //that image button
        CGFloat imagePhotoX = buttonSegmentWidth*(1-postButtonWidthBigness)/2;
        self.imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.imageButton setImage:[UIImage imageNamed:@"selectPhotoBtn.png"] forState:UIControlStateNormal];
        self.imageButton.frame =CGRectMake(imagePhotoX, postButtonY, postButtonWidth, postButtonHeight);
        self.imageButton.backgroundColor = [UIColor whiteColor];
        [self.imageButton.titleLabel setFont:[UIFont boldSystemFontOfSize:10]];
        [self addSubview:self.imageButton];
        [self.imageButton.layer setCornerRadius:3.0f];

        
        
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
