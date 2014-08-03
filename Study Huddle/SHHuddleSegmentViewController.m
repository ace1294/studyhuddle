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
#import "SHConstants.h"
#import "Student.h"
#import "SHStudentCell.h"
#import "SHStudyCell.h"
#import "SHChatCell.h"
#import "SHResourceCell.h"
#import "SHVisitorProfileViewController.h"
#import "SHProfileViewController.h"
#import "SHIndividualHuddleViewController.h"
#import "SHUtility.h"
#import "SHStudentSearchViewController.h"
#import "SHCategoryCell.h"
#import "SHNewResourceViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "SHChatEntryViewController.h"
#import "SHResourceListViewController.h"
#import "SHHuddleJoinRequestViewController.h"
#import "SHCache.h"
#import "RoomView.h"


@interface SHHuddleSegmentViewController () <SHBaseCellDelegate, UINavigationControllerDelegate, SHStudentSearchDelegate>

@property (strong, nonatomic) NSString *docsPath;

@property (strong, nonatomic) PFObject *segHuddle;

@property (strong, nonatomic) NSString *CellIdentifier;
@property (nonatomic, assign) NSInteger currentRowsToDisplay;
@property (nonatomic, strong) NSMutableDictionary *segCellIdentifiers;

@property (strong, nonatomic) NSArray *segMenu;

@property (strong, nonatomic) NSMutableDictionary *segmentData;
@property (strong, nonatomic) NSMutableArray *membersDataArray;

@property (strong, nonatomic) NSMutableArray *chatCategoriesDataArray;

@property (strong, nonatomic) NSMutableArray *threadDataArray;
@property (strong, nonatomic) NSMutableArray *resourceCategoriesDataArray;

@property (strong, nonatomic) NSMutableArray *encapsulatingDataArray;

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property int initialSection;

@property (strong, nonatomic) SHStudentSearchViewController *searchVC;
@property (strong, nonatomic) SHNewResourceViewController *addResourceVC;

@end


@implementation SHHuddleSegmentViewController

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
    self.chatCategoriesDataArray = [[NSMutableArray alloc]init];
    self.resourceCategoriesDataArray = [[NSMutableArray alloc]init];
    self.encapsulatingDataArray = [[NSMutableArray alloc]initWithObjects:self.membersDataArray, self.resourceCategoriesDataArray, self.chatCategoriesDataArray, nil];
    

    [self loadHuddleDataRefresh:false];
        
    
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
    [self.segCellIdentifiers setObject:SHChatCellIdentifier forKey:[@"Chat" uppercaseString]];
    [self.segCellIdentifiers setObject:SHCategoryCellIdentifier forKey:[@"Resources" uppercaseString]];
    
    //Segment
    [self.view addSubview:self.control];
    
    [self.tableView registerClass:[SHStudentCell class] forCellReuseIdentifier:SHStudentCellIdentifier];
    [self.tableView registerClass:[SHCategoryCell class] forCellReuseIdentifier:SHCategoryCellIdentifier];
    [self.tableView registerClass:[SHChatCell class] forCellReuseIdentifier:SHChatCellIdentifier];
    
    
}

- (void)refreshTable {
    //TODO: refresh your data
    [refreshControl endRefreshing];
    [self loadHuddleDataRefresh:true];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)setHuddle:(PFObject *)aHuddle
{
    _segHuddle = aHuddle;
    [self loadHuddleDataRefresh:true];
}

-(BOOL)loadHuddleDataRefresh:(BOOL)refresh
{
    BOOL loadError = true;
    
    [self.segHuddle fetch];
    
    [self.resourceCategoriesDataArray removeAllObjects];
    [self.resourceCategoriesDataArray addObjectsFromArray:[[SHCache sharedCache] resourceCategoriesForHuddle:self.segHuddle]];
    
    [self.membersDataArray removeAllObjects];
    [self.membersDataArray addObjectsFromArray:[[SHCache sharedCache] membersForHuddle:self.segHuddle]];
    
    [self.chatCategoriesDataArray removeAllObjects];
    [self.chatCategoriesDataArray addObjectsFromArray:[[SHCache sharedCache] chatCategoriessForHuddle:self.segHuddle]];
    
    [self.tableView reloadData];

    switch (self.initialSection) {
        case 0:
            self.currentRowsToDisplay = self.membersDataArray.count;
            break;
        case 1:
            self.currentRowsToDisplay = self.resourceCategoriesDataArray.count;
            break;
        case 2:
            self.currentRowsToDisplay = self.chatCategoriesDataArray.count;
            break;
        default:
            break;
    }

    
    return loadError;
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
    return self.currentRowsToDisplay;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellIdentifier = [self.segCellIdentifiers objectForKey:[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex]];

    if([CellIdentifier isEqual:SHStudentCellIdentifier])
    {
        PFObject *studentObject = [self.membersDataArray objectAtIndex:(int)indexPath.row];
        SHStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.delegate = self;
        
        [cell setStudent:studentObject];
        [cell layoutIfNeeded];
        
        return cell;
    }
    else if([CellIdentifier isEqual:SHCategoryCellIdentifier])
    {
        PFObject *categoryObject = [self.resourceCategoriesDataArray objectAtIndex:(int)indexPath.row];
        SHCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.delegate = self;
        
        [cell setCategory:categoryObject];
        [cell layoutIfNeeded];
        
        return cell;
    }
    else if([CellIdentifier isEqual:SHChatCellIdentifier])
    {
        PFObject *chatEntryObj = [self.chatCategoriesDataArray objectAtIndex:(int)indexPath.row];
        SHChatCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.delegate = self;
        
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
            
            [self.navigationController pushViewController:profileVC animated:YES];
        }
        else{
            SHVisitorProfileViewController *visitorVC = [[SHVisitorProfileViewController alloc]initWithStudent:(Student *)studentCell.student];
            
            [self.navigationController pushViewController:visitorVC animated:YES];
        }


    }
    else if([cell isKindOfClass:[SHChatCell class]])
    {
        /*PFObject* chatEntryObj = [(SHChatCell*)cell getChatEntryObj];
        NSLog(@"chatEntryObj: , %@",chatEntryObj);
        SHChatEntryViewController* chatEntryVC = [[SHChatEntryViewController alloc]initWithChatEntry:chatEntryObj];
        [self.navigationController pushViewController:chatEntryVC animated:YES];*/
        RoomView *roomView = [[RoomView alloc] init];
        roomView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:roomView animated:YES];
        

        
    }
    if ([cell isKindOfClass:[SHCategoryCell class]] ) {
        
        
        SHCategoryCell *categoryCell = (SHCategoryCell *)cell;
        
        SHResourceListViewController *resourceListVC = [[SHResourceListViewController alloc] initWithResourceCategory:categoryCell.category];
        
        
        [self.navigationController pushViewController:resourceListVC animated:YES];
        

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
    SHHuddleJoinRequestViewController *joinRequestVC = [[SHHuddleJoinRequestViewController alloc]initWithHuddle:self.segHuddle withType:SHRequestHSJoin];
    
    [self presentPopupViewController:joinRequestVC animationType:MJPopupViewAnimationSlideBottomBottom];
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
