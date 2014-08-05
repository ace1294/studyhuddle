//
//  SHChatEntrySegmentViewController.h
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/30/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHChatEntrySegmentViewController.h"

#import "SHProfileSegmentViewController.h"
#import "UIColor+HuddleColors.h"
#import "SHNotificationCell.h"
#import "SHThreadCell.h"
#import "SHClassCell.h"
#import "SHRequestCell.h"
#import "SHConstants.h"
#import "Student.h"
#import "SHStudentCell.h"
#import "SHNewHuddleViewController.h"
#import "SHStudyCell.h"
#import "PFACL+NSCoding.h"
#import "PFFile+NSCoding.h"
#import "PFObject+NSCoding.h"
#import "SHProfileViewController.h"
#import "SHIndividualHuddleviewController.h"
#import "SHVisitorProfileViewController.h"
#import "SHClassPageViewController.h"
#import "SHIndividualHuddleviewController.h"
#import "SHThreadViewController.h"

@interface SHChatEntrySegmentViewController () <SHBaseCellDelegate>

@property (strong, nonatomic) NSString *docsPath;
@property (strong, nonatomic) PFObject *segChatEntry;

@property (strong, nonatomic) NSString *CellIdentifier;
@property (nonatomic, assign) NSInteger currentRowsToDisplay;
@property (nonatomic, strong) NSMutableDictionary *segCellIdentifiers;

@property (strong, nonatomic) NSArray *segMenu;

@property (strong, nonatomic) NSMutableDictionary *segmentData;

@property (strong, nonatomic) NSMutableArray *chatEntryDataArray;


@property (strong, nonatomic) NSMutableArray *encapsulatingDataArray;

@end

@implementation SHChatEntrySegmentViewController

@synthesize CellIdentifier;




- (id)initWithChatEntry:(PFObject *)aChatEntry
{
    self = [super init];
    if(self)
    {
        _segChatEntry = aChatEntry;
        
        CellIdentifier = [[NSString alloc]init];
        
        self.segCellIdentifiers = [[NSMutableDictionary alloc]init];
        
        self.segmentData = [[NSMutableDictionary alloc]init];
        
        self.segMenu = [[NSArray alloc]initWithObjects:@"QUESTIONS",nil];
        
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
    
    self.chatEntryDataArray = [[NSMutableArray alloc]init];
        self.encapsulatingDataArray = [[NSMutableArray alloc]initWithObjects:self.chatEntryDataArray,nil];
    
    
    [self loadChatEntryData];
    
    
    
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
    [self.segCellIdentifiers setObject:SHThreadCellIdentifier forKey:[@"questions" uppercaseString]];
   
    
    
    //Segment
    [self.view addSubview:self.control];
    
    [self.tableView registerClass:[SHThreadCell class] forCellReuseIdentifier:SHThreadCellIdentifier];

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadChatEntryData];
    
    self.currentRowsToDisplay = [[self.encapsulatingDataArray objectAtIndex:self.control.selectedSegmentIndex]count];
    [self.tableView reloadData];
}

- (void)setChatEntry:(PFObject *)aChatEntry
{
    _segChatEntry = aChatEntry;
    [self loadChatEntryData];
}

- (BOOL)loadChatEntryData
{
    BOOL loadError = true;
    
      //ChatEntry Data
    NSArray *threads = [self.segChatEntry objectForKey:SHChatCategoryChatRoomKey];
   
    
    
    
    //sort them based on date created
    NSArray *sortedArray;
    sortedArray = [threads sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        [a fetchIfNeeded];
        [b fetchIfNeeded];
        
        
        PFObject* firstThread = (PFObject*)a;
        
        NSDate* first = [firstThread createdAt];
        
        
        PFObject* secondThread = (PFObject*)b;
        NSDate* second = [secondThread createdAt];
        
        
        
        return [second compare:first];
        
    }];
    
    [self.chatEntryDataArray removeAllObjects];
    [self.chatEntryDataArray addObjectsFromArray:sortedArray];
    
    
    
    [self.control setCount:[NSNumber numberWithInt:self.chatEntryDataArray.count] forSegmentAtIndex:0];
    
    
    
    [self.tableView reloadData];
    
    //[self saveDataToDisk];
    
    return loadError;
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
    
    //    if([[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] isEqual:@"HUDDLES"])
    return cellHeight;
    //    else
    //        return SHClassCellHeight;
    
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
    NSLog(@"selected segment index: %d",self.control.selectedSegmentIndex);
    
    if([CellIdentifier isEqual:SHThreadCellIdentifier])
    {
        
        
        PFObject* threadObject = [self.chatEntryDataArray objectAtIndex:(int)indexPath.row];
        SHThreadCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        [threadObject fetchIfNeeded];
        
        cell.delegate = self;
        
        [cell setThread:threadObject];
        [cell layoutIfNeeded];
        
        
        return cell;
    }

    
    
    return nil;
}




- (void)didTapTitleCell:(SHBaseTextCell *)cell
{
    SHThreadCell *threadCell = (SHThreadCell*)cell;
    SHThreadViewController* thread = [[SHThreadViewController alloc]initWithThread:[threadCell getThread]];
    thread.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:thread animated:YES];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<0) {
        [self.parentScrollView setScrollEnabled:YES];
    }
    
}



@end

