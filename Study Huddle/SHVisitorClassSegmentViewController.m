//
//  SHClassSegmentViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/29/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHVisitorClassSegmentViewController.h"
#import "SHConstants.h"
#import "SHUtility.h"
#import "UIColor+HuddleColors.h"
#import "SHStudentCell.h"
#import "SHIndividualHuddleviewController.h"
#import "SHVisitorProfileViewController.h"

@interface SHVisitorClassSegmentViewController () <SHBaseCellDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSString *docsPath;

@property (strong, nonatomic) PFObject *segClass;

@property (strong, nonatomic) NSArray *segMenu;

@property (strong, nonatomic) NSMutableDictionary *studentData;
@property (strong, nonatomic) NSNumber *studentOnlineStatus;

@end


@implementation SHVisitorClassSegmentViewController

- (id)initWithClass:(PFObject *)aClass
{
    self = [super init];
    if (self) {
        _segClass = aClass;
        
        self.segMenu = [[NSArray alloc]initWithObjects:@"STUDENTS", nil];
        [aClass saveInBackground];
        
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
    
    self.studentData = [[NSMutableDictionary alloc]init];
    
    [self loadClassData];
    
    
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
    self.control.backgroundColor = [UIColor whiteColor];
    
    
}

-(BOOL)loadClassData
{
    BOOL loadError = true;
    
    [self.segClass fetchIfNeeded];
    
    
    PFQuery *query = [PFUser query];
    [query whereKey:SHStudentClassesKey equalTo:self.segClass];
    NSArray *students = [query findObjects];
    
    [[self.studentData objectForKey:@"both"] removeAllObjects];
    [self.studentData setObject:students forKey:@"both"];
    [SHUtility fetchObjectsInArray:[self.studentData objectForKey:@"both"]];
    self.studentOnlineStatus = [SHUtility separateOnlineOfflineData:self.studentData forOnlineKey:SHStudentStudyingKey];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.studentOnlineStatus isEqualToNumber:[NSNumber numberWithInt:0]]){
        if(section == 0)
            return [[self.studentData objectForKey:@"online"] count];
        else
            return [[self.studentData objectForKey:@"offline"] count];
    } else if([self.studentOnlineStatus isEqualToNumber:[NSNumber numberWithInt:1]])
        return [[self.studentData objectForKey:@"online"] count];
    else
        return [[self.studentData objectForKey:@"offline"] count];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if([self.studentOnlineStatus isEqualToNumber:[NSNumber numberWithInt:0]]){
        if(section == 0)
            return @"Online";
        else
            return @"Offline";
    }else if([self.studentOnlineStatus isEqualToNumber:[NSNumber numberWithInt:1]])
        return @"Online";
    else
        return @"Offline";
    
    return @"Check Title";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFUser *studentObject;
    SHStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:SHStudentCellIdentifier];
        
    if(indexPath.row < [[self.studentData objectForKey:@"online"]count]){
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

#pragma mark - Cell Delegate methods

- (void)didTapTitleCell:(SHBaseTextCell *)cell
{
    SHStudentCell *studentCell = (SHStudentCell *)cell;
    

    SHVisitorProfileViewController *studentVC = [[SHVisitorProfileViewController alloc]initWithStudent:studentCell.student];
        
        
    [self.owner.navigationController pushViewController:studentVC animated:YES];
        

}

-(float)getOccupatingHeight
{
    
    return studentCellHeight*self.studentData.count;
    
}


@end
