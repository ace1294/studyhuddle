//
//  SHNotificationSegmentViewController.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/30/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHNotificationSegmentViewController.h"

#import "SHProfileSegmentViewController.h"
#import "UIColor+HuddleColors.h"
#import "SHNotificationCell.h"
#import "SHRequestCell.h"
#import "SHConstants.h"
#import "Student.h"
#import "SHNewHuddleViewController.h"
#import "PFACL+NSCoding.h"
#import "PFFile+NSCoding.h"
#import "PFObject+NSCoding.h"
#import "SHProfileViewController.h"
#import "SHIndividualHuddleviewController.h"
#import "SHVisitorProfileViewController.h"
#import "SHClassPageViewController.h"
#import "SHIndividualHuddleviewController.h"
#import "SHUtility.h"

@interface SHNotificationSegmentViewController () <SHRequestCellDelegate>

@property (strong, nonatomic) NSString *docsPath;
@property (strong, nonatomic) Student *segStudent;

@property (strong, nonatomic) NSString *CellIdentifier;
@property (nonatomic, assign) NSInteger currentRowsToDisplay;
@property (nonatomic, strong) NSMutableDictionary *segCellIdentifiers;

@property (strong, nonatomic) NSArray *segMenu;

@property (strong, nonatomic) NSMutableDictionary *segmentData;

@property (strong, nonatomic) NSMutableArray *notificationsDataArray;
@property (strong, nonatomic) NSMutableArray *requestsDataArray;

@property (strong, nonatomic) NSMutableArray *encapsulatingDataArray;

@end

@implementation SHNotificationSegmentViewController

@synthesize CellIdentifier;


static NSString* const NotificationDiskKey = @"notificationArray";
static NSString* const RequestsDiskKey = @"requestsArray";


- (id)initWithStudent:(Student *)student
{
    self = [super init];
    if(self)
    {
        _segStudent = student;
        
        CellIdentifier = [[NSString alloc]init];
        
        self.segCellIdentifiers = [[NSMutableDictionary alloc]init];
        
        self.segmentData = [[NSMutableDictionary alloc]init];
        
        self.segMenu = [[NSArray alloc]initWithObjects:@"NOTIFICATIONS", @"REQUESTS", nil];
        self.docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        self.docsPath = [self.docsPath stringByAppendingPathComponent:@"notificationSegment"];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }
    
    return self;
}

+ (void)load
{
    [[DZNSegmentedControl appearance] setBackgroundColor:[UIColor clearColor]];
    [[DZNSegmentedControl appearance] setTintColor:[UIColor huddleOrange]];
    [[DZNSegmentedControl appearance] setHairlineColor:[UIColor huddleSilver]];
    
    [[DZNSegmentedControl appearance] setFont:segmentFont];
    [[DZNSegmentedControl appearance] setSelectionIndicatorHeight:2.5];
    [[DZNSegmentedControl appearance] setAnimationDuration:0.125];
    
}

- (void)loadView
{
    [super loadView];
    
    self.tableView.dataSource = self;
    
    self.notificationsDataArray = [[NSMutableArray alloc]init];
    self.requestsDataArray = [[NSMutableArray alloc]init];
    self.encapsulatingDataArray = [[NSMutableArray alloc]initWithObjects:self.notificationsDataArray,self.requestsDataArray, nil];
    
    
    [self loadStudentData];
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Tableview
    CGRect tableViewFrame = CGRectMake(tableViewX, tableViewY, tableViewDimX, tableViewDimY);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    //self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
    self.tableView.contentInset = UIEdgeInsetsMake(-100, 0, 0, 0);

    [self.view addSubview:self.tableView];
    
    
    //Set segment menu titles
    [self.segCellIdentifiers setObject:SHNotificationCellIdentifier forKey:[@"Notifications" uppercaseString]];
    [self.segCellIdentifiers setObject:SHRequestCellIdentifier forKey:[@"Requests" uppercaseString]];
   
    
    //Segment
    [self.view addSubview:self.control];
    
    [self.tableView registerClass:[SHRequestCell class] forCellReuseIdentifier:SHRequestCellIdentifier];
    [self.tableView registerClass:[SHNotificationCell class] forCellReuseIdentifier:SHNotificationCellIdentifier];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.segStudent username])
    {
//        if([[NSFileManager defaultManager] fileExistsAtPath:self.docsPath])
//        {
//            [self loadDataFromDisk];
//            return;
//        }
        
        [self loadStudentData];
    }
    
    self.currentRowsToDisplay = [[self.encapsulatingDataArray objectAtIndex:self.control.selectedSegmentIndex]count];
    [self.tableView reloadData];
}

- (void)setStudent:(Student *)aSegStudent
{
    _segStudent = aSegStudent;
    [self loadStudentData];
}

- (BOOL)loadStudentData
{
    BOOL loadError = true;
    
    NSLog(@"Loading student Data");
    
    //[self.segStudent fetch];
    
    
    //Notifications Data
    NSMutableArray *notifications = [[NSMutableArray alloc]init];
    [notifications addObjectsFromArray:[self.segStudent objectForKey:SHStudentNotificationsKey]];
    NSLog(@"notifications: %@",notifications);
    
    PFQuery *notificationQuery = [PFQuery queryWithClassName:SHNotificationParseClass];
    [notificationQuery whereKey:SHNotificationStudentKey equalTo:[PFObject objectWithoutDataWithClassName:SHStudentParseClass objectId:[[Student currentUser] objectId]]];
    [notifications addObjectsFromArray:[notificationQuery findObjects]];
    
    [self.segStudent addUniqueObjectsFromArray:[notificationQuery findObjects] forKey:SHStudentNotificationsKey];
    [self.segStudent saveInBackground];
    
    //sort them based on date created
    NSArray *sortedArray;
    sortedArray = [notifications sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        [a fetchIfNeeded];
        [b fetchIfNeeded];
     
    
        PFObject* firstNotification = (PFObject*)a;
        
        NSDate* first = [firstNotification createdAt];
    
        
        PFObject* secondNotification = (PFObject*)b;
        NSDate* second = [secondNotification createdAt];
      
        
   
        return [second compare:first];
       
    }];
    
    [self.notificationsDataArray removeAllObjects];
    [self.notificationsDataArray addObjectsFromArray:sortedArray];

    //[SHUtility fetchObjectsInArray:self.notificationsDataArray];
    
    [self.control setCount:[NSNumber numberWithInt:self.notificationsDataArray.count] forSegmentAtIndex:0];
    
    
    //Requests Data
    NSArray *requests = [self.segStudent objectForKey:SHStudentRequestsKey];
    self.currentRowsToDisplay = requests.count;
    
    [self.requestsDataArray removeAllObjects];
    [self.requestsDataArray addObjectsFromArray:requests];
    
    PFQuery *ssInviteStudy = [PFQuery queryWithClassName:SHRequestParseClass];
    PFQuery *shJoin = [PFQuery queryWithClassName:SHRequestParseClass];
    PFQuery *hsJoin = [PFQuery queryWithClassName:SHRequestParseClass];
    PFQuery *scJoin = [PFQuery queryWithClassName:SHRequestParseClass];
    
    [ssInviteStudy whereKey:SHRequestTypeKey equalTo:SHRequestSSInviteStudy];
    [ssInviteStudy whereKey:SHRequestStudent2Key equalTo:[PFObject objectWithoutDataWithClassName:SHStudentParseClass objectId:[[Student currentUser] objectId]]];
    
    [shJoin whereKey:SHRequestTypeKey equalTo:SHRequestSHJoin];
    [shJoin whereKey:SHRequestStudent2Key equalTo:[PFObject objectWithoutDataWithClassName:SHStudentParseClass objectId:[[Student currentUser] objectId]]];
    
    [hsJoin whereKey:SHRequestTypeKey equalTo:SHRequestHSJoin];
    [hsJoin whereKey:SHRequestStudent1Key equalTo:[PFObject objectWithoutDataWithClassName:SHStudentParseClass objectId:[[Student currentUser] objectId]]];
    
    [scJoin whereKey:SHRequestTypeKey equalTo:SHRequestSCJoin];
    [scJoin whereKey:SHRequestStudent1Key equalTo:[PFObject objectWithoutDataWithClassName:SHStudentParseClass objectId:[[Student currentUser] objectId]]];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[ssInviteStudy,shJoin,hsJoin,scJoin]];
    
    [self.segStudent addUniqueObjectsFromArray:[query findObjects] forKey:SHStudentRequestsKey];
    [self.segStudent saveInBackground];
    [self.requestsDataArray addObjectsFromArray:[query findObjects]];
    
    //[SHUtility fetchObjectsInArray:self.requestsDataArray];
    
    [self.control setCount:[NSNumber numberWithInt:self.requestsDataArray.count] forSegmentAtIndex:1];
    
    
    

    [self.tableView reloadData];
    
    //[self saveDataToDisk];
    
    return loadError;
}

- (void)saveDataToDisk
{
    
    NSLog(@"SAVING TO DISK");
    
    [self.segmentData setObject:self.requestsDataArray forKey:RequestsDiskKey];
    [self.segmentData setObject:self.notificationsDataArray forKey:NotificationDiskKey];
    
    [NSKeyedArchiver archiveRootObject:self.segmentData toFile:self.docsPath];
    
}

- (void)loadDataFromDisk
{
    NSLog(@"LOADING FROM DISK");
    
    self.segmentData = [NSKeyedUnarchiver unarchiveObjectWithFile:self.docsPath];
    
    self.requestsDataArray = [self.segmentData objectForKey:RequestsDiskKey];
    self.notificationsDataArray = [self.segmentData objectForKey:NotificationDiskKey];

}

#pragma mark - DZNSegmentController

- (DZNSegmentedControl *)control
{
    
    if (!_control)
    {
        _control = [[DZNSegmentedControl alloc] initWithItems:self.segMenu];
        _control.delegate = self;
        _control.selectedSegmentIndex = 1;
        _control.inverseTitles = NO;
        _control.tintColor = [UIColor huddleOrange];
        _control.hairlineColor = [UIColor grayColor];
        //        _control.hairlineColor = self.view.tintColor;
        _control.showsCount = YES;
        //        _control.autoAdjustSelectionIndicatorWidth = YES;
        
        
        [_control addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
    }
    return _control;
}

- (void)selectedSegment:(DZNSegmentedControl *)control
{
    self.currentRowsToDisplay = [[self.encapsulatingDataArray objectAtIndex:control.selectedSegmentIndex]count];
    [self.tableView reloadData];
}


- (UIBarPosition)positionForBar:(id <UIBarPositioning>)view
{
    return UIBarPositionBottom;
}


#pragma mark - UITableViewDelegate Methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] isEqual:@"NOTIFICATIONS"])
        return SHNotificationCellHeight;
    else
        return SHRequestCellHeight;
    
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentRowsToDisplay;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellIdentifier = [self.segCellIdentifiers objectForKey:[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex]];

    if([CellIdentifier isEqual:SHNotificationCellIdentifier])
    {
        
        
        PFObject* notificationObject = [self.notificationsDataArray objectAtIndex:(int)indexPath.row];
        SHNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        [notificationObject fetchIfNeeded];
        
        cell.delegate = self;
        
        [cell setNotification:notificationObject];
        [cell layoutIfNeeded];
       
        
        return cell;
    }
    
    else if([CellIdentifier isEqual:SHRequestCellIdentifier])
    {
        PFObject* requestObject = [self.requestsDataArray objectAtIndex:(int)indexPath.row];
        SHRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        [requestObject fetchIfNeeded];
        
        cell.delegate = self;
        
        [cell setRequest:requestObject];
        [cell layoutIfNeeded];
        
        return cell;
    }
    
    
    
    return nil;
}





- (void)didTapTitleCell:(SHBaseTextCell *)cell
{
   if ([cell isKindOfClass:[SHNotificationCell class]] )
   {
       SHNotificationCell* notificationCell = (SHNotificationCell*)cell;
       PFObject* notificationObject = [notificationCell getNotificationObj];
       
       //check the type of notification
//       if([notificationObject[SHNotificationTypeKey] isEqualToString:SHNotificationNewMember])
//       {
//           PFObject* huddleObject = notificationObject[SHNotificationHuddleKey];
//           [huddleObject fetchIfNeeded];
//           SHIndividualHuddleviewController* newHuddleView = [[SHIndividualHuddleviewController alloc]initWithHuddle:huddleObject andInitialSection:0];
//           
//           [self.navigationController pushViewController:newHuddleView animated:YES];
//       }
//       else if([notificationObject[SHNotificationTypeKey] isEqualToString:SHNotificationHuddleStartedStudying])
//       {
//           PFObject* huddleObject = notificationObject[SHNotificationHuddleKey];
//           [huddleObject fetchIfNeeded];
//           SHIndividualHuddleviewController* indvHuddle = [[SHIndividualHuddleviewController alloc]initWithHuddle:huddleObject];
//           
//           [self.navigationController pushViewController:indvHuddle animated:NO];
//       }
       

   } else if ([cell isKindOfClass:[SHNotificationCell class]] )
   {
       
   }
    
    
}

#pragma mark - Request Cell Deleagte methods

- (void)didTapAccept:(PFObject *)request
{
    NSString *type = request[SHRequestTypeKey];
    
    if([type isEqualToString:SHRequestSSInviteStudy])
    {
        //Student 2 accepted Student 1's request to study
        
        PFObject *student2 = request[SHRequestStudent2Key];
        [student2 fetchIfNeeded];
        
        PFObject *notification = [PFObject objectWithClassName:SHNotificationParseClass];
        notification[SHNotificationStudentKey] = request[SHRequestStudent1Key];
        notification[SHNotificationTitleKey] = student2[SHStudentNameKey];
        notification[SHNotificationTypeKey] = SHNotificationSSStudyRequestType;
        notification[SHNotificationRequestAcceptedKey] = [NSNumber numberWithBool:TRUE];
        notification[SHNotificationDescriptionKey] = SHSSAcceptedStudyInviteRequestTitle;
        
        [notification saveInBackground];
        
    } else if([type isEqualToString:SHRequestSHJoin])
    {
        //Huddle Creator accepted Student1's request to join Huddle
        
        PFObject *huddle = request[SHRequestHuddleKey];
        [huddle fetchIfNeeded];
        
        PFObject *student1 = request[SHRequestStudent1Key];
        [student1 fetchIfNeeded];
        
        [student1 addObject:huddle forKey:SHStudentHuddlesKey];
        [huddle addObject:student1 forKey:SHHuddleMembersKey];
        [student1 saveInBackground];
        [huddle saveInBackground];
        
        
        PFObject *notification = [PFObject objectWithClassName:SHNotificationParseClass];
        notification[SHNotificationStudentKey] = student1;
        notification[SHNotificationTitleKey] = huddle[SHHuddleNameKey];
        notification[SHNotificationTypeKey] = SHNotificationSHJoinRequestType;
        notification[SHNotificationRequestAcceptedKey] = [NSNumber numberWithBool:TRUE];
        notification[SHNotificationDescriptionKey] = SHSHAcceptedJoinRequestTitle;
        
        [notification saveInBackground];
        
        for(Student *member in huddle[SHHuddleMembersKey])
        {
            if([member isEqual:huddle[SHHuddleCreatorKey]])
                continue;
            
            PFObject *memberNotification = [PFObject objectWithClassName:SHNotificationParseClass];
            
            [member fetchIfNeeded];
            memberNotification[SHNotificationStudentKey] = member;
            memberNotification[SHNotificationTitleKey] = huddle[SHHuddleNameKey];
            memberNotification[SHNotificationTypeKey] = SHNotificationNewHuddleMemberType;
            
            NSString *description = [NSString stringWithFormat:@"%@ added to huddle", student1[SHStudentNameKey]];
            memberNotification[SHNotificationDescriptionKey] = description;
            
            [memberNotification saveInBackground];
        }
        
        
    } else if([type isEqualToString:SHRequestHSJoin])
    {
        
        PFObject *huddle = request[SHRequestHuddleKey];
        [huddle fetchIfNeeded];
        
        PFObject *student1 = request[SHRequestStudent1Key];
        [student1 fetchIfNeeded];
        
        [student1 addObject:huddle forKey:SHStudentHuddlesKey];
        [huddle addObject:student1 forKey:SHHuddleMembersKey];
        
        [student1 saveInBackground];
        [huddle saveInBackground];
        
        PFObject *creator = huddle[SHHuddleCreatorKey];
        //[creator fetchIfNeeded];
        
        PFObject *notification = [PFObject objectWithClassName:SHNotificationParseClass];
        notification[SHNotificationStudentKey] = creator;
        notification[SHNotificationTitleKey] = huddle[SHHuddleNameKey];
        notification[SHNotificationTypeKey] = SHNotificationHSJoinRequestType;
        notification[SHNotificationRequestAcceptedKey] = [NSNumber numberWithBool:TRUE];
        
        NSString *description = [NSString stringWithFormat:@"%@ accepted request to join huddle", student1[SHStudentNameKey]];
        notification[SHNotificationDescriptionKey] = description;
        
        [notification saveInBackground];
        
        
        for(Student *member in huddle[SHHuddleMembersKey])
        {
            PFObject *memberNotification = [PFObject objectWithClassName:SHNotificationParseClass];
            
            [member fetchIfNeeded];
            memberNotification[SHNotificationStudentKey] = member;
            memberNotification[SHNotificationTitleKey] = huddle[SHHuddleNameKey];
            memberNotification[SHNotificationTypeKey] = SHNotificationNewHuddleMemberType;
            memberNotification[SHNotificationRequestAcceptedKey] = [NSNumber numberWithBool:TRUE];
            
            NSString *description = [NSString stringWithFormat:@"%@ added to huddle", student1[SHStudentNameKey]];
            memberNotification[SHNotificationDescriptionKey] = description;
            
            [memberNotification saveInBackground];
        }
        
    } else if([type isEqualToString:SHRequestSCJoin])
    {
        PFObject *huddle = request[SHRequestHuddleKey];
        [huddle fetchIfNeeded];
        
        PFObject *student1 = request[SHRequestStudent1Key];
        [student1 fetchIfNeeded];
        
        PFObject *student2 = request[SHRequestStudent2Key];
        [student1 fetchIfNeeded];
        
        PFObject *notification = [PFObject objectWithClassName:SHNotificationParseClass];
        notification[SHNotificationStudentKey] = request[SHRequestStudent3Key];
        notification[SHNotificationTitleKey] = huddle[SHHuddleNameKey];
        notification[SHNotificationTypeKey] = SHNotificationSCJoinRequestType;
        notification[SHNotificationRequestAcceptedKey] = [NSNumber numberWithBool:TRUE];
        
        NSString *description = [NSString stringWithFormat:@"%@ sent a request to %@", student1[SHStudentNameKey], student2[SHStudentNameKey]];
        notification[SHNotificationDescriptionKey] = description;
        
        [notification saveInBackground];
        
        PFObject *newRequest = [PFObject objectWithClassName:SHRequestParseClass];
    
        newRequest[SHRequestTitleKey] = huddle[SHHuddleNameKey];
        newRequest[SHRequestHuddleKey] = huddle;
        newRequest[SHRequestTypeKey] = SHRequestHSJoin;
        newRequest[SHRequestStudent1Key] = request[SHRequestStudent2Key];
        newRequest[SHRequestStudent2Key] = request[SHRequestStudent3Key];
        
        [newRequest saveInBackground];
        
    }
    
    
    [self.segStudent removeObject:request forKey:SHStudentRequestsKey];
    [self.requestsDataArray removeObject:request];
    [request deleteInBackground];
    
    self.currentRowsToDisplay--;
    [self.tableView reloadData];
}

- (void)didTapDeny:(PFObject *)request
{
    NSString *type = request[SHRequestTypeKey];
    
    if([type isEqualToString:SHRequestSSInviteStudy])
    {
        //Student 2 denied Student 1's request to study
        
        PFObject *student2 = request[SHRequestStudent2Key];
        [student2 fetchIfNeeded];
        
        PFObject *notification = [PFObject objectWithClassName:SHNotificationParseClass];
        notification[SHNotificationStudentKey] = request[SHRequestStudent1Key];
        notification[SHNotificationTitleKey] = student2[SHStudentNameKey];
        notification[SHNotificationTypeKey] = SHNotificationSSStudyRequestType;
        notification[SHNotificationRequestAcceptedKey] = [NSNumber numberWithBool:FALSE];
        notification[SHNotificationDescriptionKey] = SHSSDeniedStudyInviteRequestTitle;
        
        [notification saveInBackground];
        
    } else if([type isEqualToString:SHRequestSHJoin])
    {
        //Huddle Creator denied Student1's request to join Huddle
        
        PFObject *huddle = request[SHRequestHuddleKey];
        [huddle fetchIfNeeded];
        
        PFObject *student1 = request[SHRequestStudent1Key];
        [student1 fetchIfNeeded];
        
        PFObject *notification = [PFObject objectWithClassName:SHNotificationParseClass];
        notification[SHNotificationStudentKey] = student1;
        notification[SHNotificationTitleKey] = huddle[SHHuddleNameKey];
        notification[SHNotificationTypeKey] = SHNotificationSHJoinRequestType;
        notification[SHNotificationRequestAcceptedKey] = [NSNumber numberWithBool:FALSE];
        notification[SHNotificationDescriptionKey] = SHSHDeniedJoinRequestTitle;
        
        [notification saveInBackground];
        
        
    } else if([type isEqualToString:SHRequestHSJoin])
    {
        //Student1 denied Huddle's request to Join
        
        PFObject *huddle = request[SHRequestHuddleKey];
        [huddle fetchIfNeeded];
        
        PFObject *creator = huddle[SHHuddleCreatorKey];
        [creator fetchIfNeeded];
        
        PFObject *student1 = request[SHRequestStudent1Key];
        [student1 fetchIfNeeded];
        
        PFObject *notification = [PFObject objectWithClassName:SHNotificationParseClass];
        notification[SHNotificationStudentKey] = creator;
        notification[SHNotificationTitleKey] = huddle[SHHuddleNameKey];
        notification[SHNotificationTypeKey] = SHNotificationHSJoinRequestType;
        notification[SHNotificationRequestAcceptedKey] = [NSNumber numberWithBool:FALSE];
        
        NSString *description = [NSString stringWithFormat:@"%@ denied request to join huddle", student1[SHStudentNameKey]];
        notification[SHNotificationDescriptionKey] = description;
        
        [notification saveInBackground];
        
        if(request[SHRequestStudent2Key]){
            PFObject *notification = [PFObject objectWithClassName:SHNotificationParseClass];
            notification[SHNotificationStudentKey] = request[SHRequestStudent2Key];
            notification[SHNotificationTitleKey] = huddle[SHHuddleNameKey];
            notification[SHNotificationTypeKey] = SHNotificationHSJoinRequestType;
            notification[SHNotificationRequestAcceptedKey] = [NSNumber numberWithBool:FALSE];
            
            NSString *description = [NSString stringWithFormat:@"%@ denied request to join huddle", student1[SHStudentNameKey]];
            notification[SHNotificationDescriptionKey] = description;
            
            [notification saveInBackground];
        }
        
        
    } else if([type isEqualToString:SHRequestSCJoin])
    {
        PFObject *huddle = request[SHRequestHuddleKey];
        [huddle fetchIfNeeded];
        
        PFObject *student1 = request[SHRequestStudent1Key];
        [student1 fetchIfNeeded];
        
        PFObject *student2 = request[SHRequestStudent2Key];
        [student1 fetchIfNeeded];
        
        PFObject *notification = [PFObject objectWithClassName:SHNotificationParseClass];
        notification[SHNotificationStudentKey] = request[SHRequestStudent3Key];
        notification[SHNotificationTitleKey] = huddle[SHHuddleNameKey];
        notification[SHNotificationTypeKey] = SHNotificationSCJoinRequestType;
        notification[SHNotificationRequestAcceptedKey] = [NSNumber numberWithBool:FALSE];
        
        NSString *description = [NSString stringWithFormat:@"%@ denied your request to admit %@", student1[SHStudentNameKey], student2[SHStudentNameKey]];
        notification[SHNotificationDescriptionKey] = description;
        
        [notification saveInBackground];
    }
    
    [self.segStudent removeObject:request forKey:SHStudentRequestsKey];
    [self.requestsDataArray removeObject:request];
    [request deleteInBackground];
    
    self.currentRowsToDisplay--;
    [self.tableView reloadData];
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<0) {
        [self.parentScrollView setScrollEnabled:YES];
    }
    
}



@end

