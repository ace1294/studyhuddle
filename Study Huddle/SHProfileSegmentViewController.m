//
//  SHProfileSegmentViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/14/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHProfileSegmentViewController.h"
#import "UIColor+HuddleColors.h"
#import "SHHuddleCell.h"
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
#import "SHUtility.h"
#import "SHClassPageViewController.h"
#import "SHStartStudyingViewController.h"
#import "SHStudyViewController.h"
#import "SHCache.h"


@interface SHProfileSegmentViewController () <SHBaseCellDelegate>

@property (strong, nonatomic) NSString *docsPath;
@property (strong, nonatomic) Student *segStudent;

@property (strong, nonatomic) NSString *CellIdentifier;
@property (nonatomic, assign) NSInteger currentRowsToDisplay;
@property (nonatomic, strong) NSMutableDictionary *segCellIdentifiers;

@property (strong, nonatomic) NSArray *segMenu;

@property (strong, nonatomic) NSMutableDictionary *segmentData;

@property (strong, nonatomic) NSMutableArray *studyingDataArray;
@property (strong, nonatomic) NSMutableArray *classesDataArray;
@property (strong, nonatomic) NSMutableArray *onlineDataArray;

@property (strong, nonatomic) NSMutableArray *encapsulatingDataArray;

@end

@implementation SHProfileSegmentViewController

@synthesize CellIdentifier;

- (id)initWithStudent:(Student *)student
{
    self = [super init];
    if(self)
    {
        _segStudent = student;
        
        CellIdentifier = [[NSString alloc]init];
        
        self.segCellIdentifiers = [[NSMutableDictionary alloc]init];
        
        self.segmentData = [[NSMutableDictionary alloc]init];
        
        self.segMenu = [[NSArray alloc]initWithObjects:@"STUDY LOG", @"CLASSES", @"ONLINE", nil];
        self.docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        self.docsPath = [self.docsPath stringByAppendingPathComponent:@"profileSegment"];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }
    
    return self;
}

+ (void)load
{
    [[DZNSegmentedControl appearance] setBackgroundColor:[UIColor whiteColor]];
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
    
    self.studyingDataArray = [[NSMutableArray alloc]init];
    self.classesDataArray = [[NSMutableArray alloc]init];
    self.onlineDataArray = [[NSMutableArray alloc]init];
    self.encapsulatingDataArray = [[NSMutableArray alloc]initWithObjects:self.studyingDataArray,self.classesDataArray,self.onlineDataArray, nil];
    

    [self loadStudentDataRefresh:false];

    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    //Tableview
    CGRect tableViewFrame = CGRectMake(tableViewX, tableViewY , tableViewDimX, tableViewDimY);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //[self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.tableView];
    
    //Set segment menu titles
    [self.segCellIdentifiers setObject:SHStudyCellIdentifier forKey:[@"Study Log" uppercaseString]];
    [self.segCellIdentifiers setObject:SHClassCellIdentifier forKey:[@"Classes" uppercaseString]];
    [self.segCellIdentifiers setObject:SHStudentCellIdentifier forKey:[@"Online" uppercaseString]];
    
    //Segment
    [self.view addSubview:self.control];
    
    [self.tableView registerClass:[SHClassCell class] forCellReuseIdentifier:SHClassCellIdentifier];
    [self.tableView registerClass:[SHStudyCell class] forCellReuseIdentifier:SHStudyCellIdentifier];
    [self.tableView registerClass:[SHStudentCell class] forCellReuseIdentifier:SHStudentCellIdentifier];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    [self.tableView setScrollEnabled:NO];
    self.control.backgroundColor = [UIColor whiteColor];

    
    [self loadStudentDataRefresh:false];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)setStudent:(Student *)aSegStudent
{
    _segStudent = aSegStudent;
    [self loadStudentDataRefresh:false];
}

- (BOOL)loadStudentDataRefresh:(BOOL)refresh
{
    BOOL loadError = true;
    [self.segStudent fetchIfNeeded];
    
    [self.studyingDataArray removeAllObjects];
    [self.studyingDataArray addObjectsFromArray:[[SHCache sharedCache] studyLogs]];
    
    [self.studyingDataArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [[obj2 objectForKey:SHStudyStartKey] compare:[obj1 objectForKey:SHStudyStartKey]];
    }];
    
    [self.classesDataArray removeAllObjects];
    
    NSArray *classes = [[SHCache sharedCache] classes];
    if ([classes count] > 0) {
        [self.classesDataArray addObjectsFromArray:[[SHCache sharedCache] classes]];
    } else {
        NSLog(@"NO CLasses");
    }
    
    
    [self.onlineDataArray removeAllObjects];
    [self.onlineDataArray addObjectsFromArray:[[SHCache sharedCache]studyFriends]];
    
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
    
    if([[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] isEqual:@"ONLINE"])
        return SHHuddleCellHeight;
    else if([[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] isEqual:@"CLASSES"])
        return SHClassCellHeight;
    else
        return SHStudyCellHeight;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] isEqual:@"ONLINE"])
    {
        Student *student = self.onlineDataArray[indexPath.row];
        
        SHVisitorProfileViewController *studentVC = [[SHVisitorProfileViewController alloc]initWithStudent:student];
        
        
        [self.owner.navigationController pushViewController:studentVC animated:YES];
    }
    else if([[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] isEqual:@"CLASSES"])
    {
        PFObject *class = self.classesDataArray[indexPath.row];
        
        SHClassPageViewController *classVC = [[SHClassPageViewController alloc]initWithClass:class];
        
        [self.owner.navigationController pushViewController:classVC animated:YES];
    }
    else
    {
        PFObject *studyLog = self.studyingDataArray[indexPath.row];
        
        SHStudyViewController *studyVC = [[SHStudyViewController alloc]initWithStudy:studyLog];
        
        [self.owner.navigationController pushViewController:studyVC animated:YES];
        
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
    
    if([CellIdentifier isEqual:SHStudentCellIdentifier])
    {
        PFObject* studentObject = [self.onlineDataArray objectAtIndex:(int)indexPath.row];
        SHStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.delegate = self;
        
        [cell setStudent:studentObject];
        [cell layoutIfNeeded];
        
        return cell;
    }
    else if([CellIdentifier isEqual:SHClassCellIdentifier])
    {
        PFObject* classObject = [self.classesDataArray objectAtIndex:(int)indexPath.row];
        SHClassCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.delegate = self;
        
        [cell setClass:classObject];
        [cell layoutIfNeeded];
        
        return cell;
    }
    else if([CellIdentifier isEqual:SHStudyCellIdentifier])
    {
        PFObject *studyObject = [self.studyingDataArray objectAtIndex:(int)indexPath.row];
        SHStudyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.delegate = self;
        
        [cell setStudy:studyObject];
        [cell layoutIfNeeded];
        
        return cell;
    }
    
    
    return nil;
}

- (void)didTapTitleCell:(SHBaseTextCell *)cell
{
    if ([cell isKindOfClass:[SHStudentCell class]] ) {
        SHStudentCell *studentCell = (SHStudentCell *)cell;
        
        SHVisitorProfileViewController *studentVC = [[SHVisitorProfileViewController alloc]initWithStudent:(Student *)studentCell.student];
        
        
        [self.owner.navigationController pushViewController:studentVC animated:YES];
        
    }
    else if ([cell isKindOfClass:[SHClassCell class]] ) {
        SHClassCell *classCell = (SHClassCell *)cell;
        
        SHClassPageViewController *classVC = [[SHClassPageViewController alloc]initWithClass:classCell.huddleClass];
        
        
        [self.owner.navigationController pushViewController:classVC animated:YES];
        
    }
    else if ([cell isKindOfClass:[SHStudyCell class]] ){
        
        SHStudyCell *studyCell = (SHStudyCell *)cell;
        
        SHStudyViewController *studyVC = [[SHStudyViewController alloc]initWithStudy:studyCell.study];
        
        [self.owner.navigationController pushViewController:studyVC animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //if (scrollView.contentOffset.y<0) {
        //[self.parentScrollView setScrollEnabled:YES];
   // }
    
}

#pragma mark - Navigation Dlegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //Here for when the study page updates the classes
    
    [self.tableView reloadData];
}

- (void)currentStudy:(PFObject *)study
{
    [self.studyingDataArray insertObject:study atIndex:0];
    
    self.control.selectedSegmentIndex = 0;
    self.currentRowsToDisplay = [self.studyingDataArray count];
    
    
    [self tableView:self.tableView numberOfRowsInSection:0];
    
    [self.tableView reloadData];
}

-(float)getOccupatingHeight
{
    //check if its in study, classes or online
    float cellHeight = 0;
    switch (self.control.selectedSegmentIndex)
    {
        case 0:
            cellHeight = SHStudyCellHeight;
            break;
        case 1:
            cellHeight = SHClassCellHeight;
            break;
        case 2:
            cellHeight = SHStudentCellHeight;
            break;
        default:
            break;
    }
    
    return cellHeight*self.currentRowsToDisplay;
 
}



@end






