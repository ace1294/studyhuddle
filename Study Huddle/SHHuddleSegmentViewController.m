//
//  SHHuddleSegmentViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/24/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHHuddleSegmentViewController.h"
#import "UIColor+HuddleColors.h"
#import "SHClassCell.h"
#import "SHRequestCell.h"
#import "SHAddCell.h"
#import "SHConstants.h"
#import "Student.h"
#import "SHStudentCell.h"
#import "SHStudyCell.h"
#import "SHChatCell.h"
#import "SHResourceCell.h"
#import "SHVisitorProfileViewController.h"
#import "SHProfileViewController.h"
#import "SHIndividualHuddleviewController.h"
#import "SHUtility.h"
#import "SHStudentSearchViewController.h"
#import "SHCategoryCell.h"
#import "SHNewResourceViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "SHChatEntryViewController.h"
#import "SHResourceListViewController.h"



@interface SHHuddleSegmentViewController () <SHBaseCellDelegate, SHAddCellDelegate, UINavigationControllerDelegate, SHStudentSearchDelegate>

@property (strong, nonatomic) NSString *docsPath;

@property (strong, nonatomic) PFObject *segHuddle;

@property (strong, nonatomic) NSString *CellIdentifier;
@property (nonatomic, assign) NSInteger currentRowsToDisplay;
@property (nonatomic, strong) NSMutableDictionary *segCellIdentifiers;

@property (strong, nonatomic) NSArray *segMenu;

@property (strong, nonatomic) NSMutableDictionary *segmentData;
@property (strong, nonatomic) NSMutableArray *membersDataArray;

@property (strong, nonatomic) NSMutableArray *chatEntryDataArray;

@property (strong, nonatomic) NSMutableArray *threadDataArray;
@property (strong, nonatomic) NSMutableArray *resourceCategoriesDataArray;

@property (strong, nonatomic) NSMutableArray *encapsulatingDataArray;

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property int initialSection;

@property (strong, nonatomic) SHStudentSearchViewController *searchVC;
@property (strong, nonatomic) SHNewResourceViewController *addResourceVC;

@end


@implementation SHHuddleSegmentViewController

static NSString* const MembersDiskKey = @"membersArray";
static NSString* const ResourcesDiskKey = @"resourcesKey";

@synthesize CellIdentifier;
@synthesize refreshControl;

-(id)initWithHuddle:(PFObject *)aHuddle
{
    self = [super init];
    if(self)
    {
        _segHuddle = aHuddle;
        self.initialSection = 1;
        CellIdentifier = [[NSString alloc]init];
        
        self.segCellIdentifiers = [[NSMutableDictionary alloc]init];
        
        self.segmentData = [[NSMutableDictionary alloc]init];
        
        self.segMenu = [[NSArray alloc]initWithObjects:@"MEMBERS", @"RESOURCES", @"CHAT", nil];
        
        self.docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        self.docsPath = [self.docsPath stringByAppendingPathComponent:@"huddleSegment"];
        

        
    }
    return self;
}

-(id)initWithHuddle:(PFObject *)aHuddle andInitialSection:(int)section
{
    self = [self initWithHuddle:aHuddle];
    self.initialSection = section;
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
    
    self.membersDataArray = [[NSMutableArray alloc]init];
    self.chatEntryDataArray = [[NSMutableArray alloc]init];
    self.resourceCategoriesDataArray = [[NSMutableArray alloc]init];
    self.encapsulatingDataArray = [[NSMutableArray alloc]initWithObjects:self.membersDataArray, self.resourceCategoriesDataArray, self.chatEntryDataArray, nil];
    

    [self loadHuddleData];
        
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    //Tableview
    CGRect tableViewFrame = CGRectMake(tableViewX, tableViewY, tableViewDimX, tableViewDimY);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.tableView];
    
    //Set segment menu titles
    [self.segCellIdentifiers setObject:SHStudentCellIdentifier forKey:[@"Members" uppercaseString]];
    [self.segCellIdentifiers setObject:SHChatCellIdentifier forKey:[@"Chat" uppercaseString]];  //$$$$$$$$$$$$$$$$$$$$$$$
    [self.segCellIdentifiers setObject:SHCategoryCellIdentifier forKey:[@"Resources" uppercaseString]];  //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ // NEED TO REGISTER CELLS AS WELL
    
    //Segment
    [self.view addSubview:self.control];
    
    [self.tableView registerClass:[SHStudentCell class] forCellReuseIdentifier:SHStudentCellIdentifier];
    [self.tableView registerClass:[SHAddCell class] forCellReuseIdentifier:SHAddCellIdentifier];
    [self.tableView registerClass:[SHCategoryCell class] forCellReuseIdentifier:SHCategoryCellIdentifier];
    [self.tableView registerClass:[SHChatCell class] forCellReuseIdentifier:SHChatCellIdentifier];
    
    
}

- (void)refreshTable {
    //TODO: refresh your data
    [refreshControl endRefreshing];
    [self loadHuddleData];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    
//    if(self.segHuddle[SHHuddleNameKey]){
//        
//        if([[NSFileManager defaultManager] fileExistsAtPath:self.docsPath])
//        {
//            [self loadDataFromDisk];
//            return;
//        }
//        [self loadHuddleData];
//    }
    
}

- (void)setHuddle:(PFObject *)aHuddle
{
    _segHuddle = aHuddle;
    [self loadHuddleData];
}

-(BOOL)loadHuddleData
{
    BOOL loadError = true;
    
    [self.segHuddle fetch];
    
    NSArray *resourceCategories = [self.segHuddle objectForKey:SHHuddleResourceCategoriesKey];
    
    [self.resourceCategoriesDataArray removeAllObjects];
    [self.resourceCategoriesDataArray addObjectsFromArray:resourceCategories];
    [SHUtility fetchObjectsInArray:self.resourceCategoriesDataArray];
    
    NSArray *members = [self.segHuddle objectForKey:SHHuddleMembersKey];
    
    [self.membersDataArray removeAllObjects];
    [self.membersDataArray addObjectsFromArray:members];
    [SHUtility fetchObjectsInArray:self.membersDataArray];
    
    
    NSArray *chatEntries = [self.segHuddle objectForKey:SHHuddleChatCategoriesKey];
    
    [self.chatEntryDataArray removeAllObjects];
    [self.chatEntryDataArray addObjectsFromArray:chatEntries];
    
    
    
    [self.tableView reloadData];
    
    //[self saveDataToDisk];

    switch (self.initialSection) {
        case 0:
            self.currentRowsToDisplay = self.membersDataArray.count;
            break;
        case 1:
            self.currentRowsToDisplay = self.resourceCategoriesDataArray.count;
            break;
        case 2:
            self.currentRowsToDisplay = self.chatEntryDataArray.count;
            break;
        default:
            break;
    }

    
    return loadError;
}




- (void)saveDataToDisk
{
    
    NSLog(@"SAVING TO DISK");
    
    [self.segmentData setObject:self.membersDataArray forKey:MembersDiskKey];
    [self.segmentData setObject:self.resourceCategoriesDataArray forKey:ResourcesDiskKey];
    //[self.segmentData setObject:self.chatDataArray forKey:ChatDiskKey];
    
    [NSKeyedArchiver archiveRootObject:self.segmentData toFile:self.docsPath];
    
}

- (void)loadDataFromDisk
{
    NSLog(@"LOADING FROM DISK");
    
    self.segmentData = [NSKeyedUnarchiver unarchiveObjectWithFile:self.docsPath];
    
    self.membersDataArray = [self.segmentData objectForKey:MembersDiskKey];
    self.resourceCategoriesDataArray = [self.segmentData objectForKey:ResourcesDiskKey];
}



#pragma mark - DZNSegmentController

- (DZNSegmentedControl *)control
{
    
    if (!_control)
    {
        _control = [[DZNSegmentedControl alloc] initWithItems:self.segMenu];
        _control.delegate = self;
        _control.selectedSegmentIndex = self.initialSection;
        _control.inverseTitles = NO;
        _control.tintColor = [UIColor huddleOrange];
        _control.hairlineColor = [UIColor grayColor];
        //        _control.hairlineColor = self.view.tintColor;
        _control.showsCount = NO;
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
    if([[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] isEqual:@"MEMBERS"])
        return SHHuddleCellHeight;
    else if([[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] isEqual:@"RESOURCES"])
        return SHCategoryCellHeight;
    else if([[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] isEqual:@"CHAT"])
        return SHChatCellHeight;
    else
        return SHHuddleCellHeight;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger addCell = 0;

    if([SHUtility studentInArray:self.membersDataArray student:[Student currentUser]]){
        if([[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] isEqual:@"MEMBERS"] || [[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] isEqual:@"RESOURCES"]){
            addCell = 1;
            NSLog(@"added cell");
        }
        
    }
    
    
    return self.currentRowsToDisplay + addCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellIdentifier = [self.segCellIdentifiers objectForKey:[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex]];

    
    if (indexPath.row == self.currentRowsToDisplay && ([CellIdentifier isEqual:SHStudentCellIdentifier] || [CellIdentifier isEqual:SHCategoryCellIdentifier]))
    {
        SHAddCell *cell = [tableView dequeueReusableCellWithIdentifier:SHAddCellIdentifier];
        cell.delegate = self;
        if ([CellIdentifier isEqual:SHStudentCellIdentifier])
            [cell setAdd:@"Add Member" identifier:SHStudentCellIdentifier];
        else if([CellIdentifier isEqual:SHCategoryCellIdentifier])
            [cell setAdd:@"Add Resource" identifier:SHCategoryCellIdentifier];
            
            
        [cell layoutIfNeeded];
        NSLog(@"baby got kush");
        return cell;
    
    }
    else if([CellIdentifier isEqual:SHStudentCellIdentifier])
    {
        PFObject *studentObject = [self.membersDataArray objectAtIndex:(int)indexPath.row];
        SHStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.delegate = self;
        
        [studentObject fetch];
        
        [cell setStudent:studentObject];
        
        [cell layoutIfNeeded];
        
        return cell;
    }
    else if([CellIdentifier isEqual:SHCategoryCellIdentifier])
    {
        PFObject *categoryObject = [self.resourceCategoriesDataArray objectAtIndex:(int)indexPath.row];

        SHCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell.delegate = self;
        
        [categoryObject fetch];
        
        [cell setCategory:categoryObject];
        
        [cell layoutIfNeeded];
        
        return cell;
    }
    else if([CellIdentifier isEqual:SHChatCellIdentifier])
    {
        PFObject *chatEntryObj = [self.chatEntryDataArray objectAtIndex:(int)indexPath.row];
        SHChatCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.delegate = self;
        
        [chatEntryObj fetch];
        
        [cell setChatEntry:chatEntryObj];
        
        [cell layoutIfNeeded];
        
        return cell;
    }
    
    
    
    
    
    return nil;
    
}

- (void)didTapTitleCell:(SHBaseTextCell *)cell
{
    if ([cell isKindOfClass:[SHStudentCell class]] ) {
        SHStudentCell *studentCell = (SHStudentCell *)cell;
        
        if([studentCell.student isEqual:[Student currentUser]])
        {
            SHProfileViewController *profileVC = [[SHProfileViewController alloc]initWithStudent:(Student *)studentCell.student];
            
            [self.owner.navigationController pushViewController:profileVC animated:YES];
        }
        else{
            SHVisitorProfileViewController *visitorVC = [[SHVisitorProfileViewController alloc]initWithStudent:(Student *)studentCell.student];
            
            [self.owner.navigationController pushViewController:visitorVC animated:YES];
        }


    }
    else if([cell isKindOfClass:[SHChatCell class]])
    {
        PFObject* chatEntryObj = [(SHChatCell*)cell getChatEntryObj];
        NSLog(@"chatEntryObj: , %@",chatEntryObj);
        SHChatEntryViewController* chatEntryVC = [[SHChatEntryViewController alloc]initWithChatEntry:chatEntryObj];
        [self.owner.navigationController pushViewController:chatEntryVC animated:YES];

        
    }
    if ([cell isKindOfClass:[SHCategoryCell class]] ) {
        
        
        SHCategoryCell *categoryCell = (SHCategoryCell *)cell;
        
        SHResourceListViewController *resourceListVC = [[SHResourceListViewController alloc] initWithResourceCategory:categoryCell.category];
        
        
        [self.owner.navigationController pushViewController:resourceListVC animated:YES];
        

    }
    
}

-(void)didTapAddButton:(SHAddCell *)cell
{
    
    if ([cell.typeIdentifier isEqual:SHStudentCellIdentifier] ) {
        
        self.searchVC = [[SHStudentSearchViewController alloc]init];
        self.searchVC.navigationController.delegate = self;
        self.searchVC.type = @"NewMember";
        self.searchVC.delegate = self;
        [self.owner presentViewController:self.searchVC animated:YES completion:nil];
        
    }
    
    else if ([cell.typeIdentifier isEqual:SHCategoryCellIdentifier] ) {
        
        
        self.addResourceVC = [[SHNewResourceViewController alloc] initWithHuddle:self.segHuddle];
        self.addResourceVC.owner = self;
        self.addResourceVC.delegate = self;
        
        [self presentPopupViewController:self.addResourceVC animationType:MJPopupViewAnimationSlideBottomBottom];

    }
    
}

#pragma mark - Popup delegate methods

- (void)cancelTapped
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
}




#pragma mark - SHStudentSearchDelgate

- (void)didAddMember:(PFObject *)member
{  
    PFObject *request = [PFObject objectWithClassName:SHRequestParseClass];
    request[SHRequestTitleKey] = self.segHuddle[SHHuddleNameKey];
    request[SHRequestHuddleKey] = self.segHuddle;
    
    if([[[Student currentUser] objectId] isEqual:[self.segHuddle[SHHuddleCreatorKey] objectId]]){
        request[SHRequestTypeKey] = SHRequestHSJoin;
        request[SHRequestStudent1Key] = member;
        request[SHRequestDescriptionKey] = @"We want you to join our huddle";
        
    } else {
        //Send creator request to
        request[SHRequestTypeKey] = SHRequestSCJoin;
        request[SHRequestStudent1Key] = self.segHuddle[SHHuddleCreatorKey];
        request[SHRequestStudent2Key] = member;
        request[SHRequestStudent3Key] = [Student currentUser];
        request[SHRequestDescriptionKey] = [NSString stringWithFormat:@"%@ requested to add %@", [Student currentUser][SHStudentNameKey], member[SHStudentNameKey]];
        
    }
    
    [request saveInBackground];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<0) {
        [self.parentScrollView setScrollEnabled:YES];
    }
    
}

-(float)getOccupatingHeight
{
    //check if its in study, classes or online
    float cellHeight = 0;
    float add = 0;
    switch (self.control.selectedSegmentIndex)
    {
        case 0:
            cellHeight = SHStudentCellHeight;
            add = 1;
            break;
        case 1:
            cellHeight = SHCategoryCellHeight;
            add = 1;
            break;
        case 2:
            cellHeight = SHChatCellHeight;
            add = 0;
            break;
        default:
            break;
    }
    
    return cellHeight*(self.currentRowsToDisplay+add);
    
}




@end
