//
//  SHNewHuddleViewController.m
//  Sample
//
//  Created by Jason Dimitriou on 6/12/14.
//  Copyright (c) 2014 Epic Peaks GmbH. All rights reserved.
//

#import "SHNewHuddleViewController.h"
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
#import "SHCache.h"



@interface SHNewHuddleViewController () < UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, SHStudentSearchDelegate>{
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

@end

@implementation SHNewHuddleViewController

float classButtonsHeight;

#define contentWidth 300.0

#define huddleImageX 110.0
#define huddleImageY 10.0
#define huddleImageDim 100.0

#define nameHeaderY huddleImageY+huddleImageDim+vertElemSpacing
#define nameY nameHeaderY+headerHeight

#define classHeaderY nameY+textFieldHeight+vertElemSpacing

#define huddleClassButtonY classHeaderY+headerHeight
#define huddleClassButtonWidth 150.0
#define huddleClassButtonHeight 40.0


- (id)initWithStudent:(PFObject *)aStudent
{
    self = [super init];
    if(self)
    {
                _student = aStudent;
        self.classObjects = [[NSMutableDictionary alloc]init];
        
        //set up scroll view
        self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
        [self.scrollView setBackgroundColor:[UIColor huddleLightGrey]];
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
    self.huddleNameHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiBorderSpacing, nameHeaderY, headerWidth, headerHeight)];
    [self.huddleNameHeaderLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    [self.huddleNameHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.huddleNameHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.huddleNameHeaderLabel.text = @"Huddle Name";
    [self.view addSubview:self.huddleNameHeaderLabel];
    
    self.classHuddleHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiBorderSpacing, classHeaderY, headerWidth, headerHeight)];
    [self.classHuddleHeaderLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    [self.classHuddleHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.classHuddleHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.classHuddleHeaderLabel.text = @"Huddle Class";
    [self.view addSubview:self.classHuddleHeaderLabel];
    
    self.membersHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiBorderSpacing, 40.0, headerWidth, headerHeight)];
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
    self.title = @"New Huddle";
    
    self.huddlePortrait = [[SHBasePortraitView alloc]initWithFrame:CGRectMake(huddleImageX, huddleImageY, huddleImageDim, huddleImageDim)];
    [self.huddlePortrait setBackgroundColor:[UIColor clearColor]];
    [self.huddlePortrait setOpaque:YES];
    self.huddlePortrait.owner = self;
    [self.view addSubview:self.huddlePortrait];
    
    //Huddle Name
    self.huddleNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(horiBorderSpacing, nameY, contentWidth, textFieldHeight)];
    [self.huddleNameTextField setBackgroundColor: [UIColor whiteColor]];
    [self.huddleNameTextField setFont:[UIFont fontWithName:@"Arial" size:12]];
    [self.huddleNameTextField setPlaceholder:@"Huddle Name"];
    [self.huddleNameTextField setDelegate:self];
    [self.huddleNameTextField setTextColor:[UIColor huddleSilver]];
    [self.huddleNameTextField.layer setCornerRadius:2];
    self.huddleNameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0,0);    //inset
    [self.view addSubview:self.huddleNameTextField];
    
    CGRect initialFrame = CGRectMake(horiBorderSpacing, huddleClassButtonY, huddleClassButtonWidth, huddleClassButtonHeight);
    NSArray *classNames = [SHUtility namesForObjects:[[SHCache sharedCache]classes] withKey:SHClassShortNameKey];
    NSMutableDictionary *classObjects = [[NSMutableDictionary alloc]initWithObjects:[[SHCache sharedCache]classes] forKeys:classNames];
    [classObjects setObject:[PFObject objectWithClassName:@"Personal"] forKey:@"Personal"];
    
    self.huddleClassButtons = [[SHHuddleButtons alloc] initWithFrame:initialFrame items:classObjects addButton:nil];
    self.huddleClassButtons.textFont = [UIFont fontWithName:@"Arial" size:12.0];
    self.huddleClassButtons.viewController = self;
    self.huddleClassButtons.delegate = self;
    classButtonsHeight = [self.huddleClassButtons getButtonHeight];
    
    [self.membersHeaderLabel setFrame:CGRectMake(horiBorderSpacing, classButtonsHeight+vertElemSpacing+huddleClassButtonY, headerWidth, headerHeight)];
    
    CGFloat tableY = self.membersHeaderLabel.frame.origin.y+self.membersHeaderLabel.frame.size.height;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(horiBorderSpacing, tableY, contentWidth, 50.0) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setScrollEnabled:NO];
    self.tableView.layer.cornerRadius = 2;
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
        return 50.0;
    else
        return 70.0;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        if([self.huddleMembers count] > 9){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Max Amount of Members"
                                                            message: @"Huddles can only have 10 members."
                                                           delegate: nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        if(!self.searchVC){
            self.searchVC = [[SHStudentSearchViewController alloc]init];
            self.searchVC.type = @"NewHuddle";
            self.searchVC.delegate = self;
        }
        
        [self presentViewController:self.searchVC animated:YES completion:^{
            //
        }];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
        searchCell.textLabel.text = @"Add Member";
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
    self.huddle[SHHuddleCreatorKey] = [PFUser currentUser];
    self.huddle[SHHuddlePendingMembersKey] = self.huddleMembers;
    UIImage* huddleImage =  self.huddlePortrait.huddleImageView.image;
    NSData* imageData = UIImageJPEGRepresentation(huddleImage, 1.0f);
    PFFile *imageFile = [PFFile fileWithData:imageData];
    self.huddle[SHHuddleImageKey] = imageFile;
    
    [self.huddle saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        for(PFUser *user in self.huddleMembers)
        {
            
            PFObject *request = [PFObject objectWithClassName:SHRequestParseClass];
            request[SHRequestTitleKey] = self.huddle[SHHuddleNameKey];
            request[SHRequestTypeKey] = SHRequestHSJoin;
            request[SHRequestHuddleKey] = self.huddle;
            request[SHRequestToStudentKey] = user;
            request[SHRequestFromStudentKey] = [PFUser currentUser];
            request[SHRequestDescriptionKey] = @"Join the new huddle!";
            
            [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSString* channel = [NSString stringWithFormat:@"a%@",[user objectId]];
                NSString* message = [NSString stringWithFormat:@"%@ has created a new huddle and he wants you to join!",user[SHStudentNameKey]];
                NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                                      message, @"alert",
                                      @"Increment", @"badge",
                                      request,@"request",
                                      nil];
                
                PFPush *push = [[PFPush alloc] init];
                [push setChannels:[NSArray arrayWithObjects:channel, nil]];
                [push setData:data];
                [push sendPushInBackground];

            }];
            
            PFObject *huddleClass = self.huddleClassButtons.selectedButtonObject;
            [huddleClass addObject:self.huddle forKey:SHClassHuddlesKey];
            [huddleClass saveInBackground];
            
            [[PFUser currentUser] addObject:self.huddle forKey:SHStudentHuddlesKey];
            [[PFUser currentUser] saveInBackground];
        }
        
        [[SHCache sharedCache] setNewHuddle:self.huddle];
        
        SHIndividualHuddleViewController *huddleVC = [[SHIndividualHuddleViewController alloc]initWithHuddle:self.huddle];
        
        NSMutableArray* navControllers = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        [navControllers insertObject:huddleVC atIndex:navControllers.count-1];
        self.navigationController.viewControllers = navControllers;
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    
    
}

#pragma mark - SHStudentSearchDelegate

- (void)didAddMember:(PFUser *)member
{
    for(PFUser *student in self.huddleMembers){
        if([[student objectId] isEqual:[member objectId]]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @""
                                                            message: [NSString stringWithFormat:@"Huddle already has %@", member[SHStudentNameKey]]
                                                           delegate: nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.huddleMembers addObject:member];
    
    float tableY = self.tableView.frame.origin.y;
    float tableHeight = self.tableView.frame.size.height;
    [self.tableView setFrame:CGRectMake(horiBorderSpacing, tableY, contentWidth, tableHeight+SHStudentCellHeight)];
    
    scrollViewContentSize.height += SHStudentCellHeight;
    [self.scrollView setContentSize:scrollViewContentSize];
        
    [self.tableView reloadData];
    
}

@end
