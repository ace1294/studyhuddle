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
#import "SHNewHuddleViewController.h"
#import "PFACL+NSCoding.h"
#import "PFFile+NSCoding.h"
#import "PFObject+NSCoding.h"
#import "SHProfileViewController.h"
#import "SHIndividualHuddleviewController.h"
#import "SHVisitorProfileViewController.h"
#import "SHClassPageViewController.h"
#import "SHIndividualHuddleViewController.h"
#import "SHUtility.h"
#import "SHCache.h"
#import "ChatView.h"
#import "MBProgressHUD.h"

@interface SHNotificationSegmentViewController () <SHRequestCellDelegate,MBProgressHUDDelegate>{
    int selectedIndex;
}

@property (strong, nonatomic) PFUser *segStudent;

@property (strong, nonatomic) NSString *CellIdentifier;
@property (nonatomic, assign) NSInteger currentRowsToDisplay;
@property (nonatomic, strong) NSMutableDictionary *segCellIdentifiers;

@property (strong, nonatomic) NSArray *segMenu;

@property (strong, nonatomic) NSMutableDictionary *segmentData;

@property (strong, nonatomic) NSMutableArray *notificationsDataArray;
@property (strong, nonatomic) NSMutableArray *requestsDataArray;
@property (strong, nonatomic) NSMutableArray *sentRequestsDataArray;

@property (strong, nonatomic) NSMutableArray *encapsulatingDataArray;
@property (strong, nonatomic) NSMutableIndexSet *expandableNotificationCells;

@end

@implementation SHNotificationSegmentViewController

@synthesize CellIdentifier;


static NSString* const NotificationDiskKey = @"notificationArray";
static NSString* const RequestsDiskKey = @"requestsArray";




- (id)initWithStudent:(PFUser *)student
{
    self = [super init];
    if(self)
    {
        _segStudent = student;
        selectedIndex = -1;
        
        CellIdentifier = [[NSString alloc]init];
        
        self.segCellIdentifiers = [[NSMutableDictionary alloc]init];
        
        self.segmentData = [[NSMutableDictionary alloc]init];
        
        self.segMenu = [[NSArray alloc]initWithObjects:@"NOTIFICATIONS", @"REQUESTS", @"SENT REQUESTS",nil];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }
    
    return self;
}

+ (void)load
{
    [[DZNSegmentedControl appearance] setTintColor:[UIColor huddleOrange]];
    [[DZNSegmentedControl appearance] setHairlineColor:[UIColor huddleSilver]];
    [[DZNSegmentedControl appearance] setBackgroundColor:[UIColor clearColor]];
    
    [[DZNSegmentedControl appearance] setFont:[UIFont fontWithName:@"Arial" size:12.0]];
    [[DZNSegmentedControl appearance] setSelectionIndicatorHeight:2.5];
    [[DZNSegmentedControl appearance] setAnimationDuration:0.125];
    
}

- (void)loadView
{
    [super loadView];
    
    self.tableView.dataSource = self;
    
    self.notificationsDataArray = [[NSMutableArray alloc]init];
    self.requestsDataArray = [[NSMutableArray alloc]init];
    self.sentRequestsDataArray = [[NSMutableArray alloc]init];
    self.encapsulatingDataArray = [[NSMutableArray alloc]initWithObjects:self.notificationsDataArray,self.requestsDataArray, self.sentRequestsDataArray, nil];
    self.expandableNotificationCells = [[NSMutableIndexSet alloc]init];
    
    [self loadStudentData];
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Tableview
    CGRect tableViewFrame = CGRectMake(tableViewX, tableViewY, tableViewDimX, tableViewDimY-400);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //self.tableView.bounces = NO;

    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    //self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
    self.tableView.contentInset = UIEdgeInsetsMake(-100, 0, 0, 0);
    self.tableView.contentSize = CGSizeMake(320, 5000);

    [self.view addSubview:self.tableView];
    
    
    //Set segment menu titles
    [self.segCellIdentifiers setObject:SHNotificationCellIdentifier forKey:[@"Notifications" uppercaseString]];
    [self.segCellIdentifiers setObject:SHRequestCellIdentifier forKey:[@"Requests" uppercaseString]];
    [self.segCellIdentifiers setObject:SHRequestCellIdentifier forKey:[@"Sent Requests" uppercaseString]];
    
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
        [self loadStudentData];
    }
    
    self.currentRowsToDisplay = [[self.encapsulatingDataArray objectAtIndex:self.control.selectedSegmentIndex]count];
    [self.tableView reloadData];
}

- (void)setStudent:(PFUser *)aSegStudent
{
    _segStudent = aSegStudent;
    [self loadStudentData];
}

- (BOOL)loadStudentData
{
    BOOL loadError = true;
    
    //sort them based on date created
    NSArray *sortedArray;
    sortedArray = [[[SHCache sharedCache] notifications] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
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
    
    [self findExpandableNotificaitonTypes];
    
    [self.control setCount:[NSNumber numberWithInt:(int)self.notificationsDataArray.count] forSegmentAtIndex:0];
    
    //Requests Data
    [self.requestsDataArray removeAllObjects];
    [self.requestsDataArray addObjectsFromArray:[[SHCache sharedCache]requests]];
    
    [self.control setCount:[NSNumber numberWithInt:(int)self.requestsDataArray.count] forSegmentAtIndex:1];
    
    [self.sentRequestsDataArray removeAllObjects];
    [self.sentRequestsDataArray addObjectsFromArray:[[SHCache sharedCache]sentRequests]];
    
    [self.control setCount:[NSNumber numberWithInt:(int)self.sentRequestsDataArray.count] forSegmentAtIndex:2];
    
    self.currentRowsToDisplay = [[self.encapsulatingDataArray objectAtIndex:self.control.selectedSegmentIndex] count];

    [self.tableView reloadData];
    
    return loadError;
}


#pragma mark - DZNSegmentController

- (DZNSegmentedControl *)control
{
    
    if (!_control)
    {
        _control = [[DZNSegmentedControl alloc] initWithItems:self.segMenu];
        _control.delegate = self;
        _control.selectedSegmentIndex = 0;
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
    
    selectedIndex = -1;
    
    [self.tableView reloadData];
}


- (UIBarPosition)positionForBar:(id <UIBarPositioning>)view
{
    return UIBarPositionBottom;
}


#pragma mark - UITableViewDelegate Methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedIndex == indexPath.row){
        
        if([[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] isEqual:@"NOTIFICATIONS"]){
            id cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            SHNotificationCell *notificationCell = (SHNotificationCell *)cell;
            return  [notificationCell heightForExpandedCell:notificationCell.notification[SHNotificationMessageKey]];
            
        } else {
            id cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            SHRequestCell *requestCell = (SHRequestCell *)cell;
            return  [requestCell heightForExpandedCell:requestCell.request[SHRequestMessageKey]];
        }
    }
    else{
        if([[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] isEqual:@"NOTIFICATIONS"]){
            id cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            SHNotificationCell *notificationCell = (SHNotificationCell *)cell;
            return  [notificationCell heightForCollapsedCell:notificationCell.notification[SHNotificationDescriptionKey]];
            
        } else {
            id cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
            SHRequestCell *requestCell = (SHRequestCell *)cell;
            return  [requestCell heightForCollapsedCell:requestCell.request[SHRequestDescriptionKey]];
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.control.selectedSegmentIndex == 2)
        return;
    
    CellIdentifier = [self.segCellIdentifiers objectForKey:[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex]];
    
    if([CellIdentifier isEqual:SHNotificationCellIdentifier])
    {
        if ([self.expandableNotificationCells containsIndex:indexPath.row]) {
            if(selectedIndex == indexPath.row){
                selectedIndex = -1;
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                return;
            }
            if(selectedIndex != -1){
                NSIndexPath *prevPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
                selectedIndex = (int)indexPath.row;
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:prevPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            selectedIndex = (int)indexPath.row;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else{
            PFObject* notification = [self.notificationsDataArray objectAtIndex:(int)indexPath.row];
            [notification fetchIfNeeded];
        }
    }
    
    else if([CellIdentifier isEqual:SHRequestCellIdentifier])
    {
        if(selectedIndex == indexPath.row)
        {
            selectedIndex = -1;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            return;
        }
        if(selectedIndex != -1)
        {
            NSIndexPath *prevPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
            selectedIndex = (int)indexPath.row;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:prevPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        selectedIndex = (int)indexPath.row;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    
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
        [notificationObject fetchIfNeeded];
        
        SHNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.delegate = self;
        [cell setNotification:notificationObject];
        
        if(selectedIndex == indexPath.row)
            [cell expand];
        else
            [cell collapse];

        [cell layoutIfNeeded];
       
        
        return cell;
    }
    
    else if([[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] isEqual:@"REQUESTS"])
    {
        PFObject* requestObject = [self.requestsDataArray objectAtIndex:(int)indexPath.row];
        [requestObject fetchIfNeeded];
        
        SHRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.delegate = self;
        [cell setRequest:requestObject];
        
        if(selectedIndex == indexPath.row)
            [cell expand];
        else
            [cell collapse];
        
        
        [cell layoutIfNeeded];
        
        return cell;
    } else
    {
        PFObject* sentRequestObject = [self.sentRequestsDataArray objectAtIndex:(int)indexPath.row];
        [sentRequestObject fetchIfNeeded];
        
        SHRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.delegate = self;
        [cell setSentRequest:sentRequestObject];
        [cell.arrowButton setHidden:YES];
        
        [cell collapse];
        
        
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
       PFObject* notification = notificationCell.notification;
       NSString *type = notification[SHNotificationTypeKey];
       
       PFUser *fromStudent = notification[SHNotificationFromStudentKey];
       [fromStudent fetchIfNeeded];
       
       if([type isEqual:SHNotificationSSStudyRequestType])
       {
           SHVisitorProfileViewController *visitorVC = [[SHVisitorProfileViewController alloc]initWithStudent:fromStudent];
           
           [self.navigationController pushViewController:visitorVC animated:YES];
       }
       else if([type isEqual:SHNotificationAnswerType])
       {
           NSString* chatRoomID = notification[SHNotificationRoomKey];
           ChatView *chatView = [[ChatView alloc] initWith:chatRoomID];
           chatView.hidesBottomBarWhenPushed = YES;
           [self.navigationController pushViewController:chatView animated:YES];
       }
       else {
           PFObject *huddle = notification[SHNotificationHuddleKey];
           [huddle fetchIfNeeded];
           
           SHIndividualHuddleViewController *huddleVC = [[SHIndividualHuddleViewController alloc]initWithHuddle:huddle];
           
           [self.navigationController pushViewController:huddleVC animated:YES];
       }
       

   } else if ([cell isKindOfClass:[SHRequestCell class]] )
   {
       SHRequestCell* requestCell = (SHRequestCell*)cell;
       PFObject* request = requestCell.request;
       NSString *type = request[SHRequestTypeKey];
       
       PFUser *fromStudent = request[SHRequestFromStudentKey];
       PFObject *huddle = request[SHRequestHuddleKey];
       
       if([type isEqual:SHRequestSSInviteStudy])
       {
           [fromStudent fetchIfNeeded];
           
           SHVisitorProfileViewController *visitorVC = [[SHVisitorProfileViewController alloc]initWithStudent:fromStudent];
           
           [self.navigationController pushViewController:visitorVC animated:YES];
       } else {
           [huddle fetchIfNeeded];
           
           SHIndividualHuddleViewController *huddleVC = [[SHIndividualHuddleViewController alloc]initWithHuddle:huddle];
           
           [self.navigationController pushViewController:huddleVC animated:YES];
       }
   }
    
    
}

#pragma mark - Request Cell Deleagte methods

- (void)didTapAccept:(PFObject *)request
{
    NSString *type = request[SHRequestTypeKey];
    
    if([type isEqualToString:SHRequestSSInviteStudy])
    {
        //TO STUDENT accepted From Student's request to study
        
        PFUser *fromStudent = request[SHRequestFromStudentKey];
        [fromStudent fetchIfNeeded];
        
        PFObject *notification = [PFObject objectWithClassName:SHNotificationParseClass];
        notification[SHNotificationToStudentKey] = [PFUser currentUser];
        notification[SHNotificationFromStudentKey] = fromStudent;
        notification[SHNotificationTitleKey] = fromStudent[SHStudentNameKey];
        notification[SHNotificationTypeKey] = SHNotificationSSStudyRequestType;
        notification[SHNotificationRequestAcceptedKey] = [NSNumber numberWithBool:TRUE];
        notification[SHNotificationDescriptionKey] = SHSSAcceptedStudyInviteRequestTitle;
        
        [notification saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSString* channel = [NSString stringWithFormat:@"a%@",[fromStudent objectId]];
            NSString* message = [NSString stringWithFormat:@"%@ accepted your request!!!!!1",[PFUser currentUser][SHStudentNameKey]];
            NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                  message, @"alert",
                                  @"Increment", @"badge",
                                  notification,@"notification",
                                  nil];
            
            PFPush *push = [[PFPush alloc] init];
            [push setChannels:[NSArray arrayWithObjects:channel, nil]];
            [push setData:data];
            [push sendPushInBackground];
        }];
        
  
        
        
    
    } else if([type isEqualToString:SHRequestSHJoin])
    {
        //Huddle Creator accepted Student1's request to join Huddle
        PFObject *huddle = request[SHRequestHuddleKey];
        [huddle fetch];
        
        PFUser *fromStudent = request[SHRequestFromStudentKey];
        [fromStudent fetch];
        
        PFObject *notification = [PFObject objectWithClassName:SHNotificationParseClass];
        notification[SHNotificationToStudentKey] = fromStudent;
        notification[SHNotificationTitleKey] = huddle[SHHuddleNameKey];
        notification[SHNotificationHuddleKey] = huddle;
        notification[SHNotificationTypeKey] = SHNotificationSHJoinRequestType;
        notification[SHNotificationRequestAcceptedKey] = [NSNumber numberWithBool:TRUE];
        notification[SHNotificationDescriptionKey] = SHSHAcceptedJoinRequestTitle;
        
        [notification saveInBackground];
        
        for(PFUser *member in [[SHCache sharedCache]membersForHuddle:huddle])
        {
            if([member isEqual:huddle[SHHuddleCreatorKey]])
                continue;
            
            PFObject *memberNotification = [PFObject objectWithClassName:SHNotificationParseClass];
            
            [member fetchIfNeeded];
            memberNotification[SHNotificationToStudentKey] = member;
            memberNotification[SHNotificationFromStudentKey] = fromStudent;
            memberNotification[SHNotificationHuddleKey] = huddle;
            memberNotification[SHNotificationTitleKey] = huddle[SHHuddleNameKey];
            memberNotification[SHNotificationTypeKey] = SHNotificationNewHuddleMemberType;
            
            NSString *description = [NSString stringWithFormat:@"%@ added to huddle", fromStudent[SHStudentNameKey]];
            memberNotification[SHNotificationDescriptionKey] = description;
            
            [memberNotification saveInBackground];
        }
      
        
    } else if([type isEqualToString:SHRequestHSJoin])
    {
        //Student1 (Current User) accepted Huddle's request to join
        
        PFObject *huddle = request[SHRequestHuddleKey];
        [huddle fetch];
        
        PFUser *student1 = [PFUser currentUser];
        [student1 addObject:huddle forKey:SHStudentHuddlesKey];
        [huddle removeObject:student1 forKey:SHHuddlePendingMembersKey];
        
        [[SHCache sharedCache] setJoinedHuddle:huddle];
        
        [PFObject saveAll:@[student1, huddle]]; //This isn't saving fucking shit
        
        for(PFUser *member in [[SHCache sharedCache]membersForHuddle:huddle])
        {
            PFObject *memberNotification = [PFObject objectWithClassName:SHNotificationParseClass];
            
            [member fetchIfNeeded];
            memberNotification[SHNotificationToStudentKey] = member;
            memberNotification[SHNotificationFromStudentKey] = student1;
            memberNotification[SHNotificationTitleKey] = huddle[SHHuddleNameKey];
            memberNotification[SHNotificationTypeKey] = SHNotificationNewHuddleMemberType;
            memberNotification[SHNotificationRequestAcceptedKey] = [NSNumber numberWithBool:TRUE];
            
            NSString *description = [NSString stringWithFormat:@"%@ added to huddle", student1[SHStudentNameKey]];
            memberNotification[SHNotificationDescriptionKey] = description;
            
            [memberNotification saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if([member[SHSettingReceiveNewHuddleMemberNotifications] boolValue])
                {
                    NSString* channel = [NSString stringWithFormat:@"a%@",[member objectId]];
                    NSString* message = [NSString stringWithFormat:@"%@ has joined %@",student1[SHStudentNameKey],huddle[SHHuddleNameKey]];
                    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                          message, @"alert",
                                          @"Increment", @"badge",
                                          memberNotification,@"notification",
                                          nil];
                    
                    PFPush *push = [[PFPush alloc] init];
                    [push setChannels:[NSArray arrayWithObjects:channel, nil]];
                    [push setData:data];
                    [push sendPushInBackground];
                }
            }];
            
        }
        
    }
    
    [[SHCache sharedCache] removeRequest:request];
    
    [self.requestsDataArray removeObject:request];
    [request deleteInBackground];
    
    self.currentRowsToDisplay--;
    [self.control setCount:[NSNumber numberWithInteger:self.currentRowsToDisplay] forSegmentAtIndex:1];
    [self.tableView reloadData];
}


- (void)didTapDeny:(PFObject *)request
{
    NSString *type = request[SHRequestTypeKey];
    
    if([type isEqualToString:SHRequestSSInviteStudy])
    {
        //Student 2 denied Student 1's request to study
        
        PFUser *currentUser = [PFUser currentUser];
        [currentUser fetchIfNeeded];
        
        PFObject *notification = [PFObject objectWithClassName:SHNotificationParseClass];
        notification[SHNotificationToStudentKey] = request[SHRequestFromStudentKey];
        notification[SHNotificationFromStudentKey] = currentUser;
        notification[SHNotificationTitleKey] = currentUser[SHStudentNameKey];
        notification[SHNotificationTypeKey] = SHNotificationSSStudyRequestType;
        notification[SHNotificationRequestAcceptedKey] = [NSNumber numberWithBool:FALSE];
        notification[SHNotificationDescriptionKey] = SHSSDeniedStudyInviteRequestTitle;
        
        [notification saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSString* channel = [NSString stringWithFormat:@"a%@",[request[SHRequestFromStudentKey] objectId]];
            NSString* message = [NSString stringWithFormat:@"%@ is busy and cannot attend your request",[PFUser currentUser][SHStudentNameKey]];
            NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                  message, @"alert",
                                  @"Increment", @"badge",
                                  notification,@"notification",
                                  nil];
            
            PFPush *push = [[PFPush alloc] init];
            [push setChannels:[NSArray arrayWithObjects:channel, nil]];
            [push setData:data];
            [push sendPushInBackground];
        }];
        
        
    } else if([type isEqualToString:SHRequestSHJoin])
    {
        //Huddle Creator denied Student1's request to join Huddle
        
        PFObject *huddle = request[SHRequestHuddleKey];
        [huddle fetchIfNeeded];
        
        PFUser *currentUser = [PFUser currentUser];
        [currentUser fetchIfNeeded];
        
        PFObject *notification = [PFObject objectWithClassName:SHNotificationParseClass];
        notification[SHNotificationToStudentKey] = currentUser;
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
        
        PFUser *creator = huddle[SHHuddleCreatorKey];
        [creator fetchIfNeeded];
        
        PFUser *currentUser = [PFUser currentUser];
        [currentUser fetchIfNeeded];
        
        [huddle removeObject:currentUser forKey:SHHuddlePendingMembersKey];
        [huddle saveInBackground];
        
        PFObject *notification = [PFObject objectWithClassName:SHNotificationParseClass];
        notification[SHNotificationToStudentKey] = creator;
        notification[SHNotificationFromStudentKey] = currentUser;
        notification[SHNotificationTitleKey] = huddle[SHHuddleNameKey];
        notification[SHNotificationTypeKey] = SHNotificationHSJoinRequestType;
        notification[SHNotificationRequestAcceptedKey] = [NSNumber numberWithBool:FALSE];
        
        NSString *description = [NSString stringWithFormat:@"%@ denied request to join huddle", currentUser[SHStudentNameKey]];
        notification[SHNotificationDescriptionKey] = description;
        
        [notification saveInBackground];
        
        if(request[SHRequestFromStudentKey]){
            PFObject *notification = [PFObject objectWithClassName:SHNotificationParseClass];
            notification[SHNotificationToStudentKey] = request[SHRequestFromStudentKey];
            notification[SHNotificationFromStudentKey] = currentUser;
            notification[SHNotificationTitleKey] = huddle[SHHuddleNameKey];
            notification[SHNotificationTypeKey] = SHNotificationHSJoinRequestType;
            notification[SHNotificationRequestAcceptedKey] = [NSNumber numberWithBool:FALSE];
            
            NSString *description = [NSString stringWithFormat:@"%@ denied request to join huddle", currentUser[SHStudentNameKey]];
            notification[SHNotificationDescriptionKey] = description;
            
            [notification saveInBackground];
        }
        
    }
    
    [[SHCache sharedCache]removeRequest:request];
    
    [self.requestsDataArray removeObject:request];
    [request deleteInBackground];
    
    self.currentRowsToDisplay--;
    [self.control setCount:[NSNumber numberWithInteger:self.currentRowsToDisplay] forSegmentAtIndex:1];
    [self.tableView reloadData];
}

#pragma mark - Helpers

//Also adds the member to the huddle if is off type SHNotificationSHJoinRequestType
- (void)findExpandableNotificaitonTypes
{
    int i = 0;
    for(PFObject *notification in self.notificationsDataArray)
    {
        [notification fetchIfNeeded];
        if([notification[SHNotificationTypeKey] isEqualToString:SHNotificationHSStudyRequestType] || [notification[SHNotificationTypeKey] isEqualToString:SHNotificationAnswerType])
            [self.expandableNotificationCells addIndex:i];
        
        if([notification[SHNotificationTypeKey] isEqualToString:SHNotificationSHJoinRequestType] && [notification[SHNotificationRequestAcceptedKey] boolValue] == true){
            PFObject *newHuddle = notification[SHNotificationHuddleKey];
            [newHuddle fetchIfNeeded];
            
            [[PFUser currentUser] addObject:newHuddle forKey:SHStudentHuddlesKey];
            [[PFUser currentUser] saveInBackground];
        }
        i++;
    }
}





@end

