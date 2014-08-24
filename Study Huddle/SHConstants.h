//
//  SHConstants.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/14/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#pragma mark - NSUserDefaults
extern NSString *const SHUserDefaultsHuddlesKey;
extern NSString *const SHUserDefaultsClassesKey;
extern NSString *const SHUserDefaultsStudyFriendsKey;
extern NSString *const SHUserDefaultsStudyLogsKey;
extern NSString *const SHUserDefaultsNotificationsKey;
extern NSString *const SHUserDefaultsRequestsKey;
extern NSString *const SHUserDefaultsSentRequestsKey;

//Parse Classes
extern NSString *const SHHuddleParseClass;
extern NSString *const SHStudentParseClass;
extern NSString *const SHClassParseClass;
extern NSString *const SHRequestParseClass;
extern NSString *const SHStudyParseClass;
extern NSString *const SHResourceParseClass;
extern NSString *const SHResourceCategoryParseClass;
extern NSString *const SHChatCategoryParseClass;
extern NSString *const SHThreadParseClass;
extern NSString *const SHQuestionParseClass;
extern NSString *const SHNotificationParseClass;

//Cells
extern NSString *const SHBaseCellIdentifier;
extern NSString *const SHHuddleCellIdentifier;
extern NSString *const SHRequestCellIdentifier;
extern NSString *const SHNotificationCellIdentifier;
extern NSString *const SHClassCellIdentifier;
extern NSString *const SHStudyCellIdentifier;
extern NSString *const SHAddCellIdentifier;
extern NSString *const SHStudentCellIdentifier;
extern NSString *const SHResourceCellIdentifier;
extern NSString *const SHCategoryCellIdentifier;
extern NSString *const SHChatCellIdentifier;
extern NSString *const SHThreadCellIdentifier;
extern NSString *const SHHuddlePageCellIdentifier;

//Class
extern NSString *const SHClassFullNameKey;
extern NSString *const SHClassShortNameKey;
extern NSString *const SHClassTeacherKey;
extern NSString *const SHClassEmailKey;
extern NSString *const SHClassRoomKey;
extern NSString *const SHClassUniqueName;
extern NSString *const SHClassHuddlesKey;
extern NSString *const SHClassChatCategoriesKey;

//Huddle
extern NSString *const SHHuddleCreatorKey;
extern NSString *const SHHuddleNameKey;
extern NSString *const SHHuddleStatusKey;
extern NSString *const SHHuddleLowerName;
extern NSString *const SHHuddlePendingMembersKey;
extern NSString *const SHHuddleStudyKey;
extern NSString *const SHHuddleResourceCategoriesKey;
extern NSString *const SHHuddleChatCategoriesKey;
extern NSString *const SHHuddleImageKey;
extern NSString *const SHHuddleOnlineKey;
extern NSString *const SHHuddleLastStudyLogKey;
extern NSString *const SHHuddleLastStartKey;
extern NSString *const SHHuddleLocationKey;
extern NSString *const SHHuddleHoursStudiedKey;


//Student
extern NSString *const SHStudentNameKey;
extern NSString *const SHStudentEmailKey;
extern NSString *const SHStudentClassesKey;
extern NSString *const SHStudentMajorKey;
extern NSString *const SHStudentImageKey;
extern NSString *const SHStudentLowerNameKey;
extern NSString *const SHStudentHuddlesKey;
extern NSString *const SHStudentStudyLogsKey;
extern NSString *const SHStudentStudyingKey;
extern NSString *const SHStudentCurrentStudyLogKey;
extern NSString* const SHStudentLastStartKey;
extern NSString *const SHStudentHoursStudiedKey;
extern NSString* const SHStudentUnresolvedChannel; //a temporary channel the user will subscribed so that he can a push notification when his question was answered

//Study
extern NSString *const SHStudyClassesKey;
extern NSString *const SHStudyStartKey;
extern NSString *const SHStudyEndKey;
extern NSString *const SHStudyOnlineKey;
extern NSString *const SHStudyDescriptionKey;
extern NSString *const SHStudentStartOfStudyKey;

//Resources
extern NSString *const SHResourceHuddleKey;
extern NSString *const SHResourceCreatorKey;
extern NSString *const SHResourceNameKey;
extern NSString *const SHResourceCategoryKey;
extern NSString *const SHResourceDescriptionKey;
extern NSString *const SHResourceLinkKey;
extern NSString *const SHResourceFileKey;

//Resource Cateogry
extern NSString *const SHResourceCategoryNameKey;
extern NSString *const SHResourceCategoryHuddleKey;
extern NSString *const SHResourceCategoryResourcesKey;

//Requests
extern NSString *const SHRequestTitleKey;
extern NSString *const SHRequestSentTitleKey;
extern NSString *const SHRequestTypeKey;
extern NSString *const SHRequestHuddleKey;
extern NSString *const SHRequestToStudentKey;
extern NSString *const SHRequestFromStudentKey;
extern NSString *const SHRequestLocationKey;
extern NSString *const SHRequestTimeKey;
extern NSString *const SHRequestDescriptionKey;
extern NSString *const SHRequestSentDescriptionKey;
extern NSString *const SHRequestMessageKey;

//Request Types
extern NSString *const SHRequestSSInviteStudy;
extern NSString *const SHRequestSHJoin;
extern NSString *const SHRequestHSJoin;

//Notifications
extern NSString* const SHNotificationTitleKey;
extern NSString* const SHNotificationDescriptionKey;
extern NSString* const SHNotificationHuddleKey;
extern NSString* const SHNotificationToStudentKey;
extern NSString* const SHNotificationFromStudentKey;
extern NSString* const SHNotificationClassKey;
extern NSString* const SHNotificationTypeKey;
extern NSString* const SHNotificationReadKey;
extern NSString* const SHNotificationLocationKey;
extern NSString* const SHNotificationRequestAcceptedKey;
extern NSString *const SHNotificationMessageKey;
extern NSString* const SHNotificationParseClassKey;
extern NSString* const SHNotificationRoomKey;

//Notification types
extern NSString* const SHNotificationNewResourceType;
extern NSString* const SHNotificationNewHuddleMemberType;
extern NSString* const SHNotificationAnswerType;
extern NSString* const SHNotificationHuddleStartedStudyingType;
extern NSString* const SHNotificationSSStudyRequestType;
extern NSString* const SHNotificationSHJoinRequestType;
extern NSString* const SHNotificationHSJoinRequestType;
extern NSString* const SHNotificationHSStudyRequestType;
extern NSString* const SHNotificationQuestionKey;

//Notification Descriptions
extern NSString* const SHSSAcceptedStudyInviteRequestTitle;
extern NSString* const SHSSDeniedStudyInviteRequestTitle;
extern NSString* const SHSHAcceptedJoinRequestTitle;
extern NSString* const SHSHDeniedJoinRequestTitle;

//Chat Category
extern NSString* const SHChatCategoryNameKey;
extern NSString* const SHChatCategoryChatRoomKey;
extern NSString* const SHChatCategoryHuddleKey;

//Chat Room
extern NSString* const SHChatRoomClassKey;
extern NSString* const SHChatRoomRoomKey;
extern NSString* const SHChatRoomChatCategoryOwnerKey;
extern NSString* const SHChatRoomResolved;
extern NSString* const SHChatRoomCreatorIDKey;

//Chat (the bubbles)
extern NSString* const SHChatClassKey;
extern NSString* const SHChatUserKey;
extern NSString* const SHChatTextKey;
extern NSString* const SHChatRoomKey;

//Thread
extern NSString* const SHThreadTitle;
extern NSString* const SHThreadCreator;
extern NSString* const SHThreadQuestions;
extern NSString* const SHThreadChatCategoryKey;

//Question
extern NSString* const SHQuestionCreatorID;
extern NSString* const SHQuestionCreatorName;
extern NSString* const SHQuestionReplies;
extern NSString* const SHQuestionQuestion;
extern NSString* const SHQuestionClassName;

//Reply
extern NSString* const SHReplyCreatorID;
extern NSString* const SHReplyCreatorName;
extern NSString* const SHReplyAnswer;
extern NSString* const SHReplyClassName;

//Constants for chat feature
extern int const SHEditingQuestion;
extern int const SHReplying;
extern int const SHQuestioning;
extern int const SHEditingReply;

//PUSH constants
extern NSString* const SHPushChannelsKey;
extern NSString* const SHPushTypeKey;

//PUSH types
extern NSString* const SHPushTypeHuddleChatPost;

//SETTINGS
extern NSString* const SHSettingHoursToStudy;
extern NSString* const SHSettingPokeToStudy;
extern NSString* const SHSettingReceiveHuddleStudyingNotifications;
extern NSString* const SHSettingReceiveNewClassMemberNotifications;
extern NSString* const SHSettingReceiveNewHuddleMemberNotifications;
extern NSString* const SHSettingReceiveNewPostNotifications;
extern NSString* const SHSettingReceiveNewThreadPostNotifications;
extern NSString* const SHSettingReplyToYourPostNotifications;
extern NSString* const SHSettingReceiveResourceAddedNotifications;

#define modalWidth 270
#define textFieldHeight 30.0


//Segment Attributes
#define segmentFont [UIFont fontWithName:@"Arial" size:14]

#define segmentFrameX 0.0
#define segmentFrameY 0.0
#define segmentFrameDimX 320.0
#define segmentFrameDimY 20.0

#define tableViewX 0.0
#define tableViewY 35.0
#define tableViewDimX 320.0
#define tableViewDimY 800
#define extraSpace 0 //this is to make it more smooth

#define headerHeight 25.0
#define headerWidth 200.0


#define maxWidth 320.0
#define maxHeight 568.0

#define SHHuddleCellHeight 70.0
#define SHRequestCellHeight 65.0
#define SHNotificationCellHeight 65.0
#define SHClassCellHeight 50.0
#define SHStudyCellHeight 50.0
#define SHAddCellHeight 50.0
#define SHStudentCellHeight 70.0
#define SHChatCellHeight 50.0
#define SHHuddlePageCellHeight 190.0
#define SHResourceCellHeight 50.0
#define SHCategoryCellHeight 50.0

//Cell layout
#define vertBorderSpacing 10.0f
#define vertElemSpacing 5.0f

#define horiViewSpacing 15.0
#define vertViewSpacing 15.0

#define horiBorderSpacing 10.0f
#define horiBorderSpacingBottom 7.0f
#define horiElemSpacing 5.0f


#define cellPortraitX vertBorderSpacing
#define cellPortraitY horiBorderSpacing
#define cellPortraitDim SHHuddleCellHeight-2*vertBorderSpacing

#define titleX vertBorderSpacing
#define titleY horiBorderSpacing



//Portait
//#define portraitX
#define portraitY 10
#define portraitDim 100




