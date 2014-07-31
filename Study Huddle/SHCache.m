//
//  SHCache.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/29/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHCache.h"
#import "SHConstants.h"
#import "SHUtility.h"

@interface SHCache()

@property (nonatomic, strong) NSCache *cache;

@end

NSString *huddleHeader = @"huddle";
NSString *classHeader = @"class";
NSString *userHeader = @"user";
NSString *studyLogHeader = @"studyLog";

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

//must call [PFUser currentUser] refreshInBackgroundWithTarget:(id) selector:(SEL) first have this be the selector
- (void)reloadCacheCurrentUser
{
    [self clear];
    
    [self setHuddles:[PFUser currentUser][SHStudentHuddlesKey]];
    [self setClasses:[PFUser currentUser][SHStudentClassesKey]];
    [self setStudyFriends:[PFUser currentUser][SHStudentStudyFriendsKey]];
    
}


#pragma mark - Huddle

- (void)setHuddles:(NSArray *)huddles
{
    for(PFObject *huddle in huddles){
        [self setAttributesForHuddle:huddle];
    }
    
    NSString *key = SHUserDefaultsUserHuddlesKey;
    
    [[NSUserDefaults standardUserDefaults] setObject:[SHUtility objectIDsForObjects:huddles] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)huddles {
    NSString *key = SHUserDefaultsUserHuddlesKey;
    if ([self.cache objectForKey:key]) {
        return [self objectsForKeys:[self.cache objectForKey:key] withHeader:huddleHeader];
    }
    
    NSArray *huddles = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (huddles) {
        [self.cache setObject:huddles forKey:key];
    }
    
    return [self objectsForKeys:huddles withHeader:huddleHeader];
}

- (void)setAttributesForHuddle:(PFObject *)huddle
{
    NSString *key = [self keyForObject:huddle withHeader:huddleHeader];
    
    [huddle fetchIfNeeded];
    
    [self.cache setObject:huddle forKey:key];
}

- (PFObject *)objectForHuddle:(PFObject *)huddle
{
    NSString *key = [self keyForObject:huddle withHeader:huddleHeader];
    return [self.cache objectForKey:key];
}



#pragma mark - Class

- (void)setClasses:(NSArray *)huddleClasses;
{
    for(PFObject *huddleClass in huddleClasses){
        [self setAttributesForClass:huddleClass];
    }
    
    NSString *key = SHUserDefaultsUserClassesKey;
    
    [[NSUserDefaults standardUserDefaults] setObject:[SHUtility objectIDsForObjects:huddleClasses] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(NSArray *)classes
{
    NSString *key = SHUserDefaultsUserClassesKey;
    if ([self.cache objectForKey:key]) {
        return [self objectsForKeys:[self.cache objectForKey:key] withHeader:classHeader];
    }
    
    NSArray *classes = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (classes) {
        [self.cache setObject:classes forKey:key];
    }
    
    return [self objectsForKeys:classes withHeader:classHeader];
}

- (void)setAttributesForClass:(PFObject *)huddleClass
{
    NSString *key = [self keyForObject:huddleClass withHeader:classHeader];
    
    [huddleClass fetchIfNeeded];
    
    [self.cache setObject:huddleClass forKey:key];
}

- (PFObject *)objectForClass:(PFObject *)huddleClass
{
    NSString *key = [self keyForObject:huddleClass withHeader:classHeader];
    return [self.cache objectForKey:key];
}



#pragma mark - User

- (void)setStudyFriends:(NSArray *)friends
{
    for(PFUser *user in friends){
        [self setAttributesForUser:user];
    }
    
    NSString *key = SHUserDefaultsUserStudyFriendsKey;
    
    [[NSUserDefaults standardUserDefaults] setObject:[SHUtility objectIDsForObjects:friends] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)studyFriends
{
    NSString *key = SHUserDefaultsUserStudyFriendsKey;
    if ([self.cache objectForKey:key]) {
        [self objectsForKeys:[self.cache objectForKey:key] withHeader:userHeader];
    }
    
    NSArray *studyFriends = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (studyFriends) {
        [self.cache setObject:studyFriends forKey:key];
    }
    
    return [self objectsForKeys:studyFriends withHeader:userHeader];
}

- (void)setAttributesForUser:(PFUser *)user
{
    NSString *key = [self keyForObject:user withHeader:userHeader];
    
    [user fetchIfNeeded];
    
    [self.cache setObject:user forKey:key];
}

- (PFUser *)objectForUser:(PFUser *)user
{
    NSString *key = [self keyForObject:user withHeader:userHeader];
    return [self.cache objectForKey:key];
}

#pragma mark - Study
- (void)setStudyLogs:(NSArray *)logs
{
    for(PFObject *log in logs){
        [self setAttributesForStudyLog:log];
    }
    
    NSString *key = SHUserDefaultsUserStudyLogsKey;
    
    [[NSUserDefaults standardUserDefaults] setObject:[SHUtility objectIDsForObjects:logs] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)studyLogs
{
    NSString *key = SHUserDefaultsUserStudyLogsKey;
    if ([self.cache objectForKey:key]) {
        [self objectsForKeys:[self.cache objectForKey:key] withHeader:studyLogHeader];
    }
    
    NSArray *studyLogs = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (studyLogs) {
        [self.cache setObject:studyLogs forKey:key];
    }
    
    return [self objectsForKeys:studyLogs withHeader:studyLogHeader];
}

- (void)setAttributesForStudyLog:(PFObject *)log
{
    NSString *key = [self keyForObject:log withHeader:studyLogHeader];
    
    [log fetchIfNeeded];
    
    [self.cache setObject:log forKey:key];
}

- (PFUser *)objectForStudyLog:(PFObject *)log
{
    NSString *key = [self keyForObject:log withHeader:studyLogHeader];
    return [self.cache objectForKey:key];
}


- (void)clear {
    [self.cache removeAllObjects];
}

#pragma mark - Helpers

- (NSString *)keyForObject:(PFObject *)user withHeader:(NSString *)header
{
    return [NSString stringWithFormat:@"%@_%@", header, [user objectId]];
}

- (NSArray *)objectsForKeys:(NSArray *)keys withHeader:(NSString *)header
{
    NSMutableArray *objects = [[NSMutableArray alloc]initWithCapacity:[keys count]];
    
    for(NSString *key in keys){
        [objects addObject:[self.cache objectForKey:[NSString stringWithFormat:@"%@_%@",header, key]]];
    }
    
    return objects;
}

@end
