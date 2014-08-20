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
NSString *studyFriendHeader = @"user";
NSString *studyLogHeader = @"studyLog";
NSString *studentHeader = @"student";
NSString *notificationHeader = @"notification";
NSString *requestHeader = @"request";
NSString *sentRequestHeader = @"sentRequest";

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
    [self setClasses:[[[[PFUser currentUser] relationForKey:SHStudentClassesKey] query] findObjects]];
    [self setNotifications:[PFUser currentUser][SHStudentNotificationsKey]];
    [self setRequests:[PFUser currentUser][SHStudentRequestsKey]];
    
}

#pragma mark - Huddle

- (void)setHuddles:(NSArray *)huddles
{
    for(PFObject *huddle in huddles){
        [self setAttributesForHuddle:huddle];
    }
    
    NSString *key = SHUserDefaultsHuddlesKey;
    
    [[NSUserDefaults standardUserDefaults] setObject:[SHUtility objectIDsForObjects:huddles] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.cache setObject:[SHUtility objectIDsForObjects:huddles] forKey:key];
}

//Returns the current users huddles that are stored in the cache
- (NSArray *)huddles {
    NSString *key = SHUserDefaultsHuddlesKey;
    if ([self.cache objectForKey:key]) {
        return [NSArray arrayWithArray:[self objectsForKeys:[self.cache objectForKey:key] withHeader:huddleHeader]];
    }
    
    NSArray *huddles = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (huddles) {
        [self.cache setObject:huddles forKey:key];
    } else
        return @[];
    
    return [NSArray arrayWithArray:[self objectsForKeys:huddles withHeader:huddleHeader]];
}

//Updates the huddle that is already stored in the cache, if set new cache call setNewHuddle
- (BOOL)setAttributesForHuddle:(PFObject *)huddle
{
    NSString *key = [self keyForObject:huddle withHeader:huddleHeader];
    
    if([self.cache objectForKey:key])
        return false;
    
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
    
    return true;
}

- (BOOL)setAttributesForHuddle:(PFObject *)huddle withMembers:(NSArray *)members
{
    NSString *key = [self keyForObject:huddle withHeader:huddleHeader];
    
    if([self.cache objectForKey:key])
        return false;
    
    for(PFUser *user in members){
        if([[user objectId] isEqual:[[PFUser currentUser]objectId]])
            continue;
        [self setNewStudyFriend:user];
    }
    
    [self.cache setObject:huddle forKey:key];
    
    return true;
}

//Saves the new huddle id to the NSUserDefaults and loads the huddles data into the cache
- (void)setNewHuddle:(PFObject *)huddle
{
    if(![self setAttributesForHuddle:huddle])
        return;
    
    NSString *key = SHUserDefaultsHuddlesKey;
    NSMutableArray *currentHuddles;
    
    if (![self.cache objectForKey:key])
        currentHuddles = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    else
        currentHuddles = [NSMutableArray arrayWithArray:[self.cache objectForKey:key]];
    
    if(![currentHuddles containsObject:[huddle objectId]])
    {
        [currentHuddles addObject:[huddle objectId]];
        [self.cache setObject:[NSArray arrayWithArray:currentHuddles] forKey:key];
        
        [[NSUserDefaults standardUserDefaults] setObject:currentHuddles forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else
        [self.cache setObject:[NSArray arrayWithArray:currentHuddles] forKey:key];
    
}

- (void)setNewHuddle:(PFObject *)huddle withMembers:(NSArray *)members
{
    if(![self setAttributesForHuddle:huddle withMembers:members])
        return;
    
    NSString *key = SHUserDefaultsHuddlesKey;
    NSMutableArray *currentHuddles = [NSMutableArray arrayWithArray:[self.cache objectForKey:key]];
    
    if (![self.cache objectForKey:key])
        currentHuddles = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    else
        currentHuddles = [NSMutableArray arrayWithArray:[self.cache objectForKey:key]];
    
    if(![currentHuddles containsObject:[huddle objectId]])
    {
        [currentHuddles addObject:[huddle objectId]];
        [self.cache setObject:[NSArray arrayWithArray:currentHuddles] forKey:key];
        
        [[NSUserDefaults standardUserDefaults] setObject:currentHuddles forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else
        [self.cache setObject:[NSArray arrayWithArray:currentHuddles] forKey:key];
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
    
    return [NSArray arrayWithArray:[self objectsForKeys:[self.huddleMembers objectForKey:huddleKey] withHeader:studyFriendHeader]];
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
    
    NSString *key = SHUserDefaultsClassesKey;
    
    [[NSUserDefaults standardUserDefaults] setObject:[SHUtility objectIDsForObjects:huddleClasses] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.cache setObject:[SHUtility objectIDsForObjects:huddleClasses] forKey:key];
    
}

-(NSArray *)classes
{
    NSString *key = SHUserDefaultsClassesKey;
    if ([self.cache objectForKey:key]) {
        return [NSArray arrayWithArray:[self objectsForKeys:[self.cache objectForKey:key] withHeader:classHeader]];
    }
    
    NSArray *classes = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (classes) {
        [self.cache setObject:classes forKey:key];
    } else
        return @[];
    
    return [NSArray arrayWithArray:[self objectsForKeys:classes withHeader:classHeader]];
}

- (BOOL)setAttributesForClass:(PFObject *)huddleClass
{
    NSString *key = [self keyForObject:huddleClass withHeader:classHeader];
    
    if([self.cache objectForKey:key])
        return false;
    
    [huddleClass fetchIfNeeded];
    
    PFQuery *query = [PFUser query];
    [query whereKey:SHStudentClassesKey equalTo:huddleClass];
    NSArray *students = [query findObjects];
    [self.classMembers setObject:[SHUtility objectIDsForObjects:students] forKey:[self keyForObject:huddleClass withHeader:classHeader]];
    [self setClassStudents:students];
    
    for(PFObject *huddle in huddleClass[SHClassHuddlesKey]) //Probably shouldn't do this.
        [huddle fetchIfNeeded];
    
    [self.cache setObject:huddleClass forKey:key];
    
    return true;
}

- (void)setNewClass:(PFObject *)huddleClass
{
    if(![self setAttributesForClass:huddleClass])
        return;
    
    NSString *key = SHUserDefaultsClassesKey;
    NSMutableArray *currentClasses;
    
    if (![self.cache objectForKey:key])
        currentClasses = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    else
        currentClasses = [NSMutableArray arrayWithArray:[self.cache objectForKey:key]];
    
    if (![currentClasses containsObject:[huddleClass objectId]])
    {
        [currentClasses addObject:[huddleClass objectId]];
        [self.cache setObject:[NSArray arrayWithArray:currentClasses] forKey:key];
        
        [[NSUserDefaults standardUserDefaults] setObject:currentClasses forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else
        [self.cache setObject:[NSArray arrayWithArray:currentClasses] forKey:key];
    
}

-(void)leaveClass:(PFObject *)huddleClass
{
    NSString *key = SHUserDefaultsClassesKey;
    NSMutableArray *currentClasses = [NSMutableArray arrayWithArray:[self.cache objectForKey:key]];
    if (!currentClasses)
        currentClasses = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    [currentClasses removeObject:[huddleClass objectId]];
    [self.cache removeObjectForKey:[self keyForObject:huddleClass withHeader:classHeader]];
    
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

- (NSArray *)chatCategoriessForClass:(PFObject *)aClass
{
    return [NSArray arrayWithArray:aClass[SHClassChatCategoriesKey]];
}

#pragma mark - User

- (void)setStudyFriends:(NSArray *)friends
{
    for(PFUser *user in friends){
        if([[user objectId] isEqual:[[PFUser currentUser]objectId]])
            continue;
        [self setAttributesForStudyFriend:user];
    }
    
    NSString *key = SHUserDefaultsStudyFriendsKey;
    
    [[NSUserDefaults standardUserDefaults] setObject:[SHUtility objectIDsForObjects:friends] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.cache setObject:[SHUtility objectIDsForObjects:friends] forKey:key];
}

- (NSArray *)studyFriends
{
    NSString *key = SHUserDefaultsStudyFriendsKey;
    if ([self.cache objectForKey:key]) {
        return [NSArray arrayWithArray:[self objectsForKeys:[self.cache objectForKey:key] withHeader:studyFriendHeader]];
    }
    
    NSArray *studyFriends = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (studyFriends) {
        [self.cache setObject:studyFriends forKey:key];
    } else
        return @[];
    
    return [NSArray arrayWithArray:[self objectsForKeys:studyFriends withHeader:studyFriendHeader]];
}

- (BOOL)setAttributesForStudyFriend:(PFUser *)user
{
    NSString *key = [self keyForObject:user withHeader:studyFriendHeader];
    
    if([self.cache objectForKey:key])
        return false;
    
    [user fetchIfNeeded];
    
    [self.cache setObject:user forKey:key];
    return true;
}

- (void)setNewStudyFriend:(PFUser *)user
{
    if([[user objectId] isEqual:[[PFUser currentUser]objectId]] || ![self setAttributesForStudyFriend:user])
        return;
    
    NSString *key = SHUserDefaultsStudyFriendsKey;
    NSMutableArray *currentFriends;
    
    if (![self.cache objectForKey:key])
        currentFriends = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    else
        currentFriends = [NSMutableArray arrayWithArray:[self.cache objectForKey:key]];
    
    if(![currentFriends containsObject:[user objectId]]){
        [currentFriends addObject:[user objectId]];
        [self.cache setObject:[NSArray arrayWithArray:currentFriends] forKey:key];
    
        [[NSUserDefaults standardUserDefaults] setObject:currentFriends forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else
        [self.cache setObject:[NSArray arrayWithArray:currentFriends] forKey:key];
    
}

- (PFUser *)objectForUser:(PFUser *)user
{
    NSString *key = [self keyForObject:user withHeader:studyFriendHeader];
    return [self.cache objectForKey:key];
}

#pragma mark - Study

- (void)setStudyLogs:(NSArray *)logs
{
    for(PFObject *log in logs){
        [self setAttributesForStudyLog:log];
    }
    
    NSString *key = SHUserDefaultsStudyLogsKey;
    
    [[NSUserDefaults standardUserDefaults] setObject:[SHUtility objectIDsForObjects:logs] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.cache setObject:[SHUtility objectIDsForObjects:logs] forKey:key];
}

- (NSArray *)studyLogs
{
    NSString *key = SHUserDefaultsStudyLogsKey;
    if ([self.cache objectForKey:key]) {
        return [self objectsForKeys:[self.cache objectForKey:key] withHeader:studyLogHeader];
    }
    
    NSArray *studyLogs = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (studyLogs) {
        [self.cache setObject:studyLogs forKey:key];
    } else
        return @[];
    
    return [NSArray arrayWithArray:[self objectsForKeys:studyLogs withHeader:studyLogHeader]];
}

- (BOOL)setAttributesForStudyLog:(PFObject *)log
{
    NSString *key = [self keyForObject:log withHeader:studyLogHeader];
    
    if([self.cache objectForKey:key])
        return false;
    
    [log fetchIfNeeded];
    
    [self.cache setObject:log forKey:key];
    return true;
}

- (void)setNewStudyLog:(PFObject *)studyLog
{
    if(![self setAttributesForStudyLog:studyLog])
        return;
    
    NSString *key = SHUserDefaultsStudyLogsKey;
    NSMutableArray *currentLogs;
    
    if (![self.cache objectForKey:key]) {
        currentLogs = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    } else
        currentLogs = [NSMutableArray arrayWithArray:[self.cache objectForKey:key]];
    
    if(![currentLogs containsObject:[studyLog objectId]])
    {
        [currentLogs addObject:[studyLog objectId]];
        [self.cache setObject:[NSArray arrayWithArray:currentLogs] forKey:key];
        
        [[NSUserDefaults standardUserDefaults] setObject:currentLogs forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else
        [self.cache setObject:[NSArray arrayWithArray:currentLogs] forKey:key];
    
    
}

- (PFUser *)objectForStudyLog:(PFObject *)log
{
    NSString *key = [self keyForObject:log withHeader:studyLogHeader];
    return [self.cache objectForKey:key];
}


- (void)clear {
    [self.cache removeAllObjects];
}

#pragma mark - Notifications
- (void)setNotifications:(NSArray *)notifications
{
    for(PFObject *notification in notifications){
        [self setAttributesForNotification:notification];
    }
    
    NSString *key = SHUserDefaultsNotificationsKey;
    
    [[NSUserDefaults standardUserDefaults] setObject:[SHUtility objectIDsForObjects:notifications] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.cache setObject:[SHUtility objectIDsForObjects:notifications] forKey:key];
}

- (NSArray *)notifications
{
    NSString *key = SHUserDefaultsNotificationsKey;
    if ([self.cache objectForKey:key]) {
        return [NSArray arrayWithArray:[self objectsForKeys:[self.cache objectForKey:key] withHeader:notificationHeader]];
    }
    
    NSArray *notifications = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (notifications) {
        [self.cache setObject:notifications forKey:key];
    } else
        return @[];
    
    return [NSArray arrayWithArray:[self objectsForKeys:notifications withHeader:notificationHeader]];
}

- (BOOL)setAttributesForNotification:(PFObject *)notification
{
    NSString *key = [self keyForObject:notification withHeader:notificationHeader];
    
    if([self.cache objectForKey:key])
        return false;
    
    [notification fetchIfNeeded];
    
    [self.cache setObject:notification forKey:key];
    return true;
}

- (void)setNewNotification:(PFObject *)notification
{
    if(![self setAttributesForNotification:notification])
        return;
    
    NSString *key = SHUserDefaultsNotificationsKey;
    NSMutableArray *currentNotifications;
    
    if (![self.cache objectForKey:key])
        currentNotifications = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    else
        currentNotifications = [NSMutableArray arrayWithArray:[self.cache objectForKey:key]];
    
    if(![currentNotifications containsObject:notification])
    {
        [currentNotifications addObject:[notification objectId]];
        [self.cache setObject:[NSArray arrayWithArray:currentNotifications] forKey:key];
        
        [[NSUserDefaults standardUserDefaults] setObject:currentNotifications forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else
        [self.cache setObject:[NSArray arrayWithArray:currentNotifications] forKey:key];
    
    
}

- (NSArray *)reloadNotifications
{
    return nil;
}

#pragma mark - Requests
- (void)setRequests:(NSArray *)requests
{
    for(PFObject *request in requests){
        [self setAttributesForRequest:request];
    }
    
    NSString *key = SHUserDefaultsRequestsKey;
    
    [[NSUserDefaults standardUserDefaults] setObject:[SHUtility objectIDsForObjects:requests] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.cache setObject:[SHUtility objectIDsForObjects:requests] forKey:key];
}

- (NSArray *)requests
{
    NSString *key = SHUserDefaultsRequestsKey;
    if ([self.cache objectForKey:key]) {
        return [NSArray arrayWithArray:[self objectsForKeys:[self.cache objectForKey:key] withHeader:requestHeader]];
    }
    
    NSArray *requests = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (requests) {
        [self.cache setObject:requests forKey:key];
    } else
        return @[];
    
    return [NSArray arrayWithArray:[self objectsForKeys:requests withHeader:requestHeader]];
}

- (BOOL)setAttributesForRequest:(PFObject *)request
{
    NSString *key = [self keyForObject:request withHeader:requestHeader];
    
    if([self.cache objectForKey:key])
        return false;
    
    [request fetchIfNeeded];
    
    [self.cache setObject:request forKey:key];
    return true;
}

- (void)setNewRequest:(PFObject *)request
{
    if(![self setAttributesForRequest:request])
        return;
    
    NSString *key = SHUserDefaultsRequestsKey;
    NSMutableArray *currentRequests;
    
    if (![self.cache objectForKey:key])
        currentRequests = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    else
        currentRequests = [NSMutableArray arrayWithArray:[self.cache objectForKey:key]];
    
    if(![currentRequests containsObject:request])
    {
        [currentRequests addObject:[request objectId]];
        [self.cache setObject:[NSArray arrayWithArray:currentRequests] forKey:key];
        
        [[NSUserDefaults standardUserDefaults] setObject:currentRequests forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else
        [self.cache setObject:[NSArray arrayWithArray:currentRequests] forKey:key];
    
}

- (NSArray *)reloadRequests
{
    return nil;
}

- (void)removeRequest:(PFObject *)request
{
    NSString *key = SHUserDefaultsRequestsKey;
    NSMutableArray *currentRequests = [NSMutableArray arrayWithArray:[self.cache objectForKey:key]];
    
    if (!currentRequests)
        currentRequests = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        
    [currentRequests removeObject:[request objectId]];
    [self.cache removeObjectForKey:[self keyForObject:request withHeader:requestHeader]];
        
    [self.cache setObject:[NSArray arrayWithArray:currentRequests] forKey:key];
        
    [[NSUserDefaults standardUserDefaults] setObject:currentRequests forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

#pragma mark - Sent Requests

- (void)setSentRequests:(NSArray *)requests
{
    for(PFObject *request in requests){
        [self setAttributesForSentRequest:request];
    }
    
    NSString *key = SHUserDefaultsSentRequestsKey;
    
    [[NSUserDefaults standardUserDefaults] setObject:[SHUtility objectIDsForObjects:requests] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.cache setObject:[SHUtility objectIDsForObjects:requests] forKey:key];
}

- (NSArray *)sentRequests
{
    NSString *key = SHUserDefaultsSentRequestsKey;
    if ([self.cache objectForKey:key]) {
        return [NSArray arrayWithArray:[self objectsForKeys:[self.cache objectForKey:key] withHeader:sentRequestHeader]];
    }
    
    NSArray *sentRequests = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (sentRequests) {
        [self.cache setObject:sentRequests forKey:key];
    } else
        return @[];
    
    return [NSArray arrayWithArray:[self objectsForKeys:sentRequests withHeader:sentRequestHeader]];
}

- (BOOL)setAttributesForSentRequest:(PFObject *)request
{
    NSString *key = [self keyForObject:request withHeader:sentRequestHeader];
    
    if([self.cache objectForKey:key])
        return false;
    
    [request fetchIfNeeded];
    
    [self.cache setObject:request forKey:key];
    return true;
}

- (void)setNewSentRequest:(PFObject *)request
{
    if(![self setAttributesForSentRequest:request])
        return;
    
    NSString *key = SHUserDefaultsSentRequestsKey;
    NSMutableArray *currentSentRequests;
    
    if (![self.cache objectForKey:key])
        currentSentRequests = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    else
        currentSentRequests = [NSMutableArray arrayWithArray:[self.cache objectForKey:key]];
    
    if(![currentSentRequests containsObject:request])
    {
        [currentSentRequests addObject:[request objectId]];
        [self.cache setObject:[NSArray arrayWithArray:currentSentRequests] forKey:key];
        
        [[NSUserDefaults standardUserDefaults] setObject:currentSentRequests forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else
        [self.cache setObject:[NSArray arrayWithArray:currentSentRequests] forKey:key];
}

- (NSArray *)reloadSentRequests
{
    return nil;
}

- (void)removeSentRequest:(PFObject *)request
{
    NSString *key = SHUserDefaultsSentRequestsKey;
    NSMutableArray *currentSentRequests = [NSMutableArray arrayWithArray:[self.cache objectForKey:key]];
    
    if (!currentSentRequests)
        currentSentRequests = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    [currentSentRequests removeObject:[request objectId]];
    [self.cache removeObjectForKey:[self keyForObject:request withHeader:requestHeader]];
    
    [self.cache setObject:[NSArray arrayWithArray:currentSentRequests] forKey:key];
    
    [[NSUserDefaults standardUserDefaults] setObject:currentSentRequests forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
