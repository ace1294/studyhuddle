//
//  SHReplyBubble.h
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 7/6/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@protocol SHReplyBubbleDelegate <NSObject>
@optional
-(void)didTapEditReply: (PFObject*)replyObject;
@end

@interface SHReplyBubble : UIView

-(id)initWithFrame:(CGRect)frame andTitle:(NSString*) title andContent: (NSString*)content;
-(id)initWithFrame:(CGRect)frame andTitle:(NSString*) title andContent: (NSString*)content andParent:(PFObject*)parent;
-(id)initWithReply: (PFObject*)replyObject andFrame: (CGRect)frame;

@property (nonatomic,strong) id <SHReplyBubbleDelegate> delegate;

@end



