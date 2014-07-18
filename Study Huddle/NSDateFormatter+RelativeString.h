//
//  NSDateFormatter+RelativeString.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/16/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (RelativeString)
+ (NSString*)relativeDateStringFromDate:(NSDate*)fromDate toDate:(NSDate*)toDate;
@end
