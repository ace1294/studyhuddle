//
//  SHThreadBubble.h
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 7/5/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol SHQuestionBubbleDelegate <NSObject>
@optional

- (void)didTapReply:(PFObject *)questionObject;
- (void)didTapEdit:(PFObject*)questionObject;

@end

@interface SHQuestionBubble : UIView

-(id)initWithFrame:(CGRect)frame andTitle:(NSString*) title andContent: (NSString*)content;
-(id)initWithFrame:(CGRect)frame andTitle:(NSString*) title andContent: (NSString*)content andParent:(PFObject*)parent;
-(id)initWithQuestion: (PFObject*)questionObject andFrame: (CGRect)frame;

@property (nonatomic,strong) id <SHQuestionBubbleDelegate> delegate;

@end



