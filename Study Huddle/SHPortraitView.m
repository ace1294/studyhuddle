//
//  SHPortraitView.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/19/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHPortraitView.h"
#import "SHUtility.h"

@interface SHPortraitView ()
@property (nonatomic, strong) UIImageView *borderImageview;
@end


@implementation SHPortraitView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.profileImageView = [[PFImageView alloc] initWithFrame:frame];
        [self addSubview:self.profileImageView];
        
        self.profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.profileButton];
        
        if (frame.size.width < 35.0f) {
            self.borderImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ringBehindProfPic.png"]];
        } else if (frame.size.width < 43.0f) {
            self.borderImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ringBehindProfPic@2x.png"]];
        } else {
            self.borderImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ringBehindProfPic@2x.png"]];
        }
        
        [self addSubview:self.borderImageview];
    }
    return self;
}

- (void)hideButton
{
    [self.profileButton setHidden:TRUE];
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    [self bringSubviewToFront:self.borderImageview];
    
    self.profileImageView.frame = CGRectMake( 0.0f, 0.0f, self.frame.size.width - 2.0f, self.frame.size.height - 2.0f);
    self.borderImageview.frame = CGRectMake( 0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    self.profileButton.frame = CGRectMake( 0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
}


#pragma mark - PAPProfileImageView

- (void)setFile:(PFFile *)file {
    if (!file) {
        NSLog(@"returning");
        return;
    }
    
    
    //self.profileImageView.image = [UIImage imageNamed:@"AvatarPlaceholder.png"];
    UIImage* unpreparedImage = [UIImage imageWithData:[file getData]];
    UIImage* preparedImage = [SHUtility getRoundedRectImageFromImage:unpreparedImage onReferenceView:self.profileImageView withCornerRadius:self.profileImageView.frame.size.width/2];
    
    PFFile* roundedFile = [PFFile fileWithData: UIImageJPEGRepresentation(preparedImage, 1.0f)];
    
    
    self.profileImageView.file = roundedFile;
    
    self.profileImageView.image = preparedImage;
    
    [self.profileImageView loadInBackground];
}

@end
