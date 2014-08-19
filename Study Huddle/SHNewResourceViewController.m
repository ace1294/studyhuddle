//
//  SHNewResourceViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/29/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHNewResourceViewController.h"
#import "UIColor+HuddleColors.h"
#import "SHConstants.h"
#import "SHPortraitView.h"
#import "UIViewController+MJPopupViewController.h"
#import "UIView+AUISelectiveBorder.h"
#import "SHDocumentView.h"
#import "SHHuddleButtons.h"
#import "SHUtility.h"
#import "SHModalViewController.h"
#import "SHCache.h"

@interface SHNewResourceViewController () <UITextFieldDelegate, SHHuddleButtonsDelegate, UITextViewDelegate>

@property (strong, nonatomic) UILabel *aboutHeaderLabel;
@property (strong, nonatomic) UILabel *descriptionHeaderLabel;
@property (strong, nonatomic) UILabel *categoryHeaderLabel;

@property (strong, nonatomic) UITextField *resourceTitleField;
@property (strong, nonatomic) UITextField *resourceLinkField;
@property (strong, nonatomic) SHDocumentView *documentView;
@property (strong, nonatomic) SHPortraitView *resourcePortrait;
@property (strong, nonatomic) UITextView *descriptionTextView;



@property (strong, nonatomic) PFObject *huddle;
@property (strong, nonatomic) NSMutableDictionary *categoryObjects;

@property (strong, nonatomic) SHHuddleButtons *categoryButtons;

//@property (strong, nonatomic) NSMutableDictionary *categoryButtons;
@property (strong, nonatomic) UITextField *addCategoryField;

@property (strong, nonatomic) NSDate *time;


@property BOOL pictureSet;
@property BOOL addCategorySet;

@end

@implementation SHNewResourceViewController


- (id)initWithHuddle:(PFObject *)aHuddle
{
    self = [super init];
    if (self) {
        _huddle = aHuddle;
        NSArray *categoryNames = [SHUtility namesForObjects:[[SHCache sharedCache] resourceCategoriesForHuddle:_huddle] withKey:SHResourceCategoryNameKey];
        self.categoryObjects = [[NSMutableDictionary alloc] initWithObjects:[[SHCache sharedCache] resourceCategoriesForHuddle:_huddle] forKeys:categoryNames];
        
        self.modalFrameHeight = categoryHeaderY+headerHeight+vertViewSpacing;
        
        [self.view setFrame:CGRectMake(0.0, 0.0, modalWidth, self.modalFrameHeight)];
        self.addCategorySet = false;
        
        
        [self initHeaders];
        [self initFields];
        [self initButtons];

        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.documentView.root = self.owner;
}

- (void)initHeaders
{
    //Resource Header
    self.headerLabel.text = @"New Resource";
    [self.continueButton setTitle:@"Add" forState:UIControlStateNormal];

    //Description Header
    self.aboutHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, aboutHeaderY, headerWidth, headerHeight)];
    [self.aboutHeaderLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    [self.aboutHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.aboutHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.aboutHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.aboutHeaderLabel.text = @"About";
    [self.view addSubview:self.aboutHeaderLabel];
    
    //Description Header
    self.descriptionHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, descriptionHeaderY, headerWidth, headerHeight)];
    [self.descriptionHeaderLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    [self.descriptionHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.descriptionHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.descriptionHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.descriptionHeaderLabel.text = @"Description";
    [self.view addSubview:self.descriptionHeaderLabel];

    //Category Header
    self.categoryHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing,categoryHeaderY, headerWidth, headerHeight)];
    [self.categoryHeaderLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    [self.categoryHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.categoryHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.categoryHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.categoryHeaderLabel.text = @"Select Category";
    [self.view addSubview:self.categoryHeaderLabel];
}

-(void)initFields
{
    //Resource Title
    self.resourceTitleField = [[UITextField alloc] initWithFrame:CGRectMake(fieldX, resourceNameY, fieldWidth, fieldHeight)];
    [self.resourceTitleField setFont:[UIFont fontWithName:@"Arial" size:14]];
    self.resourceTitleField.layer.cornerRadius = 3;
    [self.resourceTitleField setBackgroundColor:[UIColor whiteColor]];
    [self.resourceTitleField setPlaceholder:@"Resource Name"];
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [self.resourceTitleField setLeftViewMode:UITextFieldViewModeAlways];
    [self.resourceTitleField setLeftView:spacerView];
    [self.view addSubview:self.resourceTitleField];
    
    //Resource Link
    self.resourceLinkField = [[UITextField alloc] initWithFrame:CGRectMake(fieldX, resourceLinkY, fieldWidth, fieldHeight)];
    [self.resourceLinkField setFont:[UIFont fontWithName:@"Arial" size:14]];
    [self.resourceLinkField setBackgroundColor:[UIColor whiteColor]];
    self.resourceLinkField.layer.cornerRadius = 3;
    [self.resourceLinkField setPlaceholder:@"Resource Link"];
    UIView *spacerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [self.resourceLinkField setLeftViewMode:UITextFieldViewModeAlways];
    [self.resourceLinkField setLeftView:spacerview];
    [self.view addSubview:self.resourceLinkField];
    
    //Description Text View
    self.descriptionTextView = [[UITextView alloc]initWithFrame:CGRectMake(horiViewSpacing, descriptionY, descriptionWidth, descriptionHeight)];
    self.descriptionTextView.layer.cornerRadius = 2;
    self.descriptionTextView.delegate = self;
    [self.view addSubview:self.descriptionTextView];
    
    //New Category
    //Resource Link
    self.addCategoryField = [[UITextField alloc] initWithFrame:CGRectMake(fieldX, resourceLinkY, fieldWidth, fieldHeight)];
    [self.addCategoryField setFont:[UIFont fontWithName:@"Arial" size:14]];
    [self.addCategoryField setBackgroundColor:[UIColor clearColor]];
    self.addCategoryField.layer.cornerRadius = 3;
    [self.addCategoryField setPlaceholder:@"New Category"];
    UIView *cspacerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [self.addCategoryField setLeftViewMode:UITextFieldViewModeAlways];
    [self.addCategoryField setLeftView:cspacerview];
    self.addCategoryField.alpha = 0;
    self.addCategoryField.userInteractionEnabled = FALSE;
    self.addCategoryField.delegate = self;
    [self.view addSubview:self.addCategoryField];
}

- (void)initButtons
{
    [super initButtons];
    
    //Document
    self.documentView = [[SHDocumentView alloc] initWithFrame:CGRectMake(horiViewSpacing, documentY, documentWidth, documentHeight)];
    self.documentView.owner = self.parentViewController;
   
    [self.view addSubview:self.documentView];

    CGRect initialButton = CGRectMake(buttonX, buttonY, huddleButtonWidth, huddleButtonHeight);
    self.categoryButtons = [[SHHuddleButtons alloc] initWithFrame:initialButton items:self.categoryObjects addButton:@"New Category"];
    self.categoryButtons.delegate = self;
    [self.categoryButtons setViewController:self];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.createResourceLabel setFrame:CGRectMake(0.0, vertBorderSpacing, newResourceWidth, 30.0)];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
    
}


-(void) setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners
{
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(3.0, 3.0)];
    
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    view.layer.mask = shape;
}
//[self.huddle saveInBackground];
//}

#pragma mark - Text View Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqual:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


#pragma mark - Super Class

- (void)continueAction
{
    PFObject *selectedCategory = self.categoryButtons.selectedButtonObject;
    
    if (!selectedCategory) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Missing Info"
                                                        message: @"Must select a category"
                                                       delegate: nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    PFObject *newResource = [PFObject objectWithClassName:SHResourceParseClass];
    newResource[SHResourceNameKey] = self.resourceTitleField.text;
    newResource[SHResourceHuddleKey] = self.huddle;
    newResource[SHResourceCreatorKey] = [PFUser currentUser];
    newResource[SHResourceDescriptionKey] = self.descriptionTextView.text;
    newResource[SHResourceLinkKey] = self.resourceLinkField.text;
    NSData *fileData = UIImageJPEGRepresentation(self.documentView.documentImageView.image, 1.0f);
    newResource[SHResourceFileKey] = [PFFile fileWithData:fileData];
    
    //POSSIBLY DO IN BACKGROUND
    
    if(self.categoryButtons.addButtonSet){
        [newResource save];
        
        PFObject *newCategory = [PFObject objectWithClassName:SHResourceCategoryParseClass];
        
        newCategory[SHResourceCategoryNameKey] = [self.categoryButtons.selectedButtonObject parseClassName];
        newCategory[SHResourceCategoryHuddleKey] = self.huddle;
        newCategory[SHResourceCategoryResourcesKey] = @[newResource];
        newResource[SHResourceCategoryKey] = newCategory;
        
        [self.huddle addObject:newCategory forKey:SHHuddleResourceCategoriesKey];
        
        [PFObject saveAll:@[self.huddle,newCategory,newResource]];
    }
    else{
        [selectedCategory addObject:newResource forKey:SHResourceCategoryResourcesKey];
        
        newResource[SHResourceCategoryKey] = selectedCategory;
        
        [PFObject saveAll:@[selectedCategory,newResource]];
    }
    
    [self cancelAction];
    
    NSArray *members = [[SHCache sharedCache]membersForHuddle:self.huddle];
    
    for(PFUser *member in members)
    {
        if ([[member objectId] isEqual:[[PFUser currentUser] objectId]])
            continue;
        
        PFObject *memberNotification = [PFObject objectWithClassName:SHNotificationParseClass];
        
        [member fetchIfNeeded];
        memberNotification[SHNotificationToStudentKey] = member;
        memberNotification[SHNotificationTitleKey] = self.huddle[SHHuddleNameKey];
        memberNotification[SHNotificationTypeKey] = SHNotificationNewResourceType;
        memberNotification[SHNotificationHuddleKey] = self.huddle;
        
        NSString *description = [NSString stringWithFormat:@"%@ added a new resource", [PFUser currentUser][SHStudentNameKey]];
        memberNotification[SHNotificationDescriptionKey] = description;
        
        [memberNotification saveInBackground];
    }
    
}


@end
