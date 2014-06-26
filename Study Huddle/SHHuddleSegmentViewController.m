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

@interface SHHuddleSegmentViewController ()

@property (strong, nonatomic) NSString *docsPath;

@property (strong, nonatomic) PFObject *segHuddle;

@property (strong, nonatomic) NSString *CellIdentifier;
@property (nonatomic, assign) NSInteger currentRowsToDisplay;
@property (nonatomic, strong) NSMutableDictionary *segCellIdentifiers;

@property (strong, nonatomic) NSArray *segMenu;

@property (strong, nonatomic) NSMutableDictionary *segmentData;
@property (strong, nonatomic) NSMutableArray *membersDataArray;
@property (strong, nonatomic) NSMutableArray *threadDataArray;
@property (strong, nonatomic) NSMutableArray *resourcesDataArray;

@property (strong, nonatomic) NSMutableArray *encapsulatingDataArray;

@end


@implementation SHHuddleSegmentViewController

static NSString* const MembersDiskKey = @"membersArray";
static NSString* const ResourcesDiskKey = @"resourcesKey";

@synthesize CellIdentifier;

-(id)initWithHuddle:(PFObject *)aHuddle
{
    self = [super init];
    if(self)
    {
        _segHuddle = aHuddle;
        
        CellIdentifier = [[NSString alloc]init];
        
        self.segCellIdentifiers = [[NSMutableDictionary alloc]init];
        
        self.segmentData = [[NSMutableDictionary alloc]init];
        
        self.segMenu = [[NSArray alloc]initWithObjects:@"MEMBERS", @"CHAT", @"RESOURCES", nil];
        
        self.docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
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
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    [self.segCellIdentifiers setObject:SHResourceCellIdentifier forKey:[@"Resources" uppercaseString]];  //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ // NEED TO REGISTER CELLS AS WELL
    
    //Segment
    [self.view addSubview:self.control];
    
    [self.tableView registerClass:[SHStudentCell class] forCellReuseIdentifier:SHStudentCellIdentifier];
    [self.tableView registerClass:[SHAddCell class] forCellReuseIdentifier:SHAddCellIdentifier];
    [self.tableView registerClass:[SHResourceCell class] forCellReuseIdentifier:SHResourceCellIdentifier];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    self.membersDataArray = [[NSMutableArray alloc]init];
    self.resourcesDataArray = [[NSMutableArray alloc]init];
    self.encapsulatingDataArray = [[NSMutableArray alloc]initWithObjects:self.resourcesDataArray, self.membersDataArray, nil];
    
    if(self.segHuddle[SHHuddleNameKey]){
        [self loadHuddleData];
    }
    
    
        

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.segHuddle[SHHuddleNameKey]){
        [self loadHuddleData];
    }
    
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
    
    NSArray *resources = [self.segHuddle objectForKey:SHHuddleResourcesKey];
    
    [self.resourcesDataArray removeAllObjects];
    [self.resourcesDataArray addObjectsFromArray:resources];
    
    NSArray *members = [self.segHuddle objectForKey:SHHuddleMembersKey];
    
    [self.membersDataArray removeAllObjects];
    [self.membersDataArray addObjectsFromArray:members];
    
    //Chat
    
    [self.tableView reloadData];
    
    return loadError;
}

- (void)saveDataToDisk
{
    
    NSLog(@"SAVING TO DISK");
    
    [self.segmentData setObject:self.membersDataArray forKey:MembersDiskKey];
    [self.segmentData setObject:self.resourcesDataArray forKey:ResourcesDiskKey];
    //[self.segmentData setObject:self.huddlesDataArray forKey:HuddlesDiskKey];
    
    [NSKeyedArchiver archiveRootObject:self.segmentData toFile:self.docsPath];
    
}

- (void)loadDataFromDisk
{
    NSLog(@"LOADING FROM DISK");
    
    self.segmentData = [NSKeyedUnarchiver unarchiveObjectWithFile:self.docsPath];
    
    self.membersDataArray = [self.segmentData objectForKey:MembersDiskKey];
    self.resourcesDataArray = [self.segmentData objectForKey:ResourcesDiskKey];
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

    
    if([self.membersDataArray containsObject:[Student currentUser]] && [[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] isEqual:@"MEMBERS"])
        addCell = 1;
    
    
    return self.currentRowsToDisplay + addCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellIdentifier = [self.segCellIdentifiers objectForKey:[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex]];

    if ([CellIdentifier isEqual:SHStudentCellIdentifier] && indexPath.row == self.currentRowsToDisplay)
    {
        SHAddCell *cell = [tableView dequeueReusableCellWithIdentifier:SHAddCellIdentifier];
        //cell.titleButton.titleLabel.text = @"Add Huddle";
        cell.delegate = self;
        
        [cell layoutIfNeeded];
        
        return cell;
    }
    else if([CellIdentifier isEqual:SHStudentCellIdentifier])
    {
        PFObject *studentObject = [self.membersDataArray objectAtIndex:(int)indexPath.row];
        SHStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        [studentObject fetchIfNeeded];
        
        [cell setStudent:studentObject];
        
        [cell layoutIfNeeded];
        
        return cell;
    }
    else if([CellIdentifier isEqual:SHResourceCellIdentifier])
    {
        PFObject *resourceObject = [self.resourcesDataArray objectAtIndex:(int)indexPath.row];
        SHResourceCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        [resourceObject fetchIfNeeded];
        
        [cell setResource:resourceObject];
        
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<0) {
        [self.parentScrollView setScrollEnabled:YES];
    }
    
}



@end
