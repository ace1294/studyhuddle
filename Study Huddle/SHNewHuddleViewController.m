//
//  SHNewHuddleViewController.m
//  Sample
//
//  Created by Jason Dimitriou on 6/12/14.
//  Copyright (c) 2014 Epic Peaks GmbH. All rights reserved.
//

#import "SHNewHuddleViewController.h"
#import "SHProfilePortraitViewToBeDeleted.h"
#import "UIColor+HuddleColors.h"
#import "UITextField+Extend.h"
#import "SHStudentSearchViewController.h"
#import "SHConstants.h"
#import "SHStudentCell.h"
#import <QuartzCore/QuartzCore.h>
#import "SHBasePortraitView.h"
#import "SHIndividualHuddleViewController.h"
#import "SHHuddleButtons.h"
#import "SHUtility.h"



@interface SHNewHuddleViewController () < UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>{
    CGSize scrollViewContentSize;
}

@property (strong, nonatomic) PFObject *student;
@property (strong, nonatomic) NSMutableDictionary *classObjects; //Class Objects, Class Name Keys

//New Huddle properties
@property (strong, nonatomic) SHBasePortraitView *huddlePortrait;
@property (nonatomic, strong) NSString* className;
@property (strong, nonatomic) NSMutableArray *huddleMembers;
@property (strong, nonatomic) UITextField *huddleNameTextField;

//Header labels
@property (strong, nonatomic) UILabel *huddleNameHeaderLabel;
@property (strong, nonatomic) UILabel *classHuddleHeaderLabel;
@property (strong, nonatomic) UILabel *membersHeaderLabel;

//UIButtons
@property (strong, nonatomic) SHHuddleButtons *huddleClassButtons;


@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) SHStudentSearchViewController *searchVC;

@property (strong,nonatomic) UIScrollView* scrollView;

- (void)classPressed:(id)sender;
- (void)didTapSearchClass:(id)sender;

@end

@implementation SHNewHuddleViewController

float classButtonsHeight;

#define contentWidth 300.0

#define huddleImageX 15.0
#define huddleImageY 100.0
#define huddleImageDim 100.0

#define nameHeaderY 130.0
#define nameY nameHeaderY+headerHeight

#define classHeaderY nameY+vertElemSpacing

#define huddleClassButtonY classHeaderY+headerHeight
#define huddleClassButtonWidth 150.0
#define huddleClassButtonHeight 40.0


- (id)initWithStudent:(PFObject *)aStudent
{
    self = [super init];
    if(self)
    {
        self.view.backgroundColor = [UIColor huddleLightGrey];
        
        _student = aStudent;
        self.classObjects = [[NSMutableDictionary alloc]init];
        
        //set up scroll view
        self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
        self.view = self.scrollView;
        scrollViewContentSize = self.scrollView.frame.size;
        scrollViewContentSize.height+=0;
        [self.scrollView setContentSize:scrollViewContentSize];
        
        [self initHeaders];
        [self initContent];
        
        
        
        
    }
    
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
}

- (void)initHeaders
{
    self.huddleNameHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, nameHeaderY, headerWidth, headerHeight)];
    [self.huddleNameHeaderLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    [self.huddleNameHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.huddleNameHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.huddleNameHeaderLabel.text = @"Huddle Name";
    [self.view addSubview:self.classHuddleHeaderLabel];
    
    self.classHuddleHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, classHeaderY, headerWidth, headerHeight)];
    [self.classHuddleHeaderLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    [self.classHuddleHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.classHuddleHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.classHuddleHeaderLabel.text = @"Huddle Class";
    [self.view addSubview:self.classHuddleHeaderLabel];
    
    self.membersHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, 40.0, headerWidth, headerHeight)];
    [self.membersHeaderLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    [self.membersHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.membersHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.membersHeaderLabel.text = @"Huddle Members";
    [self.view addSubview:self.membersHeaderLabel];
}

- (void)initContent
{
    UIBarButtonItem *createButton = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStylePlain target:self action:@selector(createPressed)];
    createButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = createButton;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"Create Huddle";
    
    self.huddlePortrait = [[SHBasePortraitView alloc]initWithFrame:CGRectMake(huddleImageX, huddleImageY, huddleImageDim, huddleImageDim)];
    [self.huddlePortrait setBackgroundColor:[UIColor clearColor]];
    [self.huddlePortrait setOpaque:YES];
    self.huddlePortrait.owner = self;
    [self.view addSubview:self.huddlePortrait];
    
    //Huddle Name
    self.huddleNameTextField = [[UITextField alloc] init];
    [self.huddleNameTextField setBackgroundColor: [UIColor whiteColor]];
    [self.huddleNameTextField setFont:[UIFont fontWithName:@"Arial" size:12]];
    [self.huddleNameTextField setPlaceholder:@"Huddle Name"];
    [self.huddleNameTextField setDelegate:self];
    [self.huddleNameTextField.layer setCornerRadius:5];
    self.huddleNameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0,0);    //inset
    [self.view addSubview:self.huddleNameTextField];
    
    CGRect initialFrame = CGRectMake(horiViewSpacing, huddleClassButtonY, huddleClassButtonWidth, huddleClassButtonHeight);
    NSMutableArray *classes = [NSMutableArray arrayWithArray:[SHUtility namesForObjects:self.student[SHStudentClassesKey] withKey:SHClassFullNameKey]];
    [classes addObject:@"Personal"];
    self.huddleClassButtons = [[SHHuddleButtons alloc] initWithFrame:initialFrame items:classes addButton:nil];
    self.huddleClassButtons.viewController = self;
    self.huddleClassButtons.delegate = self;
    classButtonsHeight = [self.huddleClassButtons getButtonHeight];
    
    [self.membersHeaderLabel setFrame:CGRectMake(horiViewSpacing, classButtonsHeight+vertElemSpacing+huddleClassButtonY, headerWidth, headerHeight)];
    
    CGFloat tableY = self.membersHeaderLabel.frame.origin.y+self.membersHeaderLabel.frame.size.height;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(horiViewSpacing, tableY, contentWidth, 30.0) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setScrollEnabled:NO];
    [self.view addSubview:self.tableView];
    
    self.huddleMembers = [[NSMutableArray alloc]init];
}



#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"RETURN");
    
    UITextField *next = textField.nextTextField;
    if (next) {
        [next becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return NO;
}

#pragma mark - UITableViewDelegate Methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return 40.0;
    else
        return 70.0;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        self.searchVC = [[SHStudentSearchViewController alloc]init];
        self.searchVC.type = @"NewHuddle";
        
        self.searchVC.navigationController.delegate = self;
        [self.navigationController pushViewController:self.searchVC animated:YES];
    }
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.huddleMembers count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        UITableViewCell *searchCell = [self.tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
        
        if(!searchCell)
            searchCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchCell"];
        
        searchCell.textLabel.textColor = [UIColor huddleOrange];
        searchCell.textLabel.text = @"Find student to join huddle";
        searchCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return searchCell;
    }
    
    SHStudentCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SHStudentCellIdentifier];
    
    if(!cell)
        cell = [[SHStudentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SHStudentCellIdentifier];
    
    PFUser *object = [PFUser object];
    object = [self.huddleMembers objectAtIndex:(indexPath.row-1)];
    
    [cell setStudent:object];
    
    return cell;
}




#pragma mark - Actions
-(void)createPressed
{
    self.huddle = [PFObject objectWithClassName:SHHuddleParseClass];
    self.huddle[SHHuddleNameKey] = self.huddleNameTextField.text;
    self.huddle[SHHuddleClassKey] = [self.classObjects objectForKey:self.className];
    
    [self.huddle saveInBackground];
    
    SHIndividualHuddleViewController *huddleVC = [[SHIndividualHuddleViewController alloc]initWithHuddle:self.huddle];
    
    [self.parentViewController.navigationController pushViewController:huddleVC animated:YES];
    
    
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"HEREREREREEE");
    
    if(self.searchVC.addedMember)
    {
        [self.navigationController.navigationBar setHidden:NO];
        [self.huddleMembers addObject:self.searchVC.addedMember];
    
        scrollViewContentSize.height += SHStudentCellHeight;
        [self.scrollView setContentSize:scrollViewContentSize];
        
        [self.tableView reloadData];
    }
}

@end
