//
//  SHDocumentView.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/2/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SHDocumentView : UIView

@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) UIButton *addDocumentButton;
@property (nonatomic, strong) UIImageView *documentImageView;
@property (nonatomic, strong) id owner;
@property (nonatomic, strong) id root;
@property NSString* defaultImageName;
@property BOOL documentSet;

- (void)didTapAddDocumentButtonAction:(id)sender;

@end

/*!
 The protocol defines methods a delegate of a PAPBaseTextCell should implement.
 */
@protocol SHDocumentiewDelegate <NSObject>
@optional

/*!
 Sent to the delegate when a user button is tapped
 @param aUser the PFUser of the user that was tapped
 */
- (void) didTapAddDocumentButton: (UIImageView*)image;


@end