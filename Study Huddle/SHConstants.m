//
//  SHConstants.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/14/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHConstants.h"

#pragma mark - Cells

//Parse
NSString *const SHHuddleParseClass = @"Huddles";
NSString *const SHClassParseClass = @"Classes";
NSString *const SHStudentParseClass = @"_User";
NSString *const SHHSRequestParseClass = @"HSRequests";
NSString *const SHSHRequestParseClass = @"SHRequests";
NSString *const SHSSRequestParseClass = @"SSRequests";
NSString *const SHStudyParseClass = @"Study";
NSString *const SHResourceParseClass = @"Resources";
NSString *const SHCategoryParseClass = @"Category";

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
NSString *const SHHuddleNameKey = @"huddleName";
NSString *const SHHuddleMembersKey = @"huddleMembers";
NSString *const SHHuddleClassKey = @"huddleClass";
NSString *const SHHuddleStatusKey = @"huddleStatus";
NSString *const SHHuddleUniqueName = @"uniqueName";
NSString *const SHHuddleStudyKey = @"study";
NSString *const SHHuddleResourceCategoriesKey = @"resourceCategories";
NSString *const SHHuddleImageKey = @"huddleImage";
NSString *const SHHuddleStudyingKey = @"isStudying";
NSString *const SHHuddleChatEntriesKey = @"chatEntries";

//Student
NSString *const SHStudentNameKey = @"fullName";
NSString *const SHStudentClassesKey = @"classes";
NSString *const SHStudentMajorKey = @"major";
NSString *const SHStudentImageKey = @"userImage";
NSString *const SHStudentLowerNameKey = @"lowerName";
NSString *const SHStudentHuddlesKey = @"huddles";
NSString *const SHStudentStudyKey = @"study";
NSString *const SHStudentOnlineFriendsKey = @"online";
NSString *const SHStudentStudyingKey = @"isStudying";
NSString *const SHStudentRequestsKey = @"requests";
NSString *const SHStudentNotificationsKey = @"notifications";

//Study
NSString *const SHStudyClassesKey = @"classes";
NSString *const SHStudyStartKey = @"start";
NSString *const SHStudyEndKey = @"end";
NSString *const SHStudyUniqueName  = @"uniqueName";
NSString *const SHStudyOnline = @"online";

//Resources
NSString *const SHResourceHuddleKey = @"huddle";
NSString *const SHResourceCreatorKey = @"creator";
NSString *const SHResourceNameKey = @"title";
NSString *const SHResourceCategoryKey = @"category";
NSString *const SHResourceDescriptionKey = @"description";
NSString *const SHResourceLinkKey = @"link";
NSString *const SHResourceFileKey = @"file";

//Cateogry
NSString *const SHCategoryNameKey = @"name";
NSString *const SHCategoryHuddleKey = @"huddle";
NSString *const SHCategoryResourcesKey = @"resources";

//Requests
NSString *const SHRequestTitle = @"title";
NSString *const SHRequestSubTitle = @"subTitle";

//Notifications
NSString* const SHNotificationTitle = @"title";
NSString* const SHNotificationSubTitle = @"subTitle";
NSString* const SHNotificationHuddleResource = @"huddleResource";
NSString* const SHNotificationNewMember = @"huddleNewMember";
NSString* const SHNotificationAnswer = @"answerToQuestion";
NSString* const SHNotificationHuddleStartedStudying = @"huddleStartsStudying";
NSString* const SHNotificationHuddleKey = @"huddle";
NSString* const SHNotificationStudentKey = @"student";
NSString* const SHNotificationClassKey = @"class";
NSString* const SHNotificationTypeKey = @"type";
NSString* const SHNotificationReadKey = @"read";
NSString* const SHNotificationDateKey = @"createdAt";

//Thread
NSString* const SHThreadTitle = @"title";
NSString* const SHThreadCreator = @"creator";
NSString* const SHThreadQuestions = @"questions";

//Question
NSString* const SHQuestionCreator = @"creator";
NSString* const SHQuestionReplies = @"replies";
NSString* const SHQuestionQuestion = @"question";
NSString* const SHQuestionClassName = @"Question";

//Reply
NSString* const SHReplyCreator = @"creator";
NSString* const SHReplyAnswer = @"answer";
NSString* const SHReplyClassName = @"Reply";

//Chat Entry
NSString* const SHChatEntryCategoryKey = @"category";
NSString* const SHChatEntryThreadsKey = @"threads";
