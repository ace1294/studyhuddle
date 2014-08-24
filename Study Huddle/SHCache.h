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

- (void)reloadCacheCurrentUser;
- (void)clearCache;

#pragma mark - Huddle
- (void)setHuddles:(NSArray *)huddles;
- (NSArray *)huddles;
- (BOOL)setAttributesForHuddle:(PFObject *)huddle;
- (BOOL)setAttributesForNewHuddle:(PFObject *)huddle;
- (void)setJoinedHuddle:(PFObject *)huddle;
- (void)setNewHuddle:(PFObject *)huddle;
- (void)removeHuddle:(PFObject *)huddle;
- (PFObject *)objectForHuddle:(PFObject *)huddle;
- (NSArray *)membersForHuddle:(PFObject *)huddle;
- (NSArray *)pendingMembersForHuddle:(PFObject *)huddle;
- (NSArray *)resourceCategoriesForHuddle:(PFObject *)huddle;
- (NSArray *)chatCategoriessForHuddle:(PFObject *)huddle;
- (void)setHuddleStudying:(PFObject *)huddle;
- (void)setNewHuddleMember:(PFUser *)member forHuddle:(PFObject *)huddle;
- (void)setNewPendingMember:(PFUser *)member forHuddle:(PFObject *)huddle;
- (void)setNewHuddleResourceCategory:(PFObject *)resourceCategory forHuddle:(PFObject *)huddle;
- (void)setNewHuddleChatCategory:(PFObject *)chatCategory forHuddle:(PFObject *)huddle;
- (void)removeHuddleMember:(PFObject *)member fromHuddle:(PFObject *)huddle;


#pragma mark - Class
- (void)setClasses:(NSArray *)huddleClasses;
- (NSArray *)classes;
- (BOOL)setAttributesForClass:(PFObject *)huddleClass;
- (void)setNewClass:(PFObject *)huddleClass;
- (void)leaveClass:(PFObject *)huddleClass;
- (PFObject *)objectForClass:(PFObject *)huddleClass;
- (NSArray *)studentsForClass:(PFObject *)huddleClass;
- (NSArray *)huddlesForClass:(PFObject *)huddleClass;
- (NSArray *)chatCategoriessForClass:(PFObject *)aClass;
- (void)setNewClassChatCategory:(PFObject *)chatCategory forClass:(PFObject *)huddleClass;
- (void)setNewClassHuddle:(PFObject *)huddle forClass:(PFObject *)huddleClass;

#pragma mark - User
- (void)setStudyFriends:(NSArray *)friends;
- (NSArray *)studyFriends;
- (BOOL)setAttributesForStudyFriend:(PFUser *)user;
- (void)setNewStudyFriend:(PFUser *)user;
- (void)removeStudyFriend:(PFObject *)user;
- (PFUser *)objectForUser:(PFUser *)user;

#pragma mark - Study
- (void)setStudyLogs:(NSArray *)logs;
- (NSArray *)studyLogs;
- (BOOL)setAttributesForStudyLog:(PFObject *)log;
- (void)setNewStudyLog:(PFObject *)studyLog;
- (PFObject *)objectForStudyLog:(PFObject *)log;

#pragma mark - Notifications
- (void)setNotifications:(NSArray *)notifications;
- (NSArray *)notifications;
- (BOOL)setAttributesForNotification:(PFObject *)notification;
- (void)setNewNotification:(PFObject *)notification;
- (NSArray *)reloadNotifications;

#pragma mark - Requests
- (void)setRequests:(NSArray *)requests;
- (NSArray *)requests;
- (BOOL)setAttributesForRequest:(PFObject *)request;
- (void)setNewRequest:(PFObject *)request;
- (NSArray *)reloadRequests;
- (void)removeRequest:(PFObject *)request;

#pragma mark - Sent Requests
- (void)setSentRequests:(NSArray *)requests;
- (NSArray *)sentRequests;
- (BOOL)setAttributesForSentRequest:(PFObject *)request;
- (void)setNewSentRequest:(PFObject *)request;
- (NSArray *)reloadSentRequests;
- (void)removeSentRequest:(PFObject *)request;





@end
