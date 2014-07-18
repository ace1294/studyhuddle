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
#import "SHIndividualHuddleviewController.h"



@interface SHNewHuddleViewController () < UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>{
    CGSize scrollViewContentSize;
}

@property (strong, nonatomic) PFObject *student;
@property (strong, nonatomic) PFRelation *classes; //Class Names
@property (strong, nonatomic) NSMutableDictionary *classObjects; //Class Objects, Class Name Keys

//New Huddle properties
@property (strong, nonatomic) SHBasePortraitView *huddlePortrait;
@property (nonatomic, strong) NSString* className;
@property (strong, nonatomic) NSMutableArray *huddleMembers;
@property (strong, nonatomic) UITextField *huddleName;

//UI Setup
@property (strong, nonatomic) UILabel *classHuddleLabel;
@property (strong, nonatomic) UILabel *inviteStudentsLabel;

//UIButtons
@property (strong, nonatomic) UIButton *personalButton;
@property (strong, nonatomic) NSMutableDictionary *classButtons;


@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) SHStudentSearchViewController *searchVC;

@property (strong,nonatomic) UIScrollView* scrollView;



- (void)allocateClassButtons;
- (void)classPressed:(id)sender;
- (void)didTapSearchClass:(id)sender;

@end

@implementation SHNewHuddleViewController

- (id)initWithStudent:(PFObject *)aStudent
{
    self = [super init];
    if(self)
    {
        
        //set up scroll view
        self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
        self.view = self.scrollView;
        scrollViewContentSize = self.scrollView.frame.size;
        scrollViewContentSize.height+=0;
        [self.scrollView setContentSize:scrollViewContentSize];
        
        
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        _student = aStudent;
        self.classObjects = [[NSMutableDictionary alloc]init];
        //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundSolid.png"]]];
        
        
        //done button
        UIBarButtonItem *createButton = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStylePlain target:self action:@selector(createPressed)];
        createButton.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = createButton;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.title = @"Create Huddle";
        
        
        //Huddle Image
        float centerX = self.view.bounds.origin.x + self.view.bounds.size.width/2;
        
        self.huddlePortrait = [[SHBasePortraitView alloc]initWithFrame:CGRectMake(centerX-(portraitDim/2), portraitY, portraitDim, portraitDim)];
        [self.huddlePortrait setBackgroundColor:[UIColor clearColor]];
        [self.huddlePortrait setOpaque:YES];
        self.huddlePortrait.owner = self;
        [self.view addSubview:self.huddlePortrait];
        
        //Huddle Name
        self.huddleName = [[UITextField alloc] init];
        [self.huddleName setBackgroundColor: [UIColor whiteColor]];
        [self.huddleName setFont:[UIFont fontWithName:@"Arial" size:12]];
        [self.huddleName setPlaceholder:@"Huddle Name"];
        [self.huddleName setDelegate:self];
        [self.huddleName.layer setCornerRadius:5];
        self.huddleName.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0,0);    //inset
        [self.view addSubview:self.huddleName];
        
        //Dividers
        self.classHuddleLabel = [[UILabel alloc] init];
        [self.classHuddleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
        [self.classHuddleLabel setTextColor:[UIColor whiteColor]];
        [self.classHuddleLabel setNumberOfLines:0];
        [self.classHuddleLabel sizeToFit];
        [self.classHuddleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        self.classHuddleLabel.textAlignment = NSTextAlignmentCenter;
        self.classHuddleLabel.text = [@"Class For Huddle" capitalizedString];
        [self.classHuddleLabel setBackgroundColor:[UIColor huddleLightGrey]];
        [self.view addSubview:self.classHuddleLabel];
        
        self.inviteStudentsLabel = [[UILabel alloc] init];
        [self.inviteStudentsLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
        [self.inviteStudentsLabel setTextColor:[UIColor whiteColor]];
        [self.inviteStudentsLabel setNumberOfLines:0];
        [self.inviteStudentsLabel sizeToFit];
        [self.inviteStudentsLabel setLineBreakMode:NSLineBreakByWordWrapping];
        self.inviteStudentsLabel.textAlignment = NSTextAlignmentCenter;
        self.inviteStudentsLabel.text = [@"Invite Students to Huddle" capitalizedString];
        [self.inviteStudentsLabel setBackgroundColor:[UIColor huddleLightGrey]];
        [self.view addSubview:self.inviteStudentsLabel];
        
        //Huddle Type Buttons
        self.classButtons = [[NSMutableDictionary alloc]init];
        [self allocateClassButtons];
        
        self.personalButton = [[UIButton alloc]init];
        self.personalButton.tag = 0;
        [self.personalButton setBackgroundColor:[UIColor huddleOrange]];
        [self.personalButton.layer setCornerRadius:4];
        [self.personalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[self.personalButton layer] setBorderWidth:1.0f];
        [[self.personalButton layer] setBorderColor:[UIColor huddleOrange].CGColor];
        [self.personalButton.titleLabel setFont:[UIFont fontWithName:@"Arial" size:16]];
        [self.personalButton setTitle:@"Personal Huddle (No Specific Class)" forState:UIControlStateNormal];
        [self.personalButton addTarget:self action:@selector(classPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.classButtons setObject:self.personalButton forKey:[NSNumber numberWithInt:self.personalButton.tag]];
        [self.view addSubview:self.personalButton];
        

        
        
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(tableX, tableY, maxWidth, tableDimY) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setScrollEnabled:NO];
        [self.view addSubview:self.tableView];
        
        self.huddleMembers = [[NSMutableArray alloc]init];
        

        

        
        
        
        
        
    }
    
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //[self.huddleImageView setFrame:CGRectMake(120.0, 80.0, 100.0, 100.0)];
    
    [self.huddleName setFrame:CGRectMake(nameX, nameY, maxWidth, nameDimY)];
    
    [self.classHuddleLabel setFrame:CGRectMake(0.0, classHuddleY, maxWidth, classHuddleDimY)];
    
    [self.personalButton setFrame:CGRectMake(classButtonX, personalY, classButtonDimX, classButtonDimY)];
    
    [self setClassButtonFrames];
    
    
}

- (void)allocateClassButtons
{
    self.classes = [self.student relationForKey:SHStudentClassesKey];
    PFQuery *classesQuery = [self.classes query];
    classesQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    NSArray *classList = [classesQuery findObjects];
    PFObject *class;
    
    NSLog(@"OBJECT COUNT %lu", (unsigned long)[classList count]);
    
    for(int i = 0; i < [classList count]; i++)
    {
        class = classList[i];
        [class fetchIfNeeded];
        
        [self.classObjects setObject:class forKey:class[SHClassFullNameKey]];
        UIButton *button = [[UIButton alloc]init];
        [self.classButtons setObject:button forKey:[NSNumber numberWithInt:i+1]];
        
        button.tag = i+1;
        [button.titleLabel setFont:[UIFont fontWithName:@"Arial" size:16]];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button.layer setCornerRadius:4];
        [button setTitleColor:[UIColor huddleOrange] forState:UIControlStateNormal];
        
        //Border
        [[button layer] setBorderWidth:1.0f];
        [[button layer] setBorderColor:[UIColor huddleOrange].CGColor];
        
        [button setTitle:class[SHClassFullNameKey] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(classPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
    }
    
}

- (void)setClassButtonFrames
{
    int i = 0;
    
    for(NSNumber *tag in self.classButtons)
    {
        if([tag intValue] == 0)
            continue;
        UIButton *button = [self.classButtons objectForKey:tag];
        [button setFrame:CGRectMake(20.0, (personalY+classButtonDimY+vertElemSpacing)+((classButtonDimY+vertElemSpacing)*i), classButtonDimX, classButtonDimY)];
        i++;
    }
    
    float classButtonHeight = personalY + classButtonDimY +vertElemSpacing + ((vertElemSpacing+classButtonDimY)*i);
    [self.inviteStudentsLabel setFrame:CGRectMake(0.0,  classButtonHeight, maxWidth, inviteStudentDimY)];
    
    [self.tableView setFrame:CGRectMake(0.0, classButtonHeight+inviteStudentDimY, maxWidth, self.view.frame.size.height-classButtonHeight)];
}

- (void)classPressed:(id)sender
{
    int buttonNumber = [sender tag];
    UIButton *selectedButton = [self.classButtons objectForKey:[NSNumber numberWithInt:buttonNumber]];
    
    self.className = selectedButton.titleLabel.text;
    
    [selectedButton setBackgroundColor:[UIColor huddleOrange]];
    [selectedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    for(NSNumber *tag in self.classButtons)
    {
        if(tag == [NSNumber numberWithInt:buttonNumber])
            continue;
        UIButton *button = [self.classButtons objectForKey:tag];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor huddleOrange] forState:UIControlStateNormal];
    }
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
    
    PFObject *object = [PFObject objectWithClassName:SHStudentParseClass];
    object = [self.huddleMembers objectAtIndex:(indexPath.row-1)];
    
    [cell setStudent:object];
    
    return cell;
}




#pragma mark - Actions
-(void)createPressed
{
    self.huddle = [PFObject objectWithClassName:SHHuddleParseClass];
    self.huddle[SHHuddleNameKey] = self.huddleName.text;
    self.huddle[SHHuddleClassKey] = [self.classObjects objectForKey:self.className];
    
    [self.huddle saveInBackground];
    
    SHIndividualHuddleviewController *huddleVC = [[SHIndividualHuddleviewController alloc]initWithHuddle:self.huddle];
    
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



//#pragma mark - Textfield
//
//// placeholder position
//- (CGRect)textRectForBounds:(CGRect)bounds {
//    return CGRectInset( bounds , 10 , 10 );
//}
//
//// text position
//- (CGRect)editingRectForBounds:(CGRect)bounds {
//    return CGRectInset( bounds , 10 , 10 );
//}

@end
