//
//  SHStudyViewController.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/8/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHStudyViewController.h"
#import "UIColor+HuddleColors.h"
#import "SHEditStudyViewController.h"
#import "UIViewController+MJPopupViewController.h"

@interface SHStudyViewController () <SHModalViewControllerDelegate>

//Headers
@property (strong, nonatomic) UILabel *dateHeaderLabel;
@property (strong, nonatomic) UILabel *timeStudiedHeaderLabel;
@property (strong, nonatomic) UILabel *subjectHeaderLabel;
@property (strong, nonatomic) UILabel *descriptionHeaderLabel;

//Content
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *timeStudiedLabel;
@property (strong, nonatomic) UILabel *subjectLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;

//Edit
@property (strong, nonatomic) UIBarButtonItem *editButton;
@property (strong, nonatomic) SHEditStudyViewController *editVC;

@end

@implementation SHStudyViewController

#define dateHeaderY 80.0
#define timeStudiedHeaderY 130.0
#define subjectHeaderY 180.0
#define descriptionHeaderY 230.0

#define dateY dateHeaderY+headerHeight
#define timeStudiedY timeStudiedHeaderY+headerHeight
#define subjectY subjectHeaderY+headerHeight
#define descriptionY descriptionHeaderY+headerHeight

#define contentWidth 290.0
#define contentHeight 25.0

- (id)initWithStudy:(PFObject *)aStudy
{
    self = [super init];
    if (self){
        _study = aStudy;
        
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
    
    self.dateHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, dateHeaderY, headerWidth, headerHeight)];
    [self.dateHeaderLabel setFont:[UIFont fontWithName:@"Arial"size:16]];
    [self.dateHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.dateHeaderLabel setBackgroundColor:[UIColor whiteColor]];
    [self.dateHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.dateHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.dateHeaderLabel.text = @"Date:";
    [self.view addSubview:self.dateHeaderLabel];
    
    self.timeStudiedHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, timeStudiedHeaderY, headerWidth, headerHeight)];
    [self.timeStudiedHeaderLabel setFont:[UIFont fontWithName:@"Arial"size:16]];
    [self.timeStudiedHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.timeStudiedHeaderLabel setBackgroundColor:[UIColor whiteColor]];
    [self.timeStudiedHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.timeStudiedHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.timeStudiedHeaderLabel.text = @"Time Studied:";
    [self.view addSubview:self.timeStudiedHeaderLabel];
    
    self.subjectHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, subjectHeaderY, headerWidth, headerHeight)];
    [self.subjectHeaderLabel setFont:[UIFont fontWithName:@"Arial"size:16]];
    [self.subjectHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.subjectHeaderLabel setBackgroundColor:[UIColor whiteColor]];
    [self.subjectHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.subjectHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.subjectHeaderLabel.text = @"Subject:";
    [self.view addSubview:self.subjectHeaderLabel];
    
    
    self.descriptionHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, descriptionHeaderY, headerWidth, headerHeight)];
    [self.descriptionHeaderLabel setFont:[UIFont fontWithName:@"Arial"size:16]];
    [self.descriptionHeaderLabel setTextColor:[UIColor huddleSilver]];
    [self.descriptionHeaderLabel setBackgroundColor:[UIColor whiteColor]];
    [self.descriptionHeaderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.descriptionHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.descriptionHeaderLabel.text = @"Description:";
    [self.view addSubview:self.descriptionHeaderLabel];
    
}

- (void)initContent
{
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, dateY, contentWidth, contentHeight)];
    [self.dateLabel setFont:[UIFont fontWithName:@"Arial"size:14]];
    [self.dateLabel setTextColor:[UIColor huddleSilver]];
    [self.dateLabel setBackgroundColor:[UIColor clearColor]];
    [self.dateLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.dateLabel.textAlignment = NSTextAlignmentLeft;
    
    NSDate *studyDate = [self.study objectForKey:SHStudyStartKey];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM/dd/yy"];
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Arial" size:14] forKey:NSFontAttributeName];
    NSMutableAttributedString *dateString = [[NSMutableAttributedString alloc] initWithString:[formatter stringFromDate:studyDate] attributes:arialDict];
    [formatter setDateFormat:@"EEEE"];
    NSMutableAttributedString *dayString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" - %@", [formatter stringFromDate:studyDate]] attributes:arialDict];
    self.navigationItem.title = [formatter stringFromDate:studyDate];
    [dateString appendAttributedString:dayString];
    
    [dateString addAttribute:NSForegroundColorAttributeName
                       value:[UIColor huddleOrange]
                       range:NSMakeRange(0,[dateString length])];
    
    self.dateLabel.attributedText = dateString;
    [self.view addSubview:self.dateLabel];
    
    self.timeStudiedLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, timeStudiedY, contentWidth, headerHeight)];
    [self.timeStudiedLabel setFont:[UIFont fontWithName:@"Arial"size:14]];
    [self.timeStudiedLabel setTextColor:[UIColor huddleOrange]];
    [self.timeStudiedLabel setBackgroundColor:[UIColor clearColor]];
    [self.timeStudiedLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.timeStudiedLabel.textAlignment = NSTextAlignmentLeft;
    NSTimeInterval time = [self.study[SHStudyEndKey] timeIntervalSinceDate:self.study[SHStudyStartKey]];
    self.timeStudiedLabel.text = [self stringFromTimeInterval:time];
    [self.view addSubview:self.timeStudiedLabel];
    
    self.subjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, subjectY, contentWidth, headerHeight)];
    [self.subjectLabel setFont:[UIFont fontWithName:@"Arial"size:14]];
    [self.subjectLabel setTextColor:[UIColor huddleOrange]];
    [self.subjectLabel setBackgroundColor:[UIColor clearColor]];
    [self.subjectLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.subjectLabel.textAlignment = NSTextAlignmentLeft;
    self.subjectLabel.text = [self stringFromClassesArray:self.study[SHStudyClassesKey]];
    [self.view addSubview:self.subjectLabel];
    
    self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(horiViewSpacing, descriptionY, contentWidth, 200.0)];
    [self.descriptionLabel setFont:[UIFont fontWithName:@"Arial"size:14]];
    [self.descriptionLabel setTextColor:[UIColor huddleOrange]];
    [self.descriptionLabel setBackgroundColor:[UIColor clearColor]];
    [self.descriptionLabel setLineBreakMode:NSLineBreakByWordWrapping];
    self.descriptionLabel.textAlignment = NSTextAlignmentLeft;
    self.descriptionLabel.text = self.study[SHStudyDescriptionKey];
    [self.view addSubview:self.descriptionLabel];
    
    //Edit Button
    self.editButton = [[UIBarButtonItem alloc]
                     initWithTitle:@"Edit"
                     style:UIBarButtonItemStyleBordered
                     target:self
                     action:@selector(editButtonAction)];
    self.navigationItem.rightBarButtonItem = self.editButton;
}

- (void)setFrames
{
    CGSize subjectSize = [self.subjectLabel.text boundingRectWithSize:CGSizeMake(contentWidth, CGFLOAT_MAX)
                                                                      options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                                   attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:14]}
                                                                      context:nil].size;
    [self.descriptionLabel setFrame:CGRectMake(horiViewSpacing, subjectY, subjectSize.width, subjectSize.height)];
    
    CGSize descriptionSize = [self.descriptionLabel.text boundingRectWithSize:CGSizeMake(contentWidth, CGFLOAT_MAX)
                                                                      options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                                   attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:14]}
                                                                      context:nil].size;
    [self.descriptionLabel setFrame:CGRectMake(horiViewSpacing, descriptionY, descriptionSize.width, descriptionSize.height)];
}

- (void)editButtonAction
{
    self.editVC = [[SHEditStudyViewController alloc] initWithStudy:self.study];
    self.editVC.delegate = self;
    self.editVC.descriptionTextView.text = self.study[SHStudyDescriptionKey];
    
    [self presentPopupViewController:self.editVC animationType:MJPopupViewAnimationSlideBottomBottom];
    

}


#pragma mark - Popup delegate methods

- (void)continueTapped
{
    self.descriptionLabel.text = self.editVC.descriptionTextView.text;
    self.subjectLabel.text = [self.editVC.subjectButtons.selectedButtons componentsJoinedByString:@", "];
    
    [self setFrames];
}


#pragma mark - Helpers

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval
{
    NSMutableString *time = [[NSMutableString alloc]init];
    NSInteger ti = (NSInteger)interval;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    
    if(hours > 0){
        [time appendString:[NSString stringWithFormat:@"%ld Hours ", (long)hours]];
    }
    [time appendString:[NSString stringWithFormat:@"%ld Minutes ", (long)minutes]];
    
    return time;
}

- (NSMutableString *)stringFromClassesArray:(NSArray *)classes
{
    NSMutableString *classList = [[NSMutableString alloc]init];
    int i = 0;
    
    
    for(PFObject *class in classes)
    {
        [class fetchIfNeeded];
        
        [classList appendString:class[SHClassShortNameKey]];
        if (i+1<[classes count]) {
            [classList appendString:@", "];
        }
        
        i++;
    }
    
    return classList;
}

@end
