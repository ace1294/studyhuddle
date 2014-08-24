//
//  SHIntro1ViewController.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 7/16/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHIntro3ViewController.h"
#import "UIColor+HuddleColors.h"

@interface SHIntro3ViewController ()

@property (strong,nonatomic) UILabel* infoLabel;

@property (strong,nonatomic) UIImageView* middleCircle;
@property (strong,nonatomic) UIImageView* leftCircle;
@property (strong,nonatomic) UIImageView* rightCircle;
@property (strong,nonatomic) UIImageView* centerCircle;

@property (strong,nonatomic) UIImageView* leftBottomCircle;
@property (strong,nonatomic) UIImageView* middleBottomCircle;
@property (strong,nonatomic) UIImageView* rightBottomCircle;

@property (strong,nonatomic) UILabel* middleCircleLabel;
@property (strong,nonatomic) UILabel* leftCircleLabel;
@property (strong,nonatomic) UILabel* rightCircleLabel;
@property (strong,nonatomic) UILabel* leftLabel;
@property (strong,nonatomic) UILabel* middleLabel;
@property (strong,nonatomic) UILabel* rightLabel;

@property (strong,nonatomic) UILabel* swipeToContinueLabel;






#define infoLabelVerticalOffsetFromTop 80
#define infoLabelWidth 300
#define infoLabelFont [UIFont systemFontOfSize:12]
#define subLabelsFont [UIFont systemFontOfSize: 7]
#define trifectaDistance 30

#define circlesVerticalOffsetFromInfoLabel 10
#define horizontalDistanceBetweenCircles 20
#define verticalDistanceBetweenCircles 60
#define verticalDistanceBetweenCirclesAndLabels 2
#define verticalDistanceBetweenTrifectaAndBottomCircles 30

#define swipeWidth 300
#define swipeHeight 30
#define swipeVerticalOffset 20

@end

@implementation SHIntro3ViewController

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
    self.infoLabel.text = @"You and up to 9 other students can create a 'study huddle' aka a study group. Motivate eachother to study, ask question on class concepts, and share resources/tutorials with your huddle";
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
    
    
    
    //topMiddle
    self.middleCircle = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"OfflineIllustration50.png"]];
    CGRect tempFrame = self.middleCircle.frame;
    tempFrame.origin.y = self.infoLabel.frame.origin.y + self.infoLabel.frame.size.height + circlesVerticalOffsetFromInfoLabel;
    tempFrame.origin.x = self.view.frame.size.width/2 - tempFrame.size.width/2;
    self.middleCircle.frame = tempFrame;
    [self.view addSubview:self.middleCircle];
    
    //center
    self.centerCircle  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"HuddleLogoIntro.png"]];
    tempFrame = self.centerCircle.frame;
    tempFrame.origin.y = self.middleCircle.frame.origin.y + self.middleCircle.frame.size.height + trifectaDistance;
    tempFrame.origin.x = self.view.frame.size.width/2 - tempFrame.size.width/2;
    self.centerCircle.frame = tempFrame;
    [self.view addSubview:self.centerCircle];
    
    float equalDist = trifectaDistance + self.centerCircle.frame.size.height/2 + self.middleCircle.frame.size.height/2;
    //CGFloat c = equalDist - (trifectaDistance*1.414);
    float h = equalDist/1.414;
    
    //left
    self.leftCircle  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"OfflineIllustration50.png"]];
    tempFrame = self.leftCircle.frame;
    tempFrame.origin.y = self.centerCircle.frame.origin.y + self.centerCircle.frame.size.height - self.centerCircle.frame.size.height/2 + h - self.leftCircle.frame.size.height/2;
    tempFrame.origin.x = self.centerCircle.frame.origin.x + self.centerCircle.frame.size.width/2  - h - self.leftCircle.frame.size.width/2;
    self.leftCircle.frame = tempFrame;
    [self.view addSubview:self.leftCircle];
    
    //right
    self.rightCircle  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"OfflineIllustration50.png"]];
    tempFrame = self.rightCircle.frame;
    tempFrame.origin.y = self.leftCircle.frame.origin.y;
    tempFrame.origin.x = self.centerCircle.frame.origin.x  + self.centerCircle.frame.size.width - self.centerCircle.frame.size.width/2  + h - self.leftCircle.frame.size.width/2;
    self.rightCircle.frame = tempFrame;
    [self.view addSubview:self.rightCircle];
    
    //the bottom thingies
    self.leftBottomCircle = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"InvitetoStudyIntro50.png"]];
    tempFrame = self.leftBottomCircle.frame;
    tempFrame.origin.y = self.leftCircle.frame.origin.y + verticalDistanceBetweenTrifectaAndBottomCircles + self.leftCircle.frame.size.height;
    float bottomButtonWidth = tempFrame.size.width*3 + horizontalDistanceBetweenCircles*2;
    tempFrame.origin.x = self.view.frame.size.width/2 - bottomButtonWidth/2;
    self.leftBottomCircle.frame = tempFrame;
    [self.view addSubview:self.leftBottomCircle];
    
    self.middleBottomCircle = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MessageboardIntro50.png"]];
    tempFrame = self.middleBottomCircle.frame;
    tempFrame.origin.y = self.leftBottomCircle.frame.origin.y;
    tempFrame.origin.x = self.leftBottomCircle.frame.origin.x + self.leftBottomCircle.frame.size.width + horizontalDistanceBetweenCircles;
    self.middleBottomCircle.frame = tempFrame;
    [self.view addSubview:self.middleBottomCircle];
    
    self.rightBottomCircle = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AddResourceIntro.png"]];
    tempFrame = self.rightBottomCircle.frame;
    tempFrame.origin.y = self.middleBottomCircle.frame.origin.y;
    tempFrame.origin.x = self.middleBottomCircle.frame.origin.x + self.middleBottomCircle.frame.size.width + horizontalDistanceBetweenCircles;
    self.rightBottomCircle.frame = tempFrame;
    [self.view addSubview:self.rightBottomCircle];
    
    
    [self setUpLabel:self.middleCircleLabel withReferenceCircle:self.middleCircle andTitle:@"YOU" andColor:[UIColor huddleSilver]];
    [self setUpLabel:self.leftCircleLabel withReferenceCircle:self.leftCircle andTitle:@"CLASSMATE" andColor:[UIColor huddleSilver]];
    [self setUpLabel:self.rightCircleLabel withReferenceCircle:self.rightCircle andTitle:@"CLASSMATE" andColor:[UIColor huddleSilver]];
    [self setUpLabel:self.leftLabel withReferenceCircle:self.leftBottomCircle andTitle:@"INVITE TO STUDY" andColor:[UIColor huddleOrange]];
    [self setUpLabel:self.middleLabel withReferenceCircle:self.middleBottomCircle andTitle:@"HUDDLE THREAD" andColor:[UIColor huddleBlue]];
    [self setUpLabel:self.leftLabel withReferenceCircle:self.rightBottomCircle andTitle:@"ADD RESOURCE" andColor:[UIColor huddleCharcoal]];
    
    
    //the swipe thingy
    self.swipeToContinueLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-swipeWidth/2, self.middleBottomCircle.frame.origin.y + self.middleBottomCircle.frame.size.height + verticalDistanceBetweenCirclesAndLabels + swipeVerticalOffset + 20, swipeWidth, swipeHeight)];
    self.swipeToContinueLabel.text = @"Swipe right to begin!";
    self.swipeToContinueLabel.textColor = [UIColor huddleGreen];
    self.swipeToContinueLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.swipeToContinueLabel];
    
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
