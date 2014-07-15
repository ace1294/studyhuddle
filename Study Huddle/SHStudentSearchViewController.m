//
//  SHStudentSearchViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/21/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHStudentSearchViewController.h"
#import "SHStudentCell.h"
#import "SHConstants.h"
#import <Parse/Parse.h>
#import "Student.h"
#import "UIColor+HuddleColors.h"

@interface SHStudentSearchViewController ()

@property (nonatomic, strong) UISearchBar *searchedBar;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, assign) BOOL shouldReloadOnAppear;

@end

@implementation SHStudentSearchViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.parseClassName = @"dummy";
        
        self.pullToRefreshEnabled = NO;
        
        self.paginationEnabled = NO;
        
        self.objectsPerPage = 10;
        
        self.type = [[NSString alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIView *addStatusBar = [[UIView alloc] init];
//    addStatusBar.frame = CGRectMake(0, -20, 320, 20);
//    addStatusBar.backgroundColor = [UIColor huddleOrange];
//    [self.view addSubview:addStatusBar];
//    [self.navigationController.navigationBar addSubview:addStatusBar];
    
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
    
    self.navigationController.navigationBarHidden = YES;
    
    
    [self.searchedBar becomeFirstResponder];
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //Clean up past search results
    [self.searchResults removeAllObjects];
    //[self.searchedBar resignFirstResponder];
    self.searchResults = [NSMutableArray arrayWithCapacity:15];
    
    //Create query from class
    //PFQuery *query = [PFQuery queryWithClassName:@"Classes"];
    PFQuery *query = [Student query];
    query.cachePolicy =kPFCachePolicyCacheElseNetwork;
    [query whereKey:SHStudentLowerNameKey containsString:[searchText lowercaseString]];
    
    NSArray *results = [query findObjects];
    
    [self.searchResults addObjectsFromArray:results];

    [query orderByAscending:SHStudentLowerNameKey];
    
    [self loadObjects];
    
    [self.searchedBar becomeFirstResponder];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    if ([self.type isEqual:@"NewHuddle"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if([self.type isEqual:@"NewMember"]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchResults == nil) {
        return 0;
    } else if ([self.searchResults count] == 0) {
        return 1;
    } else {
        return [self.searchResults count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *NothingCellIdentifier = @"NothingCell";
    
    
    if ([self.searchResults count] == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NothingCellIdentifier];
        
        if (cell == nil)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NothingCellIdentifier];
        
        cell.textLabel.text = @"No Results Found";
        
        return cell;
    }
    
    //Custom Cell
    SHStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:SHStudentCellIdentifier];
    if (cell == nil)
        cell = [[SHStudentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SHStudentCellIdentifier];


    PFObject *object = [PFObject objectWithClassName:SHStudentParseClass];
    object = [self.searchResults objectAtIndex:indexPath.row];
        
    [cell setStudent:object];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.searchedBar resignFirstResponder];
    
    PFObject *object = [PFObject objectWithClassName:SHStudentParseClass];
    object = [self.searchResults objectAtIndex:indexPath.row];
    
    
    
    self.addedMember = object;
    if ([self.type isEqual:@"NewHuddle"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if([self.type isEqual:@"NewMember"]){
        [self.delegate didAddMember:object];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.searchResults count] == 0) {
        return nil;
    } else {
        return indexPath;
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SHStudentCellHeight;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchedBar resignFirstResponder];
}

@end
