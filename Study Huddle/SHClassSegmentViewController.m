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
#import "SHChatCell.h"
#import "SHIndividualHuddleViewController.h"
#import "SHVisitorHuddleViewController.h"
#import "SHVisitorProfileViewController.h"
#import "SHCache.h"
#import "RoomView.h"

@interface SHClassSegmentViewController () <SHBaseCellDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSString *docsPath;

@property (strong, nonatomic) PFObject *segClass;

@property (strong, nonatomic) NSString *CellIdentifier;
@property (nonatomic, assign) NSInteger currentRowsToDisplay;
@property (nonatomic, strong) NSMutableDictionary *segCellIdentifiers;

@property (strong, nonatomic) NSArray *segMenu;

@property (strong, nonatomic) NSMutableDictionary *huddlesData;
@property (strong, nonatomic) NSMutableDictionary *studentData;
@property (strong, nonatomic) NSMutableArray *chatCategoriesDataArray;

@property (strong, nonatomic) NSNumber *huddleOnlineStatus;  // 0 == both, 1 == online, 2 == offline
@property (strong, nonatomic) NSNumber *studentOnlineStatus;

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
    self.chatCategoriesDataArray = [[NSMutableArray alloc]init];
    self.encapsulatingDataArray = [[NSMutableArray alloc]initWithObjects: self.studentData, self.huddlesData, self.chatCategoriesDataArray,nil];
    
    [self loadClassDataRefresh:false];
    
    
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
    [self.segCellIdentifiers setObject:SHChatCellIdentifier forKey:[@"Chat" uppercaseString]];
    
    //Segment
    [self.view addSubview:self.control];
    
    [self.tableView registerClass:[SHStudentCell class] forCellReuseIdentifier:SHStudentCellIdentifier];
    [self.tableView registerClass:[SHHuddleCell class] forCellReuseIdentifier:SHHuddleCellIdentifier];
    [self.tableView registerClass:[SHChatCell class] forCellReuseIdentifier:SHChatCellIdentifier];
    
    self.control.backgroundColor = [UIColor whiteColor];
    
}

- (void)setClass:(PFObject *)aClass
{
    _segClass = aClass;
    [self loadClassDataRefresh:true];
}

- (void)refreshTable {
    //TODO: refresh your data
    [refreshControl endRefreshing];
    [self loadClassDataRefresh:true];
    [self.tableView reloadData];
}

-(BOOL)loadClassDataRefresh:(BOOL)refresh
{
    BOOL loadError = true;
    
    [self.segClass fetchIfNeeded];
    
    //Student Dataa
    [[self.studentData objectForKey:@"both"] removeAllObjects];
    NSArray *students = [[SHCache sharedCache] studentsForClass:self.segClass];
    [self.studentData setObject:students forKey:@"both"];
    self.studentOnlineStatus = [SHUtility separateOnlineOfflineData:self.studentData forOnlineKey:SHStudentStudyingKey];
    
    
    //Huddle Data
    [[self.huddlesData objectForKey:@"both"] removeAllObjects];
    [self.huddlesData setObject:[[SHCache sharedCache] huddlesForClass:self.segClass] forKey:@"both"];
    self.huddleOnlineStatus = [SHUtility separateOnlineOfflineData:self.huddlesData forOnlineKey:SHHuddleOnlineKey];
    
    self.currentRowsToDisplay = [[self.huddlesData objectForKey:@"both"] count];
    
    //Chat
    [self.chatCategoriesDataArray removeAllObjects];
    [self.chatCategoriesDataArray addObjectsFromArray:[[SHCache sharedCache] chatCategoriessForClass:self.segClass]];
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
    
    
    if(control.selectedSegmentIndex<=1 )
        self.currentRowsToDisplay = [[[self.encapsulatingDataArray objectAtIndex:control.selectedSegmentIndex] objectForKey:@"both"] count];
    else
        self.currentRowsToDisplay = [[self.encapsulatingDataArray objectAtIndex:control.selectedSegmentIndex] count];
    [self.tableView reloadData];
}


- (UIBarPosition)positionForBar:(id <UIBarPositioning>)view
{
    return UIBarPositionBottom;
}

#pragma mark - UITableViewDelegate Methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.control.selectedSegmentIndex == 2)
        return SHChatCellHeight;
    
    return SHHuddleCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] isEqual:@"CHAT"])
        return 0.0;
    
    return 40.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] isEqual:@"STUDENTS"])
    {
        PFUser *student = [self.studentData objectForKey:@"both"][indexPath.row];
        
        SHVisitorProfileViewController *studentVC = [[SHVisitorProfileViewController alloc]initWithStudent:student];
        
        
        [self.owner.navigationController pushViewController:studentVC animated:YES];
    }
    else if([[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] isEqual:@"HUDDLES"])
    {
        //$$$$$$$$$$$$$$$$ Need to check if student is in huddle, maybe should pop them back to huddle page?
        
        PFObject *huddle = [self.huddlesData objectForKey:@"both"][indexPath.row];
        
        SHVisitorHuddleViewController *huddleVC = [[SHVisitorHuddleViewController alloc]initWithHuddle:huddle];
        
        [self.owner.navigationController pushViewController:huddleVC animated:YES];
    }
    else
    {
        //
        
    }
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] isEqual:@"STUDENTS"])
    {
        if([[self.studentData objectForKey:@"online"] count] > 0 && [[self.studentData objectForKey:@"offline"] count] > 0)
            return 2;
    }
    else if([[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] isEqual:@"HUDDLES"])
    {
        if([[self.huddlesData objectForKey:@"online"] count] > 0 && [[self.huddlesData objectForKey:@"offline"] count] > 0)
            return 2;
    }
    else if([[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] isEqual:@"CHAT"])
        return 1;
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] isEqual:@"STUDENTS"])
    {
        if([self.studentOnlineStatus isEqualToNumber:[NSNumber numberWithInt:0]]){
            if(section == 0)
                return [[self.studentData objectForKey:@"online"] count];
            else
                return [[self.studentData objectForKey:@"offline"] count];
        } else if([self.studentOnlineStatus isEqualToNumber:[NSNumber numberWithInt:1]]){
            return [[self.studentData objectForKey:@"online"] count];
        } else{
            return [[self.studentData objectForKey:@"offline"] count];
        }
            
    }
    else if([[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] isEqual:@"HUDDLES"])
    {
        if([self.huddleOnlineStatus isEqualToNumber:[NSNumber numberWithInt:0]]){
            if(section == 0)
                return [[self.huddlesData objectForKey:@"online"] count];
            else
                return [[self.huddlesData objectForKey:@"offline"] count];
        } else if([self.huddleOnlineStatus isEqualToNumber:[NSNumber numberWithInt:1]]){
            if(section == 0)
                return [[self.huddlesData objectForKey:@"online"] count];
        } else{
            if(section == 0)
                return [[self.huddlesData objectForKey:@"offline"] count];
        }
    }
    else
    {
        
    }
    
    return self.currentRowsToDisplay;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if([[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] isEqual:@"STUDENTS"])
    {
        if([self.studentOnlineStatus isEqualToNumber:[NSNumber numberWithInt:0]]){
            if(section == 0)
                return @"Online";
            else
                return @"Offline";
        } else if([self.studentOnlineStatus isEqualToNumber:[NSNumber numberWithInt:1]]){
            return @"Online";
        } else{
            return @"Offline";
        }
    }
    else if([[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] isEqual:@"HUDDLES"])
    {
        if([self.huddleOnlineStatus isEqualToNumber:[NSNumber numberWithInt:0]]){
            if(section == 0)
                return @"Online";
            else
                return @"Offline";
        } else if([self.huddleOnlineStatus isEqualToNumber:[NSNumber numberWithInt:1]]){
            return @"Online";
        } else{
            return @"Offline";
        }
    } else
    {
        return @"Shouldn't See This";
    }
    
    
    return @"Check Title";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    CellIdentifier = [self.segCellIdentifiers objectForKey:[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex]];
    
    
    if([CellIdentifier isEqual:SHStudentCellIdentifier])
    {
        PFUser *studentObject;
        SHStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        
        if([self.studentOnlineStatus isEqualToNumber:[NSNumber numberWithInt:0]]){
            if(indexPath.section == 0){
                studentObject = [[self.studentData objectForKey:@"online"] objectAtIndex:(int)indexPath.row];
                [cell setOnline];
            }
            else
                studentObject = [[self.studentData objectForKey:@"offline"] objectAtIndex:(int)indexPath.row];
                
        } else if([self.studentOnlineStatus isEqualToNumber:[NSNumber numberWithInt:1]]){
            if(indexPath.section == 0){
                studentObject = [[self.studentData objectForKey:@"online"] objectAtIndex:(int)indexPath.row];
                [cell setOnline];
            }
        } else{
            if(indexPath.section == 0)
                studentObject = [[self.studentData objectForKey:@"offline"] objectAtIndex:(int)indexPath.row];
        }
        
        cell.delegate = self;
        [cell setStudent:studentObject];
        [cell layoutIfNeeded];
        
        return cell;
    }
    else if([CellIdentifier isEqual:SHHuddleCellIdentifier])
    {
        PFObject *huddleObject;
        SHHuddleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if([self.huddleOnlineStatus isEqualToNumber:[NSNumber numberWithInt:0]]){
            if(indexPath.section == 0){
                huddleObject = [[self.huddlesData objectForKey:@"online"] objectAtIndex:(int)indexPath.row];
                [cell setOnline];
            }
            else
                huddleObject = [[self.huddlesData objectForKey:@"offline"] objectAtIndex:(int)indexPath.row];
            
        } else if([self.huddleOnlineStatus isEqualToNumber:[NSNumber numberWithInt:1]]){
            if(indexPath.section == 0){
                huddleObject = [[self.huddlesData objectForKey:@"online"] objectAtIndex:(int)indexPath.row];
                [cell setOnline];
            }
        } else{
            if(indexPath.section == 0)
                huddleObject = [[self.huddlesData objectForKey:@"offline"] objectAtIndex:(int)indexPath.row];
        }
        
        cell.delegate = self;
        [cell setHuddle:huddleObject];
        [cell layoutIfNeeded];
        
        return cell;
    }
    else if([CellIdentifier isEqual:SHChatCellIdentifier])
    {
        
        PFObject *chatEntryObj = [self.chatCategoriesDataArray objectAtIndex:(int)indexPath.row];
        SHChatCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.delegate = self;
        [chatEntryObj fetchIfNeeded];
        [cell setChatEntry:chatEntryObj];
        [cell layoutIfNeeded];
        
        return cell;
    }/*
    else if([CellIdentifier isEqual:@"UITableViewCell"])
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell.textLabel.text = @"Chat";
        
        return cell;
    }*/
    
    
    return nil;
    
}

#pragma mark - Cell Delegate methods

- (void)didTapTitleCell:(SHBaseTextCell *)cell
{
    
    if ([cell isKindOfClass:[SHStudentCell class]] ) {
        SHStudentCell *studentCell = (SHStudentCell *)cell;
        
        SHVisitorProfileViewController *studentVC = [[SHVisitorProfileViewController alloc]initWithStudent:studentCell.student];
        
        
        [self.owner.navigationController pushViewController:studentVC animated:YES];
        
    }
    else if ([cell isKindOfClass:[SHHuddleCell class]] ) {
        SHHuddleCell *huddleCell = (SHHuddleCell *)cell;
        
        SHIndividualHuddleViewController *huddleVC = [[SHIndividualHuddleViewController alloc]initWithHuddle:huddleCell.huddle];
        
        
        [self.owner.navigationController pushViewController:huddleVC animated:YES];
        
    }
    else if([cell isKindOfClass:[SHChatCell class]])
    {
        PFObject* chatEntryObj = [(SHChatCell*)cell getChatEntryObj];
        //NSLog(@"chatEntryObj: , %@",chatEntryObj);
        //SHChatEntryViewController* chatEntryVC = [[SHChatEntryViewController alloc]initWithChatEntry:chatEntryObj];
        //[self.navigationController pushViewController:chatEntryVC animated:YES];*/
        [chatEntryObj fetchIfNeeded];
        RoomView *roomView = [[RoomView alloc] initWithChatCategoryOwner:[chatEntryObj objectId]];
        roomView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:roomView animated:YES];
        
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
