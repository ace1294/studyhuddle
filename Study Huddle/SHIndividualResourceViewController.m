//
//  SHIndividualResourceViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/6/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHIndividualResourceViewController.h"
#import "UIColor+HuddleColors.h"

@interface SHIndividualResourceViewController ()

//Headers
@property (strong, nonatomic) UILabel *titleHeaderLabel;
@property (strong, nonatomic) UILabel *linkHeaderLabel;
@property (strong, nonatomic) UILabel *descriptionHeaderLabel;

//Content
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UITextView *linkLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (strong, nonatomic) UIImageView *document;

@end

@implementation SHIndividualResourceViewController

- (id)initWithResource: (PFObject *)aResource
{
    self = [super init];
    if (self) {
        _resource = aResource;
        
        [self initHeaders];
        [self initContent];
        [self setFrames];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Inilizing methods

- (void)initHeaders
{
    
    self.titleHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, nameHeaderY, headerWidth, headerHeight)];
    [self.titleHeaderLabel setFont:[UIFont fontWithName:@"Arial"size:16]];
    [self.titleHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.titleHeaderLabel setBackgroundColor:[UIColor whiteColor]];
    [self.titleHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.titleHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.titleHeaderLabel.text = @"Name";
    [self.view addSubview:self.titleHeaderLabel];
    
    self.linkHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, linkHeaderY, headerWidth, headerHeight)];
    [self.linkHeaderLabel setFont:[UIFont fontWithName:@"Arial"size:16]];
    [self.linkHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.linkHeaderLabel setBackgroundColor:[UIColor whiteColor]];
    [self.linkHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.linkHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.linkHeaderLabel.text = @"Link";
    [self.view addSubview:self.linkHeaderLabel];
    
    self.descriptionHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, descrHeaderY, headerWidth, headerHeight)];
    [self.descriptionHeaderLabel setFont:[UIFont fontWithName:@"Arial"size:16]];
    [self.descriptionHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.descriptionHeaderLabel setBackgroundColor:[UIColor whiteColor]];
    [self.descriptionHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.descriptionHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.descriptionHeaderLabel.text = @"Description";
    [self.view addSubview:self.descriptionHeaderLabel];

}

- (void)initContent
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, resourceNameY, contentWidth, contentHeight)];
    [self.titleLabel setFont:[UIFont fontWithName:@"Arial"size:14]];
    [self.titleLabel setTextColor:[UIColor huddleSilver]];
    [self.titleLabel setBackgroundColor:[UIColor whiteColor]];
    [self.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = self.resource[SHResourceNameKey];
    [self.view addSubview:self.titleLabel];
    
    self.linkLabel = [[UITextView alloc] initWithFrame:CGRectMake(horiViewSpacing, linkY, contentWidth, contentHeight)];
    [self.linkLabel setFont:[UIFont fontWithName:@"Arial"size:14]];
    [self.linkLabel setTextAlignment:NSTextAlignmentLeft];
    [self.linkLabel setEditable:NO];
    [self.linkLabel setScrollEnabled:NO];
    [self.linkLabel setDataDetectorTypes:UIDataDetectorTypeLink];
    [self.linkLabel setText:self.resource[SHResourceLinkKey]];
    [self.view addSubview:self.linkLabel];
    
    self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, descrY, contentWidth, 200.0)];
    [self.descriptionLabel setFont:[UIFont fontWithName:@"Arial"size:14]];
    [self.descriptionLabel setTextColor:[UIColor huddleSilver]];
    [self.descriptionLabel setBackgroundColor:[UIColor whiteColor]];
    [self.descriptionLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.descriptionLabel.textAlignment = NSTextAlignmentLeft;
    self.descriptionLabel.text = self.resource[SHResourceDescriptionKey];
    [self.view addSubview:self.descriptionLabel];
    
    PFFile* documentFile = [self.resource objectForKey:SHResourceFileKey];
    UIImage* document = [UIImage imageWithData:[documentFile getData]];
    self.document = [[UIImageView alloc] initWithImage:document];
    [self.view addSubview:self.document];
    
}

- (void)setFrames
{
    CGSize descriptionSize = [self.descriptionLabel.text boundingRectWithSize:CGSizeMake(contentWidth, CGFLOAT_MAX)
                                                                options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                             attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:14]}
                                                                context:nil].size;
    [self.descriptionLabel setFrame:CGRectMake(horiViewSpacing, descrY, descriptionSize.width, descriptionSize.height)];
    [self.document setFrame:CGRectMake(horiViewSpacing, descrY+descriptionSize.height+vertViewSpacing, contentWidth, 300)];
}

@end
