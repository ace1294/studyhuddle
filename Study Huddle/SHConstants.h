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
extern NSString *const SHHSRequestParseClass;
extern NSString *const SHSHRequestParseClass;
extern NSString *const SHSSRequestParseClass;
extern NSString *const SHStudyParseClass;
extern NSString *const SHResourceParseClass;


//Cells
extern NSString *const SHHuddleCellIdentifier;
extern NSString *const SHRequestCellIdentifier;
extern NSString *const SHNotificationCellIdentifier;
extern NSString *const SHClassCellIdentifier;
extern NSString *const SHStudyCellIdentifier;
extern NSString *const SHAddCellIdentifier;
extern NSString *const SHStudentCellIdentifier;
extern NSString *const SHResourceCellIdentifier;
extern NSString *const SHCategoryCellIdentifier;

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
extern NSString *const SHHuddleNameKey;
extern NSString *const SHHuddleMembersKey;
extern NSString *const SHHuddleClassKey;
extern NSString *const SHHuddleStatusKey;
extern NSString *const SHHuddleUniqueName;
extern NSString *const SHHuddleStudyKey;
extern NSString *const SHHuddleResourcesKey;
extern NSString *const SHHuddleImageKey;
extern NSString *const SHHuddleStudyingKey;

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
extern NSString *const SHStudyDateKey;
extern NSString *const SHStudyUniqueName;

//Resources
extern NSString *const SHResourceOwnerKey;
extern NSString *const SHResourceCreatorKey;
extern NSString *const SHResourceNameKey;
extern NSString *const SHResourceCategoryKey;
extern NSString *const SHResourceDescriptionKey;
extern NSString *const SHResourceLinkKey;
extern NSString *const SHResourceFileKey;

//Notifications
extern NSString* const SHNotificationTitle;
extern NSString* const SHNotificationSubTitle;


#define newResourceWidth 270


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



#define maxWidth 320.0
#define maxHeight 568.0

#define SHHuddleCellHeight 70.0
#define SHRequestCellHeight 70.0
#define SHClassCellHeight 50.0
#define SHStudyCellHeight 50.0
#define SHAddCellHeight 50.0
#define SHStudentCellHeight 70.0

//Cell layout
#define vertBorderSpacing 6.0f
#define vertElemSpacing 5.0f

#define horiBorderSpacing 5.0f
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
#define arrowDimX 15.0f
#define arrowDimY 20.0

//Portait
//#define portraitX
#define portraitY 10
#define portraitDim 100




