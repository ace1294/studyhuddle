//
//  SHCache.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/29/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHCache.h"
#import "SHConstants.h"

@interface SHCache()

@property (nonatomic, strong) NSCache *cache;
//- (void)setAttributes:(NSDictionary *)attributes forPhoto:(PFObject *)photo;
@end

@implementation SHCache

+ (id)sharedCache {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        self.cache = [[NSCache alloc] init];
    }
    return self;
}

#pragma mark - PAPCache

- (NSDictionary *)attributesForUser:(PFUser *)user {
    NSString *key = [self keyForUser:user];
    return [self.cache objectForKey:key];
}

- (NSDictionary *)attributesForHuddle:(PFObject *)huddle
{
    NSString *key = [self keyForHuddle:huddle];
    return [self.cache objectForKey:key];
}
- (NSDictionary *)attributesForClass:(PFObject *)huddleClass
{
    NSString *key = [self keyForClass:huddleClass];
    return [self.cache objectForKey:key];
}


- (void)setHuddles:(NSArray *)huddles
{
    NSString *key = SHUserDefaultsUserHuddlesKey;
    [self.cache setObject:huddles forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:huddles forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setClasses:(NSArray *)huddleClasses;
{
    NSString *key = SHUserDefaultsUserClassesKey;
    [self.cache setObject:huddleClasses forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:huddleClasses forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)setStudyFriends:(NSArray *)friends
{
    NSString *key = SHUserDefaultsUserStudyFriendsKey;
    [self.cache setObject:friends forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:friends forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)huddles {
    NSString *key = SHUserDefaultsUserHuddlesKey;
    if ([self.cache objectForKey:key]) {
        return [self.cache objectForKey:key];
    }
    
    NSArray *huddles = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (huddles) {
        [self.cache setObject:huddles forKey:key];
    }
    
    return huddles;
}

-(NSArray *)classes
{
    NSString *key = SHUserDefaultsUserClassesKey;
    if ([self.cache objectForKey:key]) {
        return [self.cache objectForKey:key];
    }
    
    NSArray *classes = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (classes) {
        [self.cache setObject:classes forKey:key];
    }
    
    return classes;
}

- (NSArray *)studyFriends
{
    NSString *key = SHUserDefaultsUserStudyFriendsKey;
    if ([self.cache objectForKey:key]) {
        return [self.cache objectForKey:key];
    }
    
    NSArray *studyFriends = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (studyFriends) {
        [self.cache setObject:studyFriends forKey:key];
    }
    
    return studyFriends;
}


- (void)clear {
    [self.cache removeAllObjects];
}


#pragma mark - Helpers

- (void)setAttributes:(NSDictionary *)attributes forUser:(PFUser *)user
{
    NSString *key = [self keyForUser:user];
    [self.cache setObject:attributes forKey:key];
}

- (void)setAttributes:(NSDictionary *)attributes forHuddle:(PFObject *)huddle
{
    NSString *key = [self keyForHuddle:huddle];
    [self.cache setObject:attributes forKey:key];
}

- (void)setAttributes:(NSDictionary *)attributes forClass:(PFObject *)huddleClass
{
    NSString *key = [self keyForClass:huddleClass];
    [self.cache setObject:attributes forKey:key];
}

- (NSString *)keyForUser:(PFObject *)user
{
    return [NSString stringWithFormat:@"user_%@", [user objectId]];
}

- (NSString *)keyForHuddle:(PFObject *)huddle
{
    return [NSString stringWithFormat:@"huddle_%@", [huddle objectId]];
}

- (NSString *)keyForClass:(PFObject *)huddleClass
{
    return [NSString stringWithFormat:@"huddleClass_%@", [huddleClass objectId]];
}

@end
