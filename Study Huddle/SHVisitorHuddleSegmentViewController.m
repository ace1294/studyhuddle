//
//  SHHuddleSegmentViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/24/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHVisitorHuddleSegmentViewController.h"
#import "UIColor+HuddleColors.h"
#import "SHConstants.h"
#import "SHStudentCell.h"
#import "SHResourceCell.h"
#import "SHVisitorProfileViewController.h"
#import "SHProfileViewController.h"
#import "SHIndividualHuddleviewController.h"
#import "SHUtility.h"
#import "UIViewController+MJPopupViewController.h"



@interface SHVisitorHuddleSegmentViewController () <SHBaseCellDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSString *docsPath;

@property (strong, nonatomic) PFObject *segHuddle;

@property (strong, nonatomic) NSArray *segMenu;

@property (strong, nonatomic) NSMutableDictionary *segmentData;
@property (strong, nonatomic) NSMutableArray *membersDataArray;


@end


@implementation SHVisitorHuddleSegmentViewController

-(id)initWithHuddle:(PFObject *)aHuddle
{
    self = [super init];
    if(self)
    {
        _segHuddle = aHuddle;
        
        self.segMenu = [[NSArray alloc]initWithObjects:@"MEMBERS", nil];
        
        
        
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
    
    self.membersDataArray = [[NSMutableArray alloc]init];
    
    [self loadHuddleData];
    
    
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
    
    //Segment
    [self.view addSubview:self.control];
    
    [self.tableView registerClass:[SHStudentCell class] forCellReuseIdentifier:SHStudentCellIdentifier];
    
    
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
    
    PFQuery *query = [PFUser query];
    [query whereKey:SHStudentHuddlesKey equalTo:self.segHuddle];
    [query whereKey:SHStudentEmailKey notEqualTo:[PFUser currentUser][SHStudentEmailKey]];
    NSArray *members = [query findObjects];
    
    [self.membersDataArray removeAllObjects];
    [self.membersDataArray addObjectsFromArray:members];
    [SHUtility fetchObjectsInArray:self.membersDataArray];
    
    
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
        _control.selectedSegmentIndex = 0;
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
    [self.tableView reloadData];
}


- (UIBarPosition)positionForBar:(id <UIBarPositioning>)view
{
    return UIBarPositionBottom;
}

#pragma mark - UITableViewDelegate Methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SHStudentCellHeight;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.membersDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *studentObject = [self.membersDataArray objectAtIndex:(int)indexPath.row];
    SHStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:SHStudentCellIdentifier];
    cell.delegate = self;
        
    [studentObject fetch];
        
    [cell setStudent:studentObject];
        
    [cell layoutIfNeeded];
        
    return cell;

    
}

- (void)didTapTitleCell:(SHBaseTextCell *)cell
{

    SHStudentCell *studentCell = (SHStudentCell *)cell;
        
    SHVisitorProfileViewController *visitorVC = [[SHVisitorProfileViewController alloc]initWithStudent:(Student *)studentCell.student];
            
    [self.navigationController pushViewController:visitorVC animated:YES];

    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<0) {
        [self.parentScrollView setScrollEnabled:YES];
    }
    
}

-(float)getOccupatingHeight
{

    return studentCellHeight*self.membersDataArray.count;
    
}

@end
