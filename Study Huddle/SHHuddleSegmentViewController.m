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
#import "SHResourceCell.h"
#import "SHVisitorProfileViewController.h"
#import "SHProfileViewController.h"
#import "SHIndividualHuddleviewController.h"
#import "SHUtility.h"
#import "SHStudentSearchViewController.h"
#import "SHCategoryCell.h"
#import "SHNewResourceViewController.h"
#import "UIViewController+MJPopupViewController.h"


@interface SHHuddleSegmentViewController () <SHBaseCellDelegate, SHAddCellDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSString *docsPath;

@property (strong, nonatomic) PFObject *segHuddle;

@property (strong, nonatomic) NSString *CellIdentifier;
@property (nonatomic, assign) NSInteger currentRowsToDisplay;
@property (nonatomic, strong) NSMutableDictionary *segCellIdentifiers;

@property (strong, nonatomic) NSArray *segMenu;

@property (strong, nonatomic) NSMutableDictionary *segmentData;
@property (strong, nonatomic) NSMutableArray *membersDataArray;
@property (strong, nonatomic) NSMutableArray *threadDataArray;
@property (strong, nonatomic) NSMutableArray *categoryDataArray;

@property (strong, nonatomic) NSMutableArray *encapsulatingDataArray;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (strong, nonatomic) SHStudentSearchViewController *searchVC;

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
        
        CellIdentifier = [[NSString alloc]init];
        
        self.segCellIdentifiers = [[NSMutableDictionary alloc]init];
        
        self.segmentData = [[NSMutableDictionary alloc]init];
        
        self.segMenu = [[NSArray alloc]initWithObjects:@"MEMBERS", @"RESOURCES", @"CHAT", nil];
        
        self.docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        self.docsPath = [self.docsPath stringByAppendingPathComponent:@"huddleSegment"];
        
        
        
        
    }
    return self;
}

+ (void)load
{
    [[DZNSegmentedControl appearance] setBackgroundColor:[UIColor whiteColor]];
    [[DZNSegmentedControl appearance] setTintColor:[UIColor huddleOrange]];
    [[DZNSegmentedControl appearance] setHairlineColor:[UIColor purpleColor]];
    
    [[DZNSegmentedControl appearance] setFont:segmentFont];
    [[DZNSegmentedControl appearance] setSelectionIndicatorHeight:2.5];
    [[DZNSegmentedControl appearance] setAnimationDuration:0.125];
    
}

- (void)loadView
{
    [super loadView];
    
    self.tableView.dataSource = self;
    
    self.membersDataArray = [[NSMutableArray alloc]init];
    self.categoryDataArray = [[NSMutableArray alloc]init];
    self.encapsulatingDataArray = [[NSMutableArray alloc]initWithObjects:self.membersDataArray, self.categoryDataArray,  nil];
    
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
    [self.tableView setBackgroundColor:[UIColor huddleCell]];
    [self.view addSubview:self.tableView];
    
    //Set segment menu titles
    [self.segCellIdentifiers setObject:SHStudentCellIdentifier forKey:[@"Members" uppercaseString]];
    [self.segCellIdentifiers setObject:@"UITableViewCell" forKey:[@"Chat" uppercaseString]];  //$$$$$$$$$$$$$$$$$$$$$$$
    [self.segCellIdentifiers setObject:SHCategoryCellIdentifier forKey:[@"Resources" uppercaseString]];  //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ // NEED TO REGISTER CELLS AS WELL
    
    //Segment
    [self.view addSubview:self.control];
    
    [self.tableView registerClass:[SHStudentCell class] forCellReuseIdentifier:SHStudentCellIdentifier];
    [self.tableView registerClass:[SHAddCell class] forCellReuseIdentifier:SHAddCellIdentifier];
    [self.tableView registerClass:[SHCategoryCell class] forCellReuseIdentifier:SHCategoryCellIdentifier];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    
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
    
    NSArray *resourceCategories = [self.segHuddle objectForKey:SHHuddleResourcesKey];
    
    [self.categoryDataArray removeAllObjects];
    [self.categoryDataArray addObjectsFromArray:resourceCategories];
    
    NSArray *members = [self.segHuddle objectForKey:SHHuddleMembersKey];
    
    [self.membersDataArray removeAllObjects];
    [self.membersDataArray addObjectsFromArray:members];
    
    //Chat
    
    [self.tableView reloadData];
    
    [self saveDataToDisk];
    
    return loadError;
}

- (void)saveDataToDisk
{
    
    NSLog(@"SAVING TO DISK");
    
    [self.segmentData setObject:self.membersDataArray forKey:MembersDiskKey];
    [self.segmentData setObject:self.categoryDataArray forKey:ResourcesDiskKey];
    //[self.segmentData setObject:self.chatDataArray forKey:ChatDiskKey];
    
    [NSKeyedArchiver archiveRootObject:self.segmentData toFile:self.docsPath];
    
}

- (void)loadDataFromDisk
{
    NSLog(@"LOADING FROM DISK");
    
    self.segmentData = [NSKeyedUnarchiver unarchiveObjectWithFile:self.docsPath];
    
    self.membersDataArray = [self.segmentData objectForKey:MembersDiskKey];
    self.categoryDataArray = [self.segmentData objectForKey:ResourcesDiskKey];
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
        NSString *categoryName = [self.categoryDataArray objectAtIndex:(int)indexPath.row];
        SHCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        
        [cell setCategory:categoryName withHuddle:self.segHuddle];
        
        [cell layoutIfNeeded];
        
        return cell;
    }
    else if([CellIdentifier isEqual:@"UITableViewCell"])
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell.textLabel.text = @"Chat";
        
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
}

-(void)didTapAddButton:(SHAddCell *)cell
{
    
    if ([cell.typeIdentifier isEqual:SHStudentCellIdentifier] ) {
        
        self.searchVC = [[SHStudentSearchViewController alloc]init];
        self.searchVC.navigationController.delegate = self;
        self.searchVC.type = @"NewMember";
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didDismissWithNewMember)
                                                     name:@"AddMemberDismissed"
                                                   object:nil];
        
        [self.owner presentViewController:self.searchVC animated:YES completion:nil];
        
    }
    
    else if ([cell.typeIdentifier isEqual:SHCategoryCellIdentifier] ) {
        
        
        SHNewResourceViewController *newResourceVC = [[SHNewResourceViewController alloc] initWithHuddle:self.segHuddle];
        //newResourceVC.view.frame = CGRectMake(50.0, 0.0, 280, 245 + (([self.categoryDataArray count]+1)*35.0));
        
        [self presentPopupViewController:newResourceVC animationType:MJPopupViewAnimationSlideBottomBottom];
        

    }
    
    
}

#pragma mark - UINavigationControllerDelegate

- (void)didDismissWithNewMember
{
    
    if(self.searchVC.addedMember)
    {
        [self.navigationController.navigationBar setHidden:NO];
        [self.membersDataArray addObject:self.searchVC.addedMember];
        
        [self.segHuddle addObject:self.searchVC.addedMember forKey:SHHuddleMembersKey];
        
        [self.segHuddle save];
        
        [self.tableView reloadData];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<0) {
        [self.parentScrollView setScrollEnabled:YES];
    }
    
}



@end
