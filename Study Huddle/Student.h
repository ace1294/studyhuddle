
//
//  Student.m
//  Sample
//
//  Created by Jose Rafael Leon Bigio Anton on 6/12/14.
//  Copyright (c) 2014 Epic Peaks GmbH. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>

@interface Student : PFUser <PFSubclassing>

// Return the current user
+ (Student *)currentUser;

@property (nonatomic, retain) PFFile *userImage;

@property (retain) NSString *firstName;
@property (retain) NSString *lastName;
@property (retain) NSString *major;
@property (retain) NSString* hoursStudied;
@property (retain) NSString* fullName;

@property (retain) NSNumber* displayHoursToStudyEnabled;
@property (retain) NSNumber* pokeToStudyEnabled;

@property (retain) NSNumber* receiveNewHuddleMemberNotifications;
@property (retain) NSNumber* receiveHuddleIsStudyingNotifications;
@property (retain) NSNumber* receiveNewThreadPostNotifications;
@property (retain) NSNumber* receiveResourceAddedNotifications;
@property (retain) NSNumber* receiveNewPostNotifications;
@property (retain) NSNumber* receiveNewClassMemberNotifications;
@property (retain) NSNumber* receiveReplyToYourPostNotifications;


@property BOOL hasProfile;
@property BOOL isFeatured;


@end


