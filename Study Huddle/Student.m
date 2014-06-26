
#import "Student.h"

@implementation Student

@dynamic userImage;
@dynamic firstName, lastName, major,fullName;
@dynamic hasProfile, isFeatured;
@dynamic hoursStudied;

@dynamic receiveHuddleIsStudyingNotifications;
@dynamic receiveNewClassMemberNotifications;
@dynamic receiveNewHuddleMemberNotifications;
@dynamic receiveNewPostNotifications;
@dynamic receiveNewThreadPostNotifications;
@dynamic receiveReplyToYourPostNotifications;
@dynamic receiveResourceAddedNotifications;
@dynamic pokeToStudyEnabled;
@dynamic displayHoursToStudyEnabled;

// Return the current user
+ (Student *)currentUser {
    return (Student *)[PFUser currentUser];
}


@end