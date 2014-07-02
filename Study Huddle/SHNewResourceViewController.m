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

@interface SHNewResourceViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UILabel *createResourceHeaderLabel;
@property (strong, nonatomic) UILabel *aboutHeaderLabel;
@property (strong, nonatomic) UILabel *descriptionHeaderLabel;
@property (strong, nonatomic) UILabel *categoryHeaderLabel;

@property (strong, nonatomic) UITextField *resourceTitleField;
@property (strong, nonatomic) UITextField *resourceLinkField;
@property (strong, nonatomic) UILabel *pictureLabel;
@property (strong, nonatomic) SHPortraitView *resourcePortrait;
@property (strong, nonatomic) UITextView *descriptionTextView;

@property (strong, nonatomic) UIButton *createButton;
@property (strong, nonatomic) UIButton *cancelButton;


@property (strong, nonatomic) PFObject *huddle;
@property (strong, nonatomic) NSMutableArray *categories;
@property (strong, nonatomic) NSMutableDictionary *categoryButtons;


@property BOOL pictureSet;

@end

@implementation SHNewResourceViewController

float modalFrameHeight;

- (id)initWithHuddle:(PFObject *)aHuddle
{
    self = [super init];
    if (self) {
        _huddle = aHuddle;
        
        modalFrameHeight = 380;
        
        self.view.clipsToBounds = YES;
        [self.view setBackgroundColor:[UIColor colorWithWhite:.9 alpha:1]];
        self.view.layer.cornerRadius = 3;
        [self.view setFrame:CGRectMake(0.0, 0.0, 270.0, modalFrameHeight)];
        
        
        [self initHeaders];
        [self initFields];
        [self initButtons];
        [self initCategories];
        
        

        
        
        
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setCategoryButtonFrames];
}

- (void)initHeaders
{
    //Resource Header
    self.createResourceHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, newResourceWidth, headerHeight)];
    [self.createResourceHeaderLabel setFont:[UIFont fontWithName:@"Arial-BoldMT"size:14]];
    [self.createResourceHeaderLabel setTextColor:[UIColor whiteColor]];
    [self.createResourceHeaderLabel setBackgroundColor:[UIColor huddleOrange]];
    [self.createResourceHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.createResourceHeaderLabel.textAlignment = NSTextAlignmentCenter;
    [self setMaskTo:self.createResourceHeaderLabel byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight];
    self.createResourceHeaderLabel.text = @"New Resource";
    [self.view addSubview:self.createResourceHeaderLabel];

    //Description Header
    self.aboutHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, aboutHeaderY, headerWidth, headerHeight)];
    [self.aboutHeaderLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    [self.aboutHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.aboutHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.aboutHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.aboutHeaderLabel.text = @"ABOUT";
    [self.view addSubview:self.aboutHeaderLabel];
    
    //Description Header
    self.descriptionHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, descriptionHeaderY, headerWidth, headerHeight)];
    [self.descriptionHeaderLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    [self.descriptionHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.descriptionHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.descriptionHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.descriptionHeaderLabel.text = @"DESCRIPTION";
    [self.view addSubview:self.descriptionHeaderLabel];

    //Category Header
    self.categoryHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing,categoryHeaderY, headerWidth, headerHeight)];
    [self.categoryHeaderLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    [self.categoryHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.categoryHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.categoryHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.categoryHeaderLabel.text = @"SELECT CATEGORY";
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
    
    //Resource Picture Background
    self.pictureLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, documentY, documentWidth, documentHeight)];
    [self.pictureLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    [self.pictureLabel setBackgroundColor:[UIColor whiteColor]];
    [self.pictureLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.pictureLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.pictureLabel];
    
    //Description Text View
    self.descriptionTextView = [[UITextView alloc]initWithFrame:CGRectMake(horiViewSpacing, descriptionY, descriptionWidth, descriptionHeight)];
    self.descriptionTextView.layer.cornerRadius = 2;
    [self.view addSubview:self.descriptionTextView];
}

- (void)initButtons
{
    //Add Picture
    //self.resourcePortrait = [[SHPortraitView alloc] initWithFrame:CGRectMake(horiViewSpacing, sectionHeight+vertBorderSpacing, addPictureButtonDimX, addPictureButtonDimY)];
    [self.resourcePortrait setBackgroundColor:[UIColor clearColor]];
    [self.resourcePortrait setOpaque:YES];
    [self.resourcePortrait.profileButton addTarget:self action:@selector(choosePicture:) forControlEvents:UIControlEventTouchDragInside];
    [self.resourcePortrait setCamera];
    [self.view addSubview:self.resourcePortrait];
    
    
    //Create
    //self.createButton = [[UIButton alloc]initWithFrame:CGRectMake(230.0, vertBorderSpacing, 45.0, 30.0)];
    [self.createButton setTitle:@"Create" forState:UIControlStateNormal];
    [self.createButton setBackgroundColor:[UIColor huddleOrange]];
    self.createButton.layer.cornerRadius = 3;
    [self.createButton.titleLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
    [self.createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.createButton addTarget:self action:@selector(choosePicture:) forControlEvents:UIControlEventTouchUpInside];
    //Border
    [[self.createButton  layer] setBorderWidth:1.0f];
    [[self.createButton  layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [self.view addSubview:self.createButton];
    
    //Create
    //self.cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(horiBorderSpacing, vertBorderSpacing, 45.0, 30.0)];
    [self.cancelButton setBackgroundColor:[UIColor huddleOrange]];
    self.cancelButton.layer.cornerRadius = 3;
    self.cancelButton.imageView.image = [UIImage imageNamed:@"X_cancelbtn@2x.png"];
    [self.cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
    
}

- (void)initCategories
{
    self.categories = [self.huddle objectForKey:SHHuddleResourcesKey];
    self.categoryButtons = [[NSMutableDictionary alloc]init];
    NSString *category;
    
    for(int i = 0; i < [self.categories count] +1; i++)
    {
        
        
        UIButton *button = [[UIButton alloc]init];
        [self.categoryButtons setObject:button forKey:[NSNumber numberWithInt:i]];
        
        button.tag = i;
        [button.titleLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor huddleOrange] forState:UIControlStateNormal];
        
        if(i == [self.categories count]){
            [button setTitle:@"New Category" forState:UIControlStateNormal];
        }
        else{
            category = self.categories[i];
            [button setTitle:category forState:UIControlStateNormal];
        }
        
        [button addTarget:self action:@selector(categoryPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
    }
    
}

- (void)setCategoryButtonFrames
{
    int i = 0;
    
    for(NSNumber *tag in self.categoryButtons)
    {
        UIButton *button = [self.categoryButtons objectForKey:tag];
        //Long button on buttom
        if((([tag intValue]+1) == [self.categoryButtons count]) && ([self.categoryButtons count]%2 == 1)){
            [button setFrame:CGRectMake(buttonX,buttonY+buttonHeight*(i/2), buttonWidth*2, buttonHeight)];
            [self setMaskTo:button byRoundingCorners:UIRectCornerBottomRight|UIRectCornerBottomLeft];
            continue;
        }
        
        button.clipsToBounds = YES;
        [button setFrame:CGRectMake(buttonX+buttonWidth*(i%2),buttonY+buttonHeight*(i/2), buttonWidth, buttonHeight)];
        
        if(i == 0){
            [self setMaskTo:button byRoundingCorners:UIRectCornerTopLeft];
        }
        else if (i == 1)
            [self setMaskTo:button byRoundingCorners:UIRectCornerTopRight];
        
        if((i+1) == [self.categoryButtons count]-1 && i!=1)
            [self setMaskTo:button byRoundingCorners:UIRectCornerBottomLeft];
        else if((i+1) == [self.categoryButtons count])
            [self setMaskTo:button byRoundingCorners:UIRectCornerBottomRight];
        else{
            if(i%2 == 0)
                button.selectiveBorderFlag = AUISelectiveBordersFlagBottom | AUISelectiveBordersFlagRight;
            else
                button.selectiveBorderFlag = AUISelectiveBordersFlagBottom;
            button.selectiveBordersColor = [UIColor colorWithWhite:.9 alpha:1];
            button.selectiveBordersWidth = 1.0;
            
        }
        i++;
    }
    

}

- (void)categoryPressed:(id)sender
{
//    int buttonNumber = [sender tag];
//    UIButton *selectedButton = [self.categoryButtons objectForKey:[NSNumber numberWithInt:buttonNumber]];
//    
//    self.className = selectedButton.titleLabel.text;
//    
//    [selectedButton setBackgroundColor:[UIColor huddleOrange]];
//    [selectedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    
//    for(NSNumber *tag in self.classButtons)
//    {
//        if(tag == [NSNumber numberWithInt:buttonNumber])
//            continue;
//        UIButton *button = [self.classButtons objectForKey:tag];
//        [button setBackgroundColor:[UIColor whiteColor]];
//        [button setTitleColor:[UIColor huddleOrange] forState:UIControlStateNormal];
//    }
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








- (void)choosePicture:(id)sender
{
    
}

- (void)cancel
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
}

@end
