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
#import "SHAddCell.h"
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

@interface SHProfileSegmentViewController () <SHAddCellDelegate, SHBaseCellDelegate, SHStartStudyingDelegate>

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

static NSString* const StudyDiskKey = @"studyArray";
static NSString* const ClassesDiskKey = @"classKey";
static NSString* const OnlineDiskKey = @"onlineKey";

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
    
    self.studyingDataArray = [[NSMutableArray alloc]init];
    self.classesDataArray = [[NSMutableArray alloc]init];
    self.onlineDataArray = [[NSMutableArray alloc]init];
    self.encapsulatingDataArray = [[NSMutableArray alloc]initWithObjects:self.studyingDataArray,self.classesDataArray,self.onlineDataArray, nil];
    

    [self loadStudentData];

    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Tableview
    CGRect tableViewFrame = CGRectMake(tableViewX, tableViewY, tableViewDimX, tableViewDimY);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.tableView];
    
    //Set segment menu titles
    [self.segCellIdentifiers setObject:SHStudyCellIdentifier forKey:[@"Study Log" uppercaseString]];
    [self.segCellIdentifiers setObject:SHClassCellIdentifier forKey:[@"Classes" uppercaseString]];
    [self.segCellIdentifiers setObject:SHStudentCellIdentifier forKey:[@"Online" uppercaseString]];
    
    //Segment
    [self.view addSubview:self.control];
    
    [self.tableView registerClass:[SHHuddleCell class] forCellReuseIdentifier:SHHuddleCellIdentifier];
    [self.tableView registerClass:[SHClassCell class] forCellReuseIdentifier:SHClassCellIdentifier];
    [self.tableView registerClass:[SHAddCell class] forCellReuseIdentifier:SHAddCellIdentifier];
    [self.tableView registerClass:[SHStudyCell class] forCellReuseIdentifier:SHStudyCellIdentifier];
    [self.tableView registerClass:[SHStudentCell class] forCellReuseIdentifier:SHStudentCellIdentifier];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    

    
    [self loadStudentData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    
//    if ([self.segStudent username])
//    {
//        if([[NSFileManager defaultManager] fileExistsAtPath:self.docsPath])
//        {
//            [self loadDataFromDisk];
//            return;
//        }
//        
        //[self loadStudentData];
//    }
}

- (void)setStudent:(Student *)aSegStudent
{
    _segStudent = aSegStudent;
    [self loadStudentData];
}

- (BOOL)loadStudentData
{
    BOOL loadError = true;
    [self.segStudent fetch];
    
    //Study Data
    NSArray *studying = [self.segStudent objectForKey:SHStudentStudyKey];
    
    [self.studyingDataArray removeAllObjects];
    [self.studyingDataArray addObjectsFromArray:studying];
    [SHUtility fetchObjectsInArray:self.studyingDataArray];
    
    [self.studyingDataArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [[obj2 objectForKey:SHStudyStartKey] compare:[obj1 objectForKey:SHStudyStartKey]];
    }];
    
    //Classes Data
    NSArray *classes = [self.segStudent objectForKey:SHStudentClassesKey];
    self.currentRowsToDisplay = classes.count;
    
    [self.classesDataArray removeAllObjects];
    [self.classesDataArray addObjectsFromArray:classes];
    [SHUtility fetchObjectsInArray:self.classesDataArray];
    
    //Huddle Data
    NSArray *onlineStudents = [self.segStudent objectForKey:SHStudentOnlineFriendsKey];
    
    [self.onlineDataArray removeAllObjects];
    [self.onlineDataArray addObjectsFromArray:onlineStudents];
    [SHUtility fetchObjectsInArray:self.onlineDataArray];
    
    
    [self.tableView reloadData];
    
    //[self saveDataToDisk];
    
    return loadError;
}

- (void)saveDataToDisk
{
    
    NSLog(@"SAVING TO DISK");
    
    [self.segmentData setObject:self.studyingDataArray forKey:StudyDiskKey];
    [self.segmentData setObject:self.classesDataArray forKey:ClassesDiskKey];
    [self.segmentData setObject:self.onlineDataArray forKey:OnlineDiskKey];
    
    [NSKeyedArchiver archiveRootObject:self.segmentData toFile:self.docsPath];
    
}

- (void)loadDataFromDisk
{
    NSLog(@"LOADING FROM DISK");
    
    self.segmentData = [NSKeyedUnarchiver unarchiveObjectWithFile:self.docsPath];
    
    self.studyingDataArray = [self.segmentData objectForKey:StudyDiskKey];
    self.classesDataArray = [self.segmentData objectForKey:ClassesDiskKey];
    self.onlineDataArray = [self.segmentData objectForKey:OnlineDiskKey];
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
    else
        return SHClassCellHeight;
    
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger addCell = 0;
    
    if([self.segStudent isEqual:[Student currentUser]] && [[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] isEqual:@"CLASSES"])
        addCell = 1;
    
    
    
    return self.currentRowsToDisplay + addCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellIdentifier = [self.segCellIdentifiers objectForKey:[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex]];
    
    if ([self.segStudent isEqual:[Student currentUser]] && [CellIdentifier isEqual:SHClassCellIdentifier] && indexPath.row == self.currentRowsToDisplay)
    {
        SHAddCell *cell = [tableView dequeueReusableCellWithIdentifier:SHAddCellIdentifier];
        [cell setAdd:@"Add Class" identifier:SHClassCellIdentifier];
        
        cell.delegate = self;
        [cell layoutIfNeeded];
        
        return cell;
        
    }
    else if([CellIdentifier isEqual:SHStudentCellIdentifier])
    {
        
        
        PFObject* studentObject = [self.onlineDataArray objectAtIndex:(int)indexPath.row];
        SHStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.delegate = self;
        
        [studentObject fetchIfNeeded];
        [cell setStudent:studentObject];
        [cell layoutIfNeeded];
        
        return cell;
    }
    else if([CellIdentifier isEqual:SHClassCellIdentifier])
    {
        PFObject* classObject = [self.classesDataArray objectAtIndex:(int)indexPath.row];
        SHClassCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.delegate = self;
        
        [classObject fetchIfNeeded];
        [cell setClass:classObject];
        [cell layoutIfNeeded];
        
        return cell;
    }
    else if([CellIdentifier isEqual:SHStudyCellIdentifier])
    {
        PFObject *studyObject = [self.studyingDataArray objectAtIndex:(int)indexPath.row];
        SHStudyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.delegate = self;
        
        [studyObject fetchIfNeeded];
        [cell setStudy:studyObject];
        [cell layoutIfNeeded];
        
        return cell;
    }
    
    
    return nil;
}

-(void)didTapAddButton
{
    if([[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex]  isEqual: @"HUDDLES"]){
        // NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:@[@"Jason", @"Jose"]];
        
        SHNewHuddleViewController *newHuddleVC = [[SHNewHuddleViewController alloc]initWithStudent:[PFUser currentUser]];
        
        newHuddleVC.modalPresentationStyle = UIModalPresentationFormSheet;
        newHuddleVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        UINavigationController *naviModal = [[UINavigationController alloc] initWithRootViewController:newHuddleVC];
        [naviModal setDelegate:newHuddleVC];
        naviModal.navigationBar.barTintColor = [UIColor huddleOrange];
        [naviModal.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        [self presentViewController:naviModal animated:YES completion:nil];
    }
    else{
        NSLog(@"Black People");
    }
    
    NSLog(@"Black People");
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
    if (scrollView.contentOffset.y<0) {
        [self.parentScrollView setScrollEnabled:YES];
    }
    
}

#pragma mark - StartStudying Delegate

- (void)startedStudying:(PFObject *)study
{
    [self.studyingDataArray insertObject:study atIndex:0];
    
    self.currentRowsToDisplay = [self.studyingDataArray count];
    
    [self tableView:self.tableView numberOfRowsInSection:0];
    
    [self.tableView reloadData];
}



@end






