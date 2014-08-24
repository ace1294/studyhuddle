//
//  SHIntro1ViewController.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 7/16/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHIntro2ViewController.h"
#import "UIColor+HuddleColors.h"

@interface SHIntro2ViewController ()

@property (strong,nonatomic) UILabel* infoLabel;

@property (strong,nonatomic) UIImageView* topLeftCircle;
@property (strong,nonatomic) UIImageView* topRightCircle;
@property (strong,nonatomic) UIImageView* bottomLeftCircle;
@property (strong,nonatomic) UIImageView* bottomRightCircle;

@property (strong,nonatomic) UILabel* topLeftLabel;
@property (strong,nonatomic) UILabel* topRightLabel;
@property (strong,nonatomic) UILabel* bottomLeftLabel;
@property (strong,nonatomic) UILabel* bottomRightLabel;





#define infoLabelVerticalOffsetFromTop 80
#define infoLabelWidth 300
#define infoLabelFont [UIFont systemFontOfSize:12]
#define subLabelsFont [UIFont systemFontOfSize: 7]
#define circlesVerticalOffsetFromInfoLabel 40
#define horizontalDistanceBetweenCircles 20
#define verticalDistanceBetweenCircles 60
#define verticalDistanceBetweenCirclesAndLabels 4

@end

@implementation SHIntro2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    //add the background
    UIImageView *bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PatternBackground.png"]];
    [self.view addSubview:bg];
    
    //info label
    self.infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - infoLabelWidth/2, infoLabelVerticalOffsetFromTop, infoLabelWidth, 300)];
    //self.infoLabel.backgroundColor = [UIColor redColor];
    self.infoLabel.text = @"Connect your classes with study huddle! Ask questions on the class thread, see which classmates are studying and invite them to study";
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    self.infoLabel.numberOfLines = 0;
    self.infoLabel.font = infoLabelFont;
    self.infoLabel.textColor = [UIColor huddleSilver];
    [self.view addSubview:self.infoLabel];
    //fix the height
    CGSize descriptionSize = [self.infoLabel.text boundingRectWithSize:CGSizeMake(infoLabelWidth, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:infoLabelFont} context:nil].size;
    CGRect infoRect = self.infoLabel.frame;
    infoRect.size.height = descriptionSize.height;
    self.infoLabel.frame = infoRect;
    
    
    
    //topleft
    self.topLeftCircle = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AddClassIntro.png"]];
    CGRect topLeftFrame = self.topLeftCircle.frame;
    topLeftFrame.origin.y = self.infoLabel.frame.origin.y + self.infoLabel.frame.size.height + circlesVerticalOffsetFromInfoLabel;
    CGFloat widthOfButtons = self.topLeftCircle.frame.size.width*2 + horizontalDistanceBetweenCircles;
    CGFloat properRightOffset = self.view.frame.size.width/2 - widthOfButtons/2;
    topLeftFrame.origin.x = properRightOffset;
    self.topLeftCircle.frame = topLeftFrame;
    [self.view addSubview:self.topLeftCircle];
    
    
    
    //topRight
    self.topRightCircle = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MessageboardIntro75.png"]];
    CGRect topRightFrame = self.topRightCircle.frame;
    topRightFrame.origin.y = self.infoLabel.frame.origin.y + self.infoLabel.frame.size.height + circlesVerticalOffsetFromInfoLabel;
    topRightFrame.origin.x = self.topLeftCircle.frame.origin.x + self.topLeftCircle.frame.size.width + horizontalDistanceBetweenCircles;
    self.topRightCircle.frame = topRightFrame;
    [self.view addSubview:self.topRightCircle];
    
    //bottomLeft
    self.bottomLeftCircle = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"OnlineIllustration75.png"]];
    CGRect bottomLeftFrame = self.bottomLeftCircle.frame;
    bottomLeftFrame.origin.y = self.topLeftCircle.frame.origin.y + self.topLeftCircle.frame.size.height + verticalDistanceBetweenCircles;
    bottomLeftFrame.origin.x = self.topLeftCircle.frame.origin.x;
    self.bottomLeftCircle.frame = bottomLeftFrame;
    [self.view addSubview:self.bottomLeftCircle];
    
    //bottomRight
    self.bottomRightCircle = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"InvitetoStudyIntro75.png"]];
    CGRect bottomRightFrame = self.bottomRightCircle.frame;
    bottomRightFrame.origin.y = self.topLeftCircle.frame.origin.y + self.topLeftCircle.frame.size.height + verticalDistanceBetweenCircles;
    bottomRightFrame.origin.x = self.bottomLeftCircle.frame.origin.x + self.bottomLeftCircle.frame.size.width + horizontalDistanceBetweenCircles;
    self.bottomRightCircle.frame = bottomRightFrame;
    [self.view addSubview:self.bottomRightCircle];
    
    //topLeftLabel
    [self setUpLabel:self.topLeftLabel withReferenceCircle:self.topLeftCircle andTitle:@"ADD CLASSES" andColor: [UIColor huddlePurple]];
    [self setUpLabel:self.topRightLabel withReferenceCircle:self.topRightCircle andTitle:@"ASK QUESTIONS ON CLASS THREAD" andColor: [UIColor huddleBlue]];
    [self setUpLabel:self.bottomLeftLabel withReferenceCircle:self.bottomLeftCircle andTitle:@"CLASSMATE ONLINE" andColor: [UIColor huddleGreen]];
    [self setUpLabel:self.bottomRightLabel withReferenceCircle:self.bottomRightCircle andTitle:@"INVITE TO STUDY" andColor: [UIColor huddleOrange]];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpLabel: (UILabel*)label withReferenceCircle: (UIImageView*) circle andTitle: (NSString*)title andColor: (UIColor*)color
{
    label = [[UILabel alloc]initWithFrame:CGRectMake(circle.frame.origin.x, circle.frame.origin.y + circle.frame.size.height + verticalDistanceBetweenCirclesAndLabels, circle.frame.size.width, 100)];
    label.numberOfLines = 0;
    label.textColor = color;
    label.text = title;
    label.font = subLabelsFont;
    //fix the height
    CGSize descriptionSize = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:subLabelsFont} context:nil].size;
    CGRect topLeftLabelRect = label.frame;
    topLeftLabelRect.size.height = descriptionSize.height;
    label.frame = topLeftLabelRect;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
