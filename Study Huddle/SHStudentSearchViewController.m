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
#import "UIColor+HuddleColors.h"
#import "SHHuddleJoinRequestViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "MBProgressHUD.h"

@interface SHStudentSearchViewController () <SHModalViewControllerDelegate>

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
    
    [self.searchedBar becomeFirstResponder];
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self doHeavySearchWith:searchText andHud:hud];
    });
    
}

-(void)doHeavySearchWith: (NSString*)searchText andHud: (MBProgressHUD*)hud
{
    //Clean up past search results
    [self.searchResults removeAllObjects];
    //[self.searchedBar resignFirstResponder];
    self.searchResults = [NSMutableArray arrayWithCapacity:15];
    
    //Create query from class
    //PFQuery *query = [PFQuery queryWithClassName:@"Classes"];
    PFQuery *query = [PFUser query];
    query.cachePolicy =kPFCachePolicyCacheElseNetwork;
    [query whereKey:SHStudentLowerNameKey containsString:[searchText lowercaseString]];
    
    NSArray *results = [query findObjects];
    
    [self.searchResults addObjectsFromArray:results];
    
    [query orderByAscending:SHStudentLowerNameKey];
    
    [self loadObjects];
    
    [self.searchedBar becomeFirstResponder];
    [hud removeFromSuperview];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
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


    PFUser *object = [PFUser object];
    object = [self.searchResults objectAtIndex:indexPath.row];
        
    [cell setStudent:object];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.searchedBar.text = @"";
    [self.searchedBar resignFirstResponder];
    
    PFUser *selectedStudent = [PFUser object];
    selectedStudent = [self.searchResults objectAtIndex:indexPath.row];
    
    

    if ([self.type isEqual:@"NewHuddle"]) {
        self.navigationController.navigationBarHidden = NO;
        [self.delegate didAddMember:selectedStudent];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if([self.type isEqual:@"NewMember"]){
        [self.delegate didAddMember:selectedStudent];
        
        SHHuddleJoinRequestViewController *joinVC = [[SHHuddleJoinRequestViewController alloc]initWithHuddle:self.huddle withType:SHRequestHSJoin];
        joinVC.delegate = self;
        joinVC.requestedStudent = selectedStudent;
        
        [self presentPopupViewController:joinVC animationType:MJPopupViewAnimationSlideBottomBottom dismissed:^{
            [self dismissViewControllerAnimated:YES completion:nil];
            
            self.navigationController.navigationBarHidden = NO;
        }];
        
        
    }
    
    [self.searchResults removeAllObjects];
    self.searchResults = nil;
    
    [tableView reloadData];
    
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

#pragma mark - Popup delegate methods


- (void)cancelTapped
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchedBar resignFirstResponder];
}

@end
