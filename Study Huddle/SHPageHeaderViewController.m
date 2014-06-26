//
//  SHPageHeaderViewController.m
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 6/14/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHPageHeaderViewController.h"
#import "UIColor+HuddleColors.h"



#define schoolLabelWidth 85
#define schoolLabelHeight 21
#define schoolLabelFont [UIFont systemFontOfSize:7]


#define middleLabelWidth 85
#define middleLabelHeight 21
#define middleLabelFont [UIFont systemFontOfSize:7]


#define hoursStudiedLabelWidth 85
#define hoursStudiedLabelHeight 21
#define hoursStudiedLabelFont [UIFont systemFontOfSize:7]


#define nameLabelWidth 150
#define nameLabelHeight 21
#define nameLabelFont [UIFont systemFontOfSize:17]


#define profileImageWidth 100
#define profileImageHeight 100

#define editProfileButtonWidth 50
#define editProfileButtonHeight 10
#define editPorifleButtonVerticalOffsetFromTop 10
#define editProfileButtonFont [UIFont systemFontOfSize:7]
#define editProfileButtonColor [UIColor whiteColor]
#define editProfileCornerRadius 1


#define profileImageVerticalOffsetFromTop 10
#define nameLabelVerticalOffsetFromImage 10
#define infoLabelsVerticalOffsetFromNameLabel 1
#define horizontalOffsetFromEdge 30



@interface SHPageHeaderViewController ()

@end

@implementation SHPageHeaderViewController

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
    // Do any additional setup after loading the view.
    
    
    //[self doLayout];
    
    
    
}



-(void)doLayout
{
    Student* currentUser = [Student currentUser];
    
    float centerX = self.view.bounds.origin.x + self.view.bounds.size.width/2;
    
    UIImage* defaultImage = [UIImage imageNamed:@"placeholderProfPic.png"];
    
    
    self.profileImage = [[SHProfilePortraitView alloc]initWithImage:defaultImage andFrame:CGRectMake(centerX - profileImageWidth/2 , profileImageVerticalOffsetFromTop, profileImageWidth, profileImageHeight)  ];
    
   // self.profileImage = [[SHPageImageView alloc]initWithFrame:CGRectMake(centerX - profileImageWidth/2 , profileImageVerticalOffsetFromTop, profileImageWidth, profileImageHeight)];
    self.profileImage.owner = self;
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(centerX - nameLabelWidth/2, self.profileImage.frame.origin.y + self.profileImage.frame.size.height + nameLabelVerticalOffsetFromImage, nameLabelWidth, nameLabelHeight)];
    self.nameLabel.text = currentUser.fullName;
    [self.nameLabel setFont:nameLabelFont];
    [self.nameLabel setTextAlignment:NSTextAlignmentCenter];
    
    self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x + horizontalOffsetFromEdge, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + infoLabelsVerticalOffsetFromNameLabel, schoolLabelWidth, schoolLabelHeight)];
    self.leftLabel.text = @"UNIVERSITY OF TEXAS";
    [self.leftLabel setFont: schoolLabelFont];
    [self.leftLabel setTextAlignment:NSTextAlignmentCenter];
    
    self.rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x + self.view.bounds.size.width - horizontalOffsetFromEdge - hoursStudiedLabelWidth, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + infoLabelsVerticalOffsetFromNameLabel, hoursStudiedLabelWidth, hoursStudiedLabelHeight)];
    self.rightLabel.text = [NSString stringWithFormat:@"%@ HOURS STUDIED",currentUser.hoursStudied ];
    [self.rightLabel setFont:hoursStudiedLabelFont];
    [self.rightLabel setTextAlignment:NSTextAlignmentCenter];
    
    self.middleLabel = [[UILabel alloc]initWithFrame:CGRectMake(centerX - middleLabelWidth/2, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + infoLabelsVerticalOffsetFromNameLabel, middleLabelWidth, middleLabelHeight)];
    self.middleLabel.text = [currentUser.major uppercaseString];
    [self.middleLabel setFont:hoursStudiedLabelFont];
    [self.middleLabel setTextAlignment:NSTextAlignmentCenter];
    
    
    self.editProfileButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    self.editProfileButton.frame = CGRectMake( self.view.bounds.origin.x + self.view.bounds.size.width - horizontalOffsetFromEdge - editProfileButtonWidth, editPorifleButtonVerticalOffsetFromTop, editProfileButtonWidth, editProfileButtonHeight);
    [self.editProfileButton setTitle:@"EDIT PROFILE" forState:UIControlStateNormal];
    [self.editProfileButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.editProfileButton.titleLabel setFont:editProfileButtonFont];
    [self.editProfileButton setTitleColor:editProfileButtonColor forState:(UIControlStateNormal)];
    self.editProfileButton.backgroundColor = [UIColor huddleOrange];
    self.editProfileButton.layer.cornerRadius = editProfileCornerRadius;
    
    //background photo
    UIImageView* background = [[UIImageView alloc]initWithFrame:self.view.bounds];
    background.image = [UIImage imageNamed:@"backgroundPattern@2x.png"];
    
    [self.view addSubview:background];
    
    [self.view addSubview:self.leftLabel];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.middleLabel];
    [self.view addSubview:self.rightLabel];
    
    [self.view addSubview:self.profileImage];
    
    [self.view addSubview:self.editProfileButton];
    
    
   
    

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateFromParse
{
    Student* currentStudent = (Student*)[Student currentUser];
    self.nameLabel.text = currentStudent.fullName;
    self.middleLabel.text = currentStudent.major;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateFromParse];
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
