//
//  SHUtility.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/19/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
@class Student;

@interface SHUtility : NSObject

+ (NSMutableAttributedString *)listOfMemberNames:(NSArray *)members attributes:(NSDictionary *)attr;
+ (NSMutableAttributedString *)listOfClasses:(NSArray *)classObjects attributes:(NSDictionary *)attr;
+(UIImage *)getRoundedRectImageFromImage :(UIImage *)image onReferenceView :(UIImageView*)imageView withCornerRadius :(float)cornerRadius;

+(BOOL)studentInArray:(NSArray *)list student:(Student *)student;

+(NSInteger)resourcesInCategory:(NSString *)category inHuddle:(PFObject *)huddle;

+ (void)separateOnlineOfflineData:(NSMutableDictionary *)data forOnlineKey:(NSString *)onlineKey;


@end
