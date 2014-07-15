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

@end


@implementation SHVisitorClassSegmentViewController

- (id)initWithClass:(PFObject *)aClass
{
    self = [super init];
    if (self) {
        _segClass = aClass;
        
        self.segMenu = [[NSArray alloc]initWithObjects:@"STUDENTS", nil];
        
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
    
    
    
}

-(BOOL)loadClassData
{
    BOOL loadError = true;
    
    [self.segClass fetch];
    
    //Student Dataa
    NSArray *students = [self.segClass objectForKey:SHClassStudentsKey];
    [[self.studentData objectForKey:@"both"] removeAllObjects];
    [self.studentData setObject:students forKey:@"both"];
    [SHUtility fetchObjectsInArray:[self.studentData objectForKey:@"both"]];
    [SHUtility separateOnlineOfflineData:self.studentData forOnlineKey:SHStudentStudyingKey];
    

    
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

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.studentData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *studentObject;
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
    

    SHVisitorProfileViewController *studentVC = [[SHVisitorProfileViewController alloc]initWithStudent:(Student *)studentCell.student];
        
        
    [self.owner.navigationController pushViewController:studentVC animated:YES];
        

}

-(float)getOccupatingHeight
{
    
    return studentCellHeight*self.studentData.count;
    
}


@end
