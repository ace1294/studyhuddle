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
@property (nonatomic, strong) NSCache *studentCache;
@property (nonatomic, strong) NSMutableDictionary *huddleMembers;
@property (nonatomic, strong) NSMutableDictionary *classMembers;

@end

NSString *huddleHeader = @"huddle";
NSString *classHeader = @"class";
NSString *userHeader = @"user";
NSString *studyLogHeader = @"studyLog";
NSString *studentHeader = @"student";

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
        self.studentCache = [[NSCache alloc]init];
        self.huddleMembers = [[NSMutableDictionary alloc]init];
        self.classMembers = [[NSMutableDictionary alloc]init];
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

//Returns the current users huddles that are stored in the cache
- (NSArray *)huddles {
    NSString *key = SHUserDefaultsUserHuddlesKey;
    if ([self.cache objectForKey:key]) {
        return [NSArray arrayWithArray:[self objectsForKeys:[self.cache objectForKey:key] withHeader:huddleHeader]];
    }
    
    NSArray *huddles = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (huddles) {
        [self.cache setObject:huddles forKey:key];
    }
    
    return [NSArray arrayWithArray:[self objectsForKeys:huddles withHeader:huddleHeader]];
}

//Updates the huddle that is already stored in the cache, if set new cache call setNewHuddle
- (void)setAttributesForHuddle:(PFObject *)huddle
{
    NSString *key = [self keyForObject:huddle withHeader:huddleHeader];
    
    [huddle fetchIfNeeded];
    
    PFQuery *query = [PFUser query];
    [query whereKey:SHStudentHuddlesKey equalTo:huddle];
    [query whereKey:SHStudentEmailKey notEqualTo:[PFUser currentUser][SHStudentEmailKey]];
    NSArray *members = [query findObjects];
    [self.huddleMembers setObject:[SHUtility objectIDsForObjects:members] forKey:[self keyForObject:huddle withHeader:huddleHeader]];
    
    for(PFUser *user in members){
        if([[user objectId] isEqual:[[PFUser currentUser]objectId]])
            continue;
        [self setNewStudyFriend:user];
    }
    
    for(PFObject *resourceCategory in huddle[SHHuddleResourceCategoriesKey])
        [resourceCategory fetchIfNeeded];
    
    for(PFObject *chatCategory in huddle[SHHuddleChatCategoriesKey])
        [chatCategory fetchIfNeeded];
    
    [self.cache setObject:huddle forKey:key];
}

//Saves the new huddle id to the NSUserDefaults and loads the huddles data into the cache
- (void)setNewHuddle:(PFObject *)huddle
{
    NSString *key = SHUserDefaultsUserHuddlesKey;
    NSMutableArray *currentHuddles = [NSMutableArray arrayWithArray:[self.cache objectForKey:key]];
    
    if (!currentHuddles) {
        currentHuddles = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        [self.cache setObject:currentHuddles forKey:key];
    }
    
    if([currentHuddles containsObject:huddle])
        return;
    
    [self setAttributesForHuddle:huddle];
    
    [currentHuddles addObject:[huddle objectId]];
    [self.cache setObject:[NSArray arrayWithArray:currentHuddles] forKey:key];
    
    [[NSUserDefaults standardUserDefaults] setObject:currentHuddles forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

//Will return the entire fetched huddle
- (PFObject *)objectForHuddle:(PFObject *)huddle
{
    NSString *key = [self keyForObject:huddle withHeader:huddleHeader];
    return [self.cache objectForKey:key];
}

- (NSArray *)membersForHuddle:(PFObject *)huddle
{
    NSString *huddleKey = [self keyForObject:huddle withHeader:huddleHeader];
    
    return [NSArray arrayWithArray:[self objectsForKeys:[self.huddleMembers objectForKey:huddleKey] withHeader:userHeader]];
}

- (NSArray *)resourceCategoriesForHuddle:(PFObject *)huddle
{
    return [NSArray arrayWithArray:huddle[SHHuddleResourceCategoriesKey]];
}

- (NSArray *)chatCategoriessForHuddle:(PFObject *)huddle
{
    return [NSArray arrayWithArray:huddle[SHHuddleChatCategoriesKey]];
}

- (void)setHuddleStudying:(PFObject *)huddle
{
    NSString *key = [self keyForObject:huddle withHeader:huddleHeader];
    
    PFObject *cachedHuddle = [self.cache objectForKey:key];
    
    cachedHuddle[SHHuddleOnlineKey] = huddle[SHHuddleOnlineKey];
    cachedHuddle[SHHuddleLocationKey] = huddle[SHHuddleLocationKey];
    
    [self.cache setObject:cachedHuddle forKey:key];
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
        return [NSArray arrayWithArray:[self objectsForKeys:[self.cache objectForKey:key] withHeader:classHeader]];
    }
    
    NSArray *classes = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (classes) {
        [self.cache setObject:classes forKey:key];
    }
    
    return [NSArray arrayWithArray:[self objectsForKeys:classes withHeader:classHeader]];
}

- (void)setAttributesForClass:(PFObject *)huddleClass
{
    NSString *key = [self keyForObject:huddleClass withHeader:classHeader];
    
    [huddleClass fetchIfNeeded];
    
    PFQuery *query = [PFUser query];
    [query whereKey:SHStudentClassesKey equalTo:huddleClass];
    NSArray *students = [query findObjects];
    [self.classMembers setObject:[SHUtility objectIDsForObjects:students] forKey:[self keyForObject:huddleClass withHeader:classHeader]];
    [self setClassStudents:students];
    
    for(PFObject *huddle in huddleClass[SHClassHuddlesKey])
        [huddle fetchIfNeeded];
    
    [self.cache setObject:huddleClass forKey:key];
}

- (void)setNewClass:(PFObject *)huddleClass
{
    NSString *key = SHUserDefaultsUserStudyLogsKey;
    NSMutableArray *currentClasses = [NSMutableArray arrayWithArray:[self.cache objectForKey:key]];
    if (!currentClasses) {
        currentClasses = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        [self.cache setObject:currentClasses forKey:key];
    }
    
    if ([currentClasses containsObject:[huddleClass objectId]])
        return;
    
    [self setAttributesForClass:huddleClass];
    
    [currentClasses addObject:[huddleClass objectId]];
    [self.cache setObject:[NSArray arrayWithArray:currentClasses] forKey:key];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:currentClasses forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)leaveClass:(PFObject *)huddleClass
{
    NSString *key = SHUserDefaultsUserStudyLogsKey;
    NSMutableArray *currentClasses = [NSMutableArray arrayWithArray:[self.cache objectForKey:key]];
    if (!currentClasses) {
        currentClasses = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        [self.cache setObject:currentClasses forKey:key];
    }
    
    [currentClasses removeObject:[huddleClass objectId]];
    
    [self.cache setObject:[NSArray arrayWithArray:currentClasses] forKey:key];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:currentClasses forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (PFObject *)objectForClass:(PFObject *)huddleClass
{
    NSString *key = [self keyForObject:huddleClass withHeader:classHeader];
    return [self.cache objectForKey:key];
}

//Seperate cache for sutdents in class that aren't part of study friends (stored in self.studentCache)
- (void)setClassStudents:(NSArray *)students
{
    for(PFUser *user in students){
        [self setAttributesForClassStudent:user];
    }
}

- (void)setAttributesForClassStudent:(PFUser *)student
{
    NSString *key = [self keyForObject:student withHeader:studentHeader];
    
    [self.studentCache setObject:student forKey:key];
}

- (NSArray *)studentsForClass:(PFObject *)huddleClass
{
    NSString *classKey = [self keyForObject:huddleClass withHeader:classHeader];
    
    return [NSArray arrayWithArray:[self objectsForKeys:[self.classMembers objectForKey:classKey] withHeader:studentHeader]];
}

- (NSArray *)huddlesForClass:(PFObject *)huddleClass
{
    return [NSArray arrayWithArray:huddleClass[SHClassHuddlesKey]];
}

#pragma mark - User

- (void)setStudyFriends:(NSArray *)friends
{
    for(PFUser *user in friends){
        if([[user objectId] isEqual:[[PFUser currentUser]objectId]])
            continue;
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
        [NSArray arrayWithArray:[self objectsForKeys:[self.cache objectForKey:key] withHeader:userHeader]];
    }
    
    NSArray *studyFriends = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (studyFriends) {
        [self.cache setObject:studyFriends forKey:key];
    }
    
    return [NSArray arrayWithArray:[self objectsForKeys:studyFriends withHeader:userHeader]];
}

- (void)setAttributesForUser:(PFUser *)user
{
    NSString *key = [self keyForObject:user withHeader:userHeader];
    
    [user fetchIfNeeded];
    
    [self.cache setObject:user forKey:key];
}

- (void)setNewStudyFriend:(PFUser *)user
{
    if([[user objectId] isEqual:[[PFUser currentUser]objectId]])
        return;
    
    NSString *key = SHUserDefaultsUserStudyFriendsKey;
    NSMutableArray *currentFriends = [NSMutableArray arrayWithArray:[self.cache objectForKey:key]];
    if (!currentFriends) {
        currentFriends = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        [self.cache setObject:currentFriends forKey:key];
    }
    
    if([currentFriends containsObject:[user objectId]])
        return;
    
    [self setAttributesForUser:user];
    
    [currentFriends addObject:[user objectId]];
    [self.cache setObject:[NSArray arrayWithArray:currentFriends] forKey:key];
    
    [[NSUserDefaults standardUserDefaults] setObject:currentFriends forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
    
    return [NSArray arrayWithArray:[self objectsForKeys:studyLogs withHeader:studyLogHeader]];
}

- (void)setAttributesForStudyLog:(PFObject *)log
{
    NSString *key = [self keyForObject:log withHeader:studyLogHeader];
    
    [log fetchIfNeeded];
    
    [self.cache setObject:log forKey:key];
}
- (void)setNewStudyLog:(PFObject *)studyLog
{
    NSString *key = SHUserDefaultsUserStudyLogsKey;
    NSMutableArray *currentLogs = [NSMutableArray arrayWithArray:[self.cache objectForKey:key]];
    if (!currentLogs) {
        currentLogs = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        [self.cache setObject:currentLogs forKey:key];
    }
    
    if([currentLogs containsObject:[studyLog objectId]])
        return;
    
    [self setAttributesForClass:studyLog];
    
    
    [currentLogs addObject:[studyLog objectId]];
    [self.cache setObject:[NSArray arrayWithArray:currentLogs] forKey:key];
    
    [[NSUserDefaults standardUserDefaults] setObject:currentLogs forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
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

- (NSString *)keyForObject:(PFObject *)object withHeader:(NSString *)header
{
    return [NSString stringWithFormat:@"%@_%@", header, [object objectId]];
}

- (NSArray *)objectsForKeys:(NSArray *)keys withHeader:(NSString *)header
{
    NSMutableArray *objects = [[NSMutableArray alloc]initWithCapacity:[keys count]];
    
    for(NSString *key in keys){
        PFObject *object;
        if([header isEqual:studentHeader])
            object = [self.studentCache objectForKey:[NSString stringWithFormat:@"%@_%@",header, key]];
        else
            object = [self.cache objectForKey:[NSString stringWithFormat:@"%@_%@",header, key]];
        
        [object fetchIfNeeded];
        
        [objects addObject:object];
    }
    
    return objects;
}


@end
