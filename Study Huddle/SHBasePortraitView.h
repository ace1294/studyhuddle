//
//  SHCreateHuddlePortraitView.h
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/23/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBasePortraitView : UIView

@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) UIButton *profileButton;
@property (nonatomic, strong) UIImageView *huddleImageView;
@property (nonatomic, strong) id owner;
@property NSString* defaultImageName;
@property BOOL isClickable;

- (void)didTapProfileButtonAction:(id)sender;

@end



/*!
 The protocol defines methods a delegate of a PAPBaseTextCell should implement.
 */
@protocol SHCreateHuddlePortraitViewDelegate <NSObject>
@optional

/*!
 Sent to the delegate when a user button is tapped
 @param aUser the PFUser of the user that was tapped
 */
- (void) didTapProfileButton: (UIImageView*)image;


@end
