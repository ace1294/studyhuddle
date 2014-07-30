//
//  SHCache.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/29/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface SHCache : NSObject

+ (id)sharedCache;

- (NSDictionary *)attributesForUser:(PFObject *)user;
- (NSDictionary *)attributesForHuddle:(PFObject *)huddle;
- (NSDictionary *)attributesForClass:(PFObject *)huddleClass;

- (void)setHuddles:(NSArray *)huddles;
- (void)setClasses:(NSArray *)huddleClasses;
- (void)setStudyFriends:(NSArray *)friends;

- (NSArray *)huddles;
- (NSArray *)classes;
- (NSArray *)studyFriends;

@end
