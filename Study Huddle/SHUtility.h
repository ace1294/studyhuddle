//
//  SHUtility.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/19/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface SHUtility : NSObject

+ (NSMutableAttributedString *)listOfMemberNames:(NSArray *)members attributes:(NSDictionary *)attr;
+ (NSMutableAttributedString *)listOfClasses:(PFRelation *)classes attributes:(NSDictionary *)attr;
+(UIImage *)getRoundedRectImageFromImage :(UIImage *)image onReferenceView :(UIImageView*)imageView withCornerRadius :(float)cornerRadius;

@end
