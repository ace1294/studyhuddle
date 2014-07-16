//
//  SHConstants.h
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/14/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

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
extern NSString *const SHClassStudentsKey;
extern NSString *const SHClassHuddlesKey;

//Huddle
extern NSString *const SHHuddleCreatorKey;
extern NSString *const SHHuddleNameKey;
extern NSString *const SHHuddleMembersKey;
extern NSString *const SHHuddleClassKey;
extern NSString *const SHHuddleStatusKey;
extern NSString *const SHHuddleUniqueName;
extern NSString *const SHHuddleStudyKey;
extern NSString *const SHHuddleResourceCategoriesKey;
extern NSString *const SHHuddleImageKey;
extern NSString *const SHHuddleStudyingKey;
extern NSString *const SHHuddleChatCategoriesKey;

//Student
extern NSString *const SHStudentNameKey;
extern NSString *const SHStudentClassesKey;
extern NSString *const SHStudentMajorKey;
extern NSString *const SHStudentImageKey;
extern NSString *const SHStudentLowerNameKey;
extern NSString *const SHStudentHuddlesKey;
extern NSString *const SHStudentStudyKey;
extern NSString *const SHStudentStudyingKey;
extern NSString *const SHStudentOnlineFriendsKey;
extern NSString *const SHStudentRequestsKey;
extern NSString *const SHStudentNotificationsKey;
//Study
extern NSString *const SHStudyClassesKey;
extern NSString *const SHStudyStartKey;
extern NSString *const SHStudyEndKey;
extern NSString *const SHStudyOnlineKey;
extern NSString *const SHStudyDescriptionKey;
extern NSString *const SHStudyStudentKey;

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
extern NSString *const SHRequestTypeKey;
extern NSString *const SHRequestHuddleKey;
extern NSString *const SHRequestStudent1Key;
extern NSString *const SHRequestStudent2Key;
extern NSString *const SHRequestStudent3Key;
extern NSString *const SHRequestLocationKey;
extern NSString *const SHRequestTimeKey;
extern NSString *const SHRequestDescriptionKey;

//Request Types
extern NSString *const SHRequestSSInviteStudy;
extern NSString *const SHRequestSHJoin;
extern NSString *const SHRequestHSJoin;
extern NSString *const SHRequestSCJoin;

//Notifications
extern NSString* const SHNotificationTitleKey;
extern NSString* const SHNotificationDescriptionKey;
extern NSString* const SHNotificationHuddleKey;
extern NSString* const SHNotificationStudentKey;
extern NSString* const SHNotificationClassKey;
extern NSString* const SHNotificationTypeKey;
extern NSString* const SHNotificationReadKey;
extern NSString* const SHNotificationDateKey;
extern NSString* const SHNotificationLocationKey;
extern NSString* const SHNotificationRequestAcceptedKey;

//Notification types
extern NSString* const SHNotificationNewResourceType;
extern NSString* const SHNotificationNewHuddleMemberType;
extern NSString* const SHNotificationAnswerType;
extern NSString* const SHNotificationHuddleStartedStudyingType;
extern NSString* const SHNotificationSSStudyRequestType;
extern NSString* const SHNotificationSHJoinRequestType;
extern NSString* const SHNotificationHSJoinRequestType;
extern NSString* const SHNotificationSCJoinRequestType;
extern NSString* const SHNotificationHSStudyRequestType;

//Notification Descriptions
extern NSString* const SHSSAcceptedStudyInviteRequestTitle;
extern NSString* const SHSSDeniedStudyInviteRequestTitle;
extern NSString* const SHSHAcceptedJoinRequestTitle;
extern NSString* const SHSHDeniedJoinRequestTitle;

//Chat Category
extern NSString* const SHChatCategoryNameKey;
extern NSString* const SHChatCategoryThreadsKey;

//Thread
extern NSString* const SHThreadTitle;
extern NSString* const SHThreadCreator;
extern NSString* const SHThreadQuestions;

//Question
extern NSString* const SHQuestionCreator;
extern NSString* const SHQuestionReplies;
extern NSString* const SHQuestionQuestion;
extern NSString* const SHQuestionClassName;

//Reply
extern NSString* const SHReplyCreator;
extern NSString* const SHReplyAnswer;
extern NSString* const SHReplyClassName;

//Constants for chat feature
extern int const SHEditingQuestion;
extern int const SHReplying;
extern int const SHQuestioning;
extern int const SHEditingReply;


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
#define SHRequestCellHeight 70.0
#define SHNotificationCellHeight 70.0
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

#define nameMaxWidth 200.0f

#define cellPortraitX vertBorderSpacing
#define cellPortraitY horiBorderSpacing
#define cellPortraitDim SHHuddleCellHeight-2*vertBorderSpacing

#define titleX vertBorderSpacing
#define titleY horiBorderSpacing

//Arrow
#define arrowX 295.0f
#define arrowY 25.0
#define arrowDimX 10.0f
#define arrowDimY 20.0

//Portait
//#define portraitX
#define portraitY 10
#define portraitDim 100




