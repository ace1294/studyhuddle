//
//  SHClassSegmentViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/29/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHClassSegmentViewController.h"
#import "SHConstants.h"
#import "SHUtility.h"
#import "UIColor+HuddleColors.h"
#import "SHStudentCell.h"
#import "SHHuddleCell.h"
#import "SHIndividualHuddleViewController.h"
#import "SHVisitorProfileViewController.h"

@interface SHClassSegmentViewController () <SHBaseCellDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSString *docsPath;

@property (strong, nonatomic) PFObject *segClass;

@property (strong, nonatomic) NSString *CellIdentifier;
@property (nonatomic, assign) NSInteger currentRowsToDisplay;
@property (nonatomic, strong) NSMutableDictionary *segCellIdentifiers;

@property (strong, nonatomic) NSArray *segMenu;

@property (strong, nonatomic) NSMutableDictionary *huddlesData;
@property (strong, nonatomic) NSMutableDictionary *studentData;

@property (strong, nonatomic) NSMutableArray *encapsulatingDataArray;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end


@implementation SHClassSegmentViewController


@synthesize CellIdentifier;
@synthesize refreshControl;

- (id)initWithClass:(PFObject *)aClass
{
    self = [super init];
    if (self) {
        _segClass = aClass;
        
        CellIdentifier = [[NSString alloc]init];
        
        self.segCellIdentifiers = [[NSMutableDictionary alloc]init];
        
        self.segMenu = [[NSArray alloc]initWithObjects:@"STUDENTS", @"HUDDLES", @"CHAT", nil];
        
        self.docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        self.docsPath = [self.docsPath stringByAppendingPathComponent:@"classSegment"];
        
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
    
    self.huddlesData = [[NSMutableDictionary alloc]init];
    self.studentData = [[NSMutableDictionary alloc]init];
    self.encapsulatingDataArray = [[NSMutableArray alloc]initWithObjects: self.studentData, self.huddlesData, nil];
    
    [self loadClassData];
    
    
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
    [self.segCellIdentifiers setObject:SHStudentCellIdentifier forKey:@"STUDENTS"];
    [self.segCellIdentifiers setObject:SHHuddleCellIdentifier forKey:@"HUDDLES"];
    [self.segCellIdentifiers setObject:@"UITableViewCell" forKey:[@"Chat" uppercaseString]];
    // [self.segCellIdentifiers setObject:SHCategoryCellIdentifier forKey:[@"Resources" uppercaseString]];  //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ // NEED TO REGISTER CELLS AS WELL
    
    //Segment
    [self.view addSubview:self.control];
    
    [self.tableView registerClass:[SHStudentCell class] forCellReuseIdentifier:SHStudentCellIdentifier];
    [self.tableView registerClass:[SHHuddleCell class] forCellReuseIdentifier:SHHuddleCellIdentifier];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    
    
}

- (void)refreshTable {
    //TODO: refresh your data
    [refreshControl endRefreshing];
    [self loadClassData];
    [self.tableView reloadData];
}

-(BOOL)loadClassData
{
    BOOL loadError = true;
    
    [self.segClass fetchIfNeeded];
    
    //Student Dataa
    NSArray *students = [self.segClass objectForKey:SHClassStudentsKey];
    [[self.studentData objectForKey:@"both"] removeAllObjects];
    [self.studentData setObject:students forKey:@"both"];
    [SHUtility fetchObjectsInArray:[self.studentData objectForKey:@"both"]];
    [SHUtility separateOnlineOfflineData:self.studentData forOnlineKey:SHStudentStudyingKey];
    
    
    //Huddle Data
    NSArray *huddles = [self.segClass objectForKey:SHClassHuddlesKey];
    [[self.huddlesData objectForKey:@"both"] removeAllObjects];
    [self.huddlesData setObject:huddles forKey:@"both"];
    [SHUtility separateOnlineOfflineData:self.huddlesData forOnlineKey:SHHuddleStudyingKey];
    [SHUtility fetchObjectsInArray:[self.huddlesData objectForKey:@"both"]];
    self.currentRowsToDisplay = [[self.huddlesData objectForKey:@"both"] count];
    //Chat
    
    [self.tableView reloadData];
    
    return loadError;
}

- (void)setClass:(PFObject *)aClass
{
    _segClass = aClass;
    [self loadClassData];
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
    self.currentRowsToDisplay = [[[self.encapsulatingDataArray objectAtIndex:control.selectedSegmentIndex] objectForKey:@"both"] count];
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
    return self.currentRowsToDisplay;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    CellIdentifier = [self.segCellIdentifiers objectForKey:[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex]];
    
    
    if([CellIdentifier isEqual:SHStudentCellIdentifier])
    {
        PFObject *studentObject;
        SHStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(indexPath.row+1 <= [[self.studentData objectForKey:@"online"]count]){
            studentObject = [[self.studentData objectForKey:@"online"] objectAtIndex:(int)indexPath.row];
            [cell setOnline];
        }
        else
            studentObject = [[self.studentData objectForKey:@"offline"] objectAtIndex:((int)indexPath.row-[[self.studentData objectForKey:@"online"]count])];
        
        cell.delegate = self;
        
        [studentObject fetch];
        
        [cell setStudent:studentObject];
        
        [cell layoutIfNeeded];
        
        return cell;
    }
    else if([CellIdentifier isEqual:SHHuddleCellIdentifier])
    {
        PFObject *huddleObject;
        SHHuddleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(indexPath.row+1 <= [[self.huddlesData objectForKey:@"online"]count]){
            huddleObject = [[self.huddlesData objectForKey:@"online"] objectAtIndex:(int)indexPath.row];
            [cell setOnline];
            
        }
        else
            huddleObject = [[self.huddlesData objectForKey:@"offline"] objectAtIndex:(int)indexPath.row];
        
        cell.delegate = self;
        
        [huddleObject fetch];
        
        [cell setHuddle:huddleObject];
        
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

#pragma mark - Cell Delegate methods

- (void)didTapTitleCell:(SHBaseTextCell *)cell
{
    
    if ([cell isKindOfClass:[SHStudentCell class]] ) {
        SHStudentCell *studentCell = (SHStudentCell *)cell;
        
        SHVisitorProfileViewController *studentVC = [[SHVisitorProfileViewController alloc]initWithStudent:(Student *)studentCell.student];
        
        
        [self.owner.navigationController pushViewController:studentVC animated:YES];
        
    }
    else if ([cell isKindOfClass:[SHHuddleCell class]] ) {
        SHHuddleCell *huddleCell = (SHHuddleCell *)cell;
        
        SHIndividualHuddleViewController *huddleVC = [[SHIndividualHuddleViewController alloc]initWithHuddle:huddleCell.huddle];
        
        
        [self.owner.navigationController pushViewController:huddleVC animated:YES];
        
    }
}

-(float)getOccupatingHeight
{
    //check if its in study, classes or online
    float cellHeight = 0;
    switch (self.control.selectedSegmentIndex)
    {
        case 0:
            cellHeight = SHStudentCellHeight;
            break;
        case 1:
            cellHeight = SHHuddleCellHeight;
            break;
        case 2:
            cellHeight = SHChatCellHeight;
            break;
        default:
            break;
    }
    
    return cellHeight*self.currentRowsToDisplay;
    
}




@end
