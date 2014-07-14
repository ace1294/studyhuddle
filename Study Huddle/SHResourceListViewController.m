//
//  SHResourceListViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/6/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHResourceListViewController.h"
#import "SHResourceCell.h"
#import "SHConstants.h"
#import "SHIndividualResourceViewController.h"

@interface SHResourceListViewController () <UITableViewDataSource, UITableViewDelegate, SHBaseCellDelegate>

@property (strong, nonatomic) UITableView *tableview;
@property (strong, nonatomic) NSString *CellIdentifier;

@property (strong, nonatomic) NSArray *resources;


@end

@implementation SHResourceListViewController

@synthesize CellIdentifier;

- (id)initWithResourceCategory:(PFObject *)aCategory
{
    self = [super init];
    if (self) {
        _category = aCategory;
        
        self.resources = [aCategory objectForKey:SHResourceCategoryResourcesKey];
        
        self.tableview = [[UITableView alloc] initWithFrame:self.view.frame];
        self.tableview.delegate = self;
        self.tableview.dataSource = self;
        
        self.title = aCategory[SHResourceCategoryNameKey];
        
        [self.view addSubview:self.tableview];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SHResourceCellHeight;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return [self.resources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHResourceCell *cell = [tableView dequeueReusableCellWithIdentifier:SHResourceCellIdentifier];
    if(!cell)
        cell = [[SHResourceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SHResourceCellIdentifier];
    
    cell.delegate = self;
    
    PFObject *resourceObject = [self.resources objectAtIndex:(int)indexPath.row];
    
    [resourceObject fetch];
    
    [cell setResource:resourceObject];
    
    [cell layoutIfNeeded];
    
    return  cell;
    
}

- (void)didTapTitleCell:(SHBaseTextCell *)cell
{
    SHResourceCell *resourceCell = (SHResourceCell *)cell;
    
    SHIndividualResourceViewController *individualVC = [[SHIndividualResourceViewController alloc]initWithResource:resourceCell.resource];
    
    [self.navigationController pushViewController:individualVC animated:YES];
}




@end


