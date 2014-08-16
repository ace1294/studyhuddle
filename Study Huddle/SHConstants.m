//
//  SHConstants.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/14/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHConstants.h"

#pragma mark - NSUserDefaults

NSString *const SHUserDefaultsUserHuddlesKey = @"com.StudyHuddle.userDefaults.huddles";
NSString *const SHUserDefaultsUserClassesKey = @"com.StudyHuddle.userDefaults.classes";
NSString *const SHUserDefaultsUserStudyFriendsKey = @"com.StudyHuddle.userDefaults.studyFriends";
NSString *const SHUserDefaultsUserStudyLogsKey = @"com.StudyHuddle.userDefaults.studyLogs";

#pragma mark - Cells

//Parse
NSString *const SHHuddleParseClass = @"Huddles";
NSString *const SHClassParseClass = @"Classes";
NSString *const SHStudentParseClass = @"_User";
NSString *const SHRequestParseClass = @"Requests";
NSString *const SHStudyParseClass = @"Study";
NSString *const SHResourceParseClass = @"Resources";
NSString *const SHResourceCategoryParseClass = @"ResourceCategory";
NSString *const SHChatCategoryParseClass = @"ChatCategory";
NSString *const SHThreadParseClass = @"Thread";
NSString *const SHQuestionParseClass = @"Question";
NSString *const SHNotificationParseClass = @"Notification";


//Cells
NSString *const SHBaseCellIdentifier = @"BaseCell";
NSString *const SHHuddleCellIdentifier = @"HuddleCell";
NSString *const SHRequestCellIdentifier = @"RequestCell";
NSString *const SHNotificationCellIdentifier = @"NotificationCell";
NSString *const SHClassCellIdentifier = @"ClassCell";
NSString *const SHStudyCellIdentifier = @"StudyCell";
NSString *const SHAddCellIdentifier = @"AddCell";
NSString *const SHStudentCellIdentifier = @"StudentCell";
NSString *const SHResourceCellIdentifier = @"ResourceCell";
NSString *const SHCategoryCellIdentifier = @"CategoryCell";
NSString *const SHChatCellIdentifier = @"ChatCell";
NSString *const SHThreadCellIdentifier = @"ThreadCell";
NSString *const SHHuddlePageCellIdentifier = @"HuddlePageCell";

//Class
NSString *const SHClassFullNameKey = @"classFullName";
NSString *const SHClassShortNameKey = @"classShortName";
NSString *const SHClassTeacherKey = @"teacherName";
NSString *const SHClassEmailKey = @"teacherEmail";
NSString *const SHClassRoomKey = @"classRoom";
NSString *const SHClassUniqueName = @"uniqueName";
NSString *const SHClassStudentsKey = @"students";
NSString *const SHClassHuddlesKey = @"huddles";

//Huddle
NSString *const SHHuddleCreatorKey = @"creator";
NSString *const SHHuddleNameKey = @"huddleName";
NSString *const SHHuddleMembersKey = @"huddleMembers";
NSString *const SHHuddleStatusKey = @"huddleStatus";
NSString *const SHHuddleLowerName = @"lowerName";
NSString *const SHHuddleStudyKey = @"study";
NSString *const SHHuddleResourceCategoriesKey = @"resourceCategories";
NSString *const SHHuddleChatCategoriesKey = @"chatCategories";
NSString *const SHHuddleImageKey = @"huddleImage";
NSString *const SHHuddleOnlineKey = @"online";
NSString *const SHHuddleLastStudyLogKey = @"lastStudyLog";
NSString *const SHHuddleLastStartKey = @"lastStart";
NSString *const SHHuddleHoursStudiedKey = @"hoursStudied";
NSString *const SHHuddleLocationKey = @"location";


//Student
NSString *const SHStudentNameKey = @"fullName";
NSString *const SHStudentEmailKey = @"username";
NSString *const SHStudentClassesKey = @"classes";
NSString *const SHStudentMajorKey = @"major";
NSString *const SHStudentImageKey = @"userImage";
NSString *const SHStudentLowerNameKey = @"lowerName";
NSString *const SHStudentHuddlesKey = @"huddles";
NSString *const SHStudentStudyLogsKey = @"study";
NSString *const SHStudentStudyFriendsKey = @"online";
NSString *const SHStudentCurrentStudyLogKey = @"lastStudy";
NSString *const SHStudentStudyingKey = @"isStudying";
NSString *const SHStudentRequestsKey = @"requests";
NSString *const SHStudentNotificationsKey = @"notifications";
NSString* const SHStudentLastStartKey = @"lastStart";
NSString *const SHStudentHoursStudiedKey = @"hoursStudied";
NSString* const SHStudentUnresolvedChannel = @"unresolvedChannels";

//Study
NSString *const SHStudyClassesKey = @"classes";
NSString *const SHStudyStartKey = @"start";
NSString *const SHStudyEndKey = @"end";
NSString *const SHStudyOnlineKey = @"online";
NSString *const SHStudyDescriptionKey = @"description";
NSString *const SHStudyStudentKey = @"studentID";


//Resources
NSString *const SHResourceHuddleKey = @"huddle";
NSString *const SHResourceCreatorKey = @"creator";
NSString *const SHResourceNameKey = @"title";
NSString *const SHResourceCategoryKey = @"category";
NSString *const SHResourceDescriptionKey = @"description";
NSString *const SHResourceLinkKey = @"link";
NSString *const SHResourceFileKey = @"file";

//Resource Cateogry
NSString *const SHResourceCategoryNameKey = @"name";
NSString *const SHResourceCategoryHuddleKey = @"huddle";
NSString *const SHResourceCategoryResourcesKey = @"resources";

//Requests
NSString *const SHRequestTitleKey = @"title";
NSString *const SHRequestHuddleKey = @"huddle";
NSString *const SHRequestTypeKey = @"type";
NSString *const SHRequestStudent1Key = @"student1";
NSString *const SHRequestStudent2Key = @"student2";
NSString *const SHRequestLocationKey = @"location";
NSString *const SHRequestTimeKey = @"time";
NSString *const SHRequestDescriptionKey = @"description";
NSString *const SHRequestMessageKey = @"message";


//Request Types
NSString *const SHRequestSSInviteStudy = @"SSInviteStudy";
NSString *const SHRequestSHJoin = @"SHJoin";
NSString *const SHRequestHSJoin = @"HSJoin";

//Notifications
NSString* const SHNotificationTitleKey = @"title";
NSString* const SHNotificationDescriptionKey = @"description";
NSString* const SHNotificationHuddleKey = @"huddle";
NSString* const SHNotificationToStudentKey = @"toStudent";
NSString* const SHNotificationFromStudentKey = @"fromStudent";
NSString* const SHNotificationClassKey = @"class";
NSString* const SHNotificationTypeKey = @"type";
NSString* const SHNotificationReadKey = @"read";
NSString* const SHNotificationLocationKey = @"location";
NSString* const SHNotificationRequestAcceptedKey = @"requestAccepted";
NSString *const SHNotificationMessageKey = @"message";
NSString* const SHNotificationParseClassKey = @"Notification";
NSString* const SHNotificationRoomKey = @"room";

//Notification Types
NSString* const SHNotificationNewResourceType = @"newResource";
NSString* const SHNotificationNewHuddleMemberType = @"huddleNewMember";
NSString* const SHNotificationAnswerType = @"answerToQuestion";
NSString* const SHNotificationHuddleStartedStudyingType = @"huddleStartsStudying";
NSString* const SHNotificationSSStudyRequestType = @"ssStudyRequest";
NSString* const SHNotificationSHJoinRequestType = @"shJoinRequest";
NSString* const SHNotificationHSJoinRequestType = @"hsJoinRequest";
NSString* const SHNotificationHSStudyRequestType = @"hsStudyRequest";
NSString* const SHNotificationQuestionKey = @"question";


//SHHuddleStartStudyingViewController

//Notification Descriptions
NSString* const SHSSAcceptedStudyInviteRequestTitle = @"Student accepted study invite";
NSString* const SHSSDeniedStudyInviteRequestTitle = @"Student denied study invite";
NSString* const SHSHAcceptedJoinRequestTitle = @"Huddle accepted request to join";
NSString* const SHSHDeniedJoinRequestTitle = @"Huddle denied request to join";

//Thread
NSString* const SHThreadTitle = @"title";
NSString* const SHThreadCreator = @"creator";
NSString* const SHThreadQuestions = @"questions";
NSString* const SHThreadChatCategoryKey = @"chatCategory";

//Question
NSString* const SHQuestionCreatorID = @"creatorID";
NSString* const SHQuestionCreatorName = @"creatorName";
NSString* const SHQuestionReplies = @"replies";
NSString* const SHQuestionQuestion = @"question";
NSString* const SHQuestionClassName = @"Question";

//Reply
NSString* const SHReplyCreatorID = @"creatorID";
NSString* const SHReplyCreatorName = @"creatorName";
NSString* const SHReplyAnswer = @"answer";
NSString* const SHReplyClassName = @"Reply";


//Chat Category
NSString* const SHChatCategoryNameKey = @"category";
NSString* const SHChatCategoryChatRoomKey = @"chatRooms";
NSString* const SHChatCategoryHuddleKey = @"huddle";

//Chat room
NSString* const SHChatRoomClassKey = @"ChatRooms";
NSString* const SHChatRoomRoomKey = @"room";
NSString* const SHChatRoomChatCategoryOwnerKey = @"chatCategoryOwner";
NSString* const SHChatRoomResolved = @"resolved";
NSString* const SHChatRoomCreatorIDKey = @"creatorID";

//Chat (the bubble)
NSString* const SHChatClassKey = @"Chat";
NSString* const SHChatUserKey = @"user";
NSString* const SHChatTextKey = @"text";
NSString* const SHChatRoomKey = @"room";

//Constants for chat feature
int const SHEditingQuestion = 0;
int const SHReplying = 1;
int const SHQuestioning = 2;
int const SHEditingReply = 3;

//PUSH constants
NSString* const SHPushChannelsKey = @"channels";
NSString* const SHPushTypeKey = @"type";

//PUSH TYPES
NSString* const SHPushTypeHuddleChatPost = @"huddleChatPost";
