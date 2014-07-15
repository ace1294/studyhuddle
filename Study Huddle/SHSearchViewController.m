//
//  SHSearchViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/15/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHSearchViewController.h"
#import "SHStudentCell.h"
#import "SHClassCell.h"
#import "SHHuddleCell.h"
#import "SHConstants.h"
#import <Parse/Parse.h>
#import "Student.h"
#import "UIColor+HuddleColors.h"

@interface SHSearchViewController ()

@property (nonatomic, strong) UISearchBar *searchedBar;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, assign) BOOL shouldReloadOnAppear;

@end

@implementation SHSearchViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Search";
        self.tabBarItem.image = [UIImage imageNamed:@"search.png"];
        
        self.parseClassName = @"dummy";
        
        self.pullToRefreshEnabled = NO;
        
        self.paginationEnabled = NO;
        
        self.objectsPerPage = 15;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.searchedBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
    
    [self.searchedBar setImage:[UIImage imageNamed:@"SearchTab@2x.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    self.searchedBar.showsCancelButton = YES;
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
    self.searchedBar.barTintColor = [UIColor huddleOrange];
    self.searchedBar.placeholder = @"Search";
    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor huddleOrange]];
    self.searchedBar.layer.borderWidth = 1;
    self.searchedBar.layer.borderColor = [[UIColor huddleOrange] CGColor];
    self.searchedBar.delegate = self;
    self.tableView.tableHeaderView = self.searchedBar;
    
    
    [self.searchedBar becomeFirstResponder];
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //Clean up past search results
    [self.searchResults removeAllObjects];
    //[self.searchedBar resignFirstResponder];
    self.searchResults = [NSMutableArray arrayWithCapacity:15];
    
    NSMutableArray *results = [[NSMutableArray alloc]init];
    
    PFQuery *studentQuery = [Student query];
    studentQuery.cachePolicy =kPFCachePolicyCacheElseNetwork;
    [studentQuery whereKey:SHStudentLowerNameKey containsString:[searchText lowercaseString]];
    
    [results addObjectsFromArray:[studentQuery findObjects]];
    
    PFQuery *huddleQuery = [PFQuery queryWithClassName:SHHuddleParseClass];
    huddleQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    [huddleQuery whereKey:SHHuddleNameKey containsString:[searchText lowercaseString]];
    
    [results addObjectsFromArray:[huddleQuery findObjects]];
    
    PFQuery *classQuery = [PFQuery queryWithClassName:SHClassParseClass];
    classQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    [classQuery whereKey:SHClassUniqueName containsString:[searchText lowercaseString]];
    
    [results addObjectsFromArray:[classQuery findObjects]];
    
    [self.searchResults addObjectsFromArray:results];
    
    //[query orderByAscending:SHStudentLowerNameKey];
    
    [self loadObjects];
    
    [self.searchedBar becomeFirstResponder];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


@end
