//
//  SHPortraitViewBase.h
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/14/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class SHImageView;

@interface SHPortraitViewBase : UIView


@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) UIButton *profileButton;
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UIViewController *owner;
@property NSString* defaultImageName;

- (void)didTapProfileButtonAction:(id)sender;
-(UIImage *)prepareImage: (UIImage*)unpreparedImage;
- (id) initWithImage: (UIImage*)image andFrame:(CGRect)frame;
-(void)savePhotoToParse:(UIImage*)newProfileImage;
-(BOOL) shouldUpdatePicture;


@end



/*!
 The protocol defines methods a delegate of a PAPBaseTextCell should implement.
 */
@protocol SHPortraitViewBaseDelegate <NSObject>
@optional

/*!
 Sent to the delegate when a user button is tapped
 @param aUser the PFUser of the user that was tapped
 */
- (void) didTapProfileButton: (UIImageView*)image;


@end
