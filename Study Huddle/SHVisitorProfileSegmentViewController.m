//
//  SHProfileSegmentViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/14/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHVisitorProfileSegmentViewController.h"
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
#import "SHVisitorProfileViewController.h"
#import "SHIndividualHuddleviewController.h"
#import "SHVisitorHuddleViewController.h"
#import "SHUtility.h"

@interface SHVisitorProfileSegmentViewController () <SHAddCellDelegate, SHBaseCellDelegate>

@property (strong, nonatomic) NSString *docsPath;
@property (strong, nonatomic) Student *segStudent;

@property (strong, nonatomic) NSString *CellIdentifier;
@property (nonatomic, assign) NSInteger currentRowsToDisplay;
@property (nonatomic, strong) NSMutableDictionary *segCellIdentifiers;

@property (strong, nonatomic) NSArray *segMenu;

@property (strong, nonatomic) NSMutableDictionary *segmentData;

@property (strong, nonatomic) NSMutableArray *studyingDataArray;
@property (strong, nonatomic) NSMutableArray *classesDataArray;
@property (strong, nonatomic) NSMutableArray *huddlesDataArray;

@property (strong, nonatomic) NSMutableArray *encapsulatingDataArray;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation SHVisitorProfileSegmentViewController

@synthesize CellIdentifier;
@synthesize refreshControl;



static NSString* const StudyDiskKey = @"studyArray";
static NSString* const ClassesDiskKey = @"classKey";
static NSString* const HuddlesDiskKey = @"huddlesKey";

- (id)initWithStudent:(Student *)student
{
    self = [super init];
    if(self)
    {
        _segStudent = student;
        
        CellIdentifier = [[NSString alloc]init];

        self.segCellIdentifiers = [[NSMutableDictionary alloc]init];
        
        self.segmentData = [[NSMutableDictionary alloc]init];
        
        self.segMenu = [[NSArray alloc]initWithObjects:@"STUDY", @"CLASSES", @"HUDDLES", nil];
        self.docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        self.docsPath = [self.docsPath stringByAppendingPathComponent:@"visitorProfileSegment"];
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
    
    self.StudyingDataArray = [[NSMutableArray alloc]init];
    self.ClassesDataArray = [[NSMutableArray alloc]init];
    self.HuddlesDataArray = [[NSMutableArray alloc]init];
    self.encapsulatingDataArray = [[NSMutableArray alloc]initWithObjects:self.studyingDataArray,self.classesDataArray,self.huddlesDataArray, nil];

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
    [self.segCellIdentifiers setObject:SHStudyCellIdentifier forKey:[@"Study" uppercaseString]];
    [self.segCellIdentifiers setObject:SHClassCellIdentifier forKey:[@"Classes" uppercaseString]];
    [self.segCellIdentifiers setObject:SHHuddleCellIdentifier forKey:[@"Huddles" uppercaseString]];
    
    //Segment
    [self.view addSubview:self.control];

    [self.tableView registerClass:[SHHuddleCell class] forCellReuseIdentifier:SHHuddleCellIdentifier];
    [self.tableView registerClass:[SHClassCell class] forCellReuseIdentifier:SHClassCellIdentifier];
    [self.tableView registerClass:[SHStudyCell class] forCellReuseIdentifier:SHStudyCellIdentifier];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    

    

    
}

- (void)refreshTable {
    //TODO: refresh your data
    [refreshControl endRefreshing];
    [self loadStudentData];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if ([self.segStudent username])
//    {
//        if([[NSFileManager defaultManager] fileExistsAtPath:self.docsPath])
//        {
//            [self loadDataFromDisk];
//            return;
//        }
//        
//        [self loadStudentData];
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
    
    //Classes Data
    NSArray *classes = [self.segStudent objectForKey:SHStudentClassesKey];
    [self.classesDataArray removeAllObjects];
    [self.classesDataArray addObjectsFromArray:classes];
    [SHUtility fetchObjectsInArray:self.classesDataArray];
    self.currentRowsToDisplay = self.classesDataArray.count;
    
    //Huddle Data
    NSArray *huddles = self.segStudent[SHStudentHuddlesKey];
    [self.huddlesDataArray removeAllObjects];
    [self.huddlesDataArray addObjectsFromArray:huddles];
    [SHUtility fetchObjectsInArray:self.huddlesDataArray];
    
    
    [self.tableView reloadData];
    
    //[self saveDataToDisk];
    
    return loadError;
}

- (void)saveDataToDisk
{
    
    NSLog(@"SAVING TO DISK");
    
    [self.segmentData setObject:self.studyingDataArray forKey:StudyDiskKey];
    [self.segmentData setObject:self.classesDataArray forKey:ClassesDiskKey];
    [self.segmentData setObject:self.huddlesDataArray forKey:HuddlesDiskKey];
    
    [NSKeyedArchiver archiveRootObject:self.segmentData toFile:self.docsPath];
    
}

- (void)loadDataFromDisk
{
    NSLog(@"LOADING FROM DISK");
    
    self.segmentData = [NSKeyedUnarchiver unarchiveObjectWithFile:self.docsPath];
    
    self.studyingDataArray = [self.segmentData objectForKey:StudyDiskKey];
    self.classesDataArray = [self.segmentData objectForKey:ClassesDiskKey];
    self.huddlesDataArray = [self.segmentData objectForKey:HuddlesDiskKey];
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
    
    if([[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] isEqual:@"HUDDLES"])
        return SHHuddleCellHeight;
    else
        return SHStudyCellHeight;

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

    if([CellIdentifier isEqual:SHHuddleCellIdentifier])
    {
        PFObject* huddleObject = [self.huddlesDataArray objectAtIndex:(int)indexPath.row];
        SHHuddleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell.delegate = self;
        
        [huddleObject fetchIfNeeded];
        [cell setHuddle:huddleObject];
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
//
//        //        SHHuddle *newHuddle = [[SHHuddle alloc] initWithHuddleName:@"BAMF2" students: tempArray class:[[SHClass alloc] initWithClassName:@"Calc"] pic:nil];
//        //        [newHuddle saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        //            if(!error)
//        //                NSLog(@"New Huddle saved in background");
//        //        }];
//        
//    }
//    else if ([[self.parent.control titleForSegmentAtIndex:self.parent.control.selectedSegmentIndex]  isEqual: @"CLASSES"]){
//        // SHClass *newClass = [[SHClass alloc] init];
//        NSLog(@"New Class");
//    }
//    else if ([[self.parent.control titleForSegmentAtIndex:self.parent.control.selectedSegmentIndex]  isEqual: @"REQUESTS"]){
//        NSLog(@"New Student");
    }
    else{
        NSLog(@"Black People");
    }
    
    NSLog(@"Black People");
}


- (void)didTapTitleCell:(SHBaseTextCell *)cell
{
    if ([cell isKindOfClass:[SHHuddleCell class]] ) {
        SHHuddleCell *huddleCell = (SHHuddleCell *)cell;
        
        //check to see if he is in the huddle
        BOOL userInHuddle = [SHUtility user:[PFUser currentUser] isInHuddle:huddleCell.huddle];
        if(userInHuddle)
        {
            SHIndividualHuddleviewController *huddleVC = [[SHIndividualHuddleviewController alloc]initWithHuddle:huddleCell.huddle];
            [self.owner.navigationController pushViewController:huddleVC animated:YES];

        }
        else
        {
            SHVisitorHuddleViewController *huddleVC = [[SHVisitorHuddleViewController alloc]initWithHuddle:huddleCell.huddle];
            [self.owner.navigationController pushViewController:huddleVC animated:YES];
        }
      
        
    }
    else if ([cell isKindOfClass:[SHClassCell class]] ) {
//        SHHuddleCell *huddleCell = (SHHuddleCell *)cell;
//        
//        
//        SHIndividualHuddleviewController *huddleVC = [[SHIndividualHuddleviewController alloc]initWithHuddle:huddleCell.huddle];
//        NSLog(@"HEREHUDDDLle");
//        
//        [self.owner.navigationController pushViewController:huddleVC animated:YES];
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<0) {
        NSLog(@"it moved down");
        [self.parentScrollView setScrollEnabled:YES];
        
    }
    
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






