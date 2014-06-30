//
//  SHClassCell.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/14/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHClassCell.h"
#import "UIColor+HuddleColors.h"
#import "SHConstants.h"

@interface SHClassCell ()


@property (nonatomic, strong) UILabel *teacherNameLabel;
@property (nonatomic, strong) UILabel *teacherEmailLabel;
@property (nonatomic, strong) UILabel *classRoomLabel;

- (void)didTapArrowButtonAction:(id)sender;

@end

@implementation SHClassCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        //[self.titleButton addTarget:self action:@selector(didTapTitleButtonAction:) forControlEvents:UIControlEventTouchUpInside];

        
        self.teacherNameLabel = [[UILabel alloc] init];
        [self.teacherNameLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
        [self.teacherNameLabel setTextColor:[UIColor huddleSilver]];
        [self.teacherNameLabel setNumberOfLines:0];
        [self.teacherNameLabel sizeToFit];
        [self.teacherNameLabel setBackgroundColor:[UIColor clearColor]];
        [self.teacherNameLabel setText:@"Jan Rellermeyer"];
        [self.mainView addSubview:self.teacherNameLabel];
        
        self.teacherEmailLabel = [[UILabel alloc] init];
        [self.teacherEmailLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
        [self.teacherEmailLabel setTextColor:[UIColor huddleSilver]];
        [self.teacherEmailLabel setNumberOfLines:0];
        [self.teacherEmailLabel sizeToFit];
        [self.teacherEmailLabel setBackgroundColor:[UIColor clearColor]];
        [self.teacherEmailLabel setText:@"jreller@cs.utexas.edu"];
        [self.mainView addSubview:self.teacherEmailLabel];
        
        self.classRoomLabel = [[UILabel alloc] init];
        [self.classRoomLabel setFont:[UIFont fontWithName:@"Arial" size:12]];
        [self.classRoomLabel setTextColor:[UIColor huddleSilver]];
        [self.classRoomLabel setNumberOfLines:0];
        [self.classRoomLabel sizeToFit];
        [self.classRoomLabel setBackgroundColor:[UIColor clearColor]];
        [self.classRoomLabel setText:@"GDC 4.302"];
        [self.mainView addSubview:self.classRoomLabel];
        

        
        [self.contentView addSubview:self.mainView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    
    CGSize titleSize = [self.titleButton.titleLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                            options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin // word wrap?
                                                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:16]}
                                                            context:nil].size;
    
    [self.titleButton setFrame:CGRectMake(classTitleX, classTitleY, titleSize.width, titleSize.height)];
    
    CGSize labelSize = [self.teacherNameLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                                      options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                                   attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:12]}
                                                                      context:nil].size;

    
    [self.teacherNameLabel setFrame:CGRectMake(classTitleX, classTitleY + self.titleButton.frame.size.height , labelSize.width, labelSize.height)];
    
    [self.classRoomLabel setFrame:CGRectMake(classTitleX + self.teacherNameLabel.frame.size.width +horiElemSpacing,self.teacherNameLabel.frame.origin.y, 2*labelSize.width, labelSize.height)];

    [self.teacherEmailLabel setFrame:CGRectMake(classTitleX, self.teacherNameLabel.frame.origin.y + self.teacherNameLabel.frame.size.height + vertElemSpacing, 2*labelSize.width, labelSize.height*1.1)];
    

    
    
}

- (void)setClass:(PFObject *)aClass
{

    
    _huddleClass = aClass;
    
    //Title Button
    [self.titleButton setTitle:[aClass objectForKey:SHClassFullNameKey] forState:UIControlStateNormal];
    [self.titleButton setTitle:[aClass objectForKey:SHClassFullNameKey] forState:UIControlStateHighlighted];
    
    
    NSDictionary *arialDict = [NSDictionary dictionaryWithObject: [UIFont fontWithName:@"Arial" size:12] forKey:NSFontAttributeName];
    NSMutableAttributedString *teacherString = [[NSMutableAttributedString alloc] initWithString:[aClass objectForKey:SHClassTeacherKey]  attributes: arialDict];
    
    NSDictionary *arialBoldDict = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Arial-BoldMT" size:12] forKey:NSFontAttributeName];
    NSMutableAttributedString *teacherTitleString = [[NSMutableAttributedString alloc]initWithString:@"Teacher: " attributes:arialBoldDict];
    // [bAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:(NSMakeRange(0, 15))];
    
    [teacherTitleString appendAttributedString:teacherString];
    self.teacherNameLabel.attributedText = teacherTitleString;
    
    NSMutableAttributedString *teacherEmailString = [[NSMutableAttributedString alloc] initWithString:[aClass objectForKey:SHClassEmailKey]  attributes: arialDict];
    NSMutableAttributedString *teacherEmailTitleString = [[NSMutableAttributedString alloc]initWithString:@"Email: " attributes:arialBoldDict];
    
    [teacherEmailTitleString appendAttributedString:teacherEmailString];
    self.teacherEmailLabel.attributedText = teacherEmailTitleString;
    
    NSMutableAttributedString *classRoomString = [[NSMutableAttributedString alloc] initWithString:[aClass objectForKey:SHClassRoomKey]  attributes: arialDict];
    NSMutableAttributedString *classRoomTitleString = [[NSMutableAttributedString alloc]initWithString:@"Room: " attributes:arialBoldDict];
    
    [classRoomTitleString appendAttributedString:classRoomString];
    
    self.classRoomLabel.attributedText = classRoomTitleString;
    
    [self layoutSubviews];
    

    
}


#pragma mark - Delegate methods

/* Inform delegate that a user image or name was tapped */
//- (void)didTapArrowButtonAction:(id)sender {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapArrowButton:)]) {
//        [self.delegate cell:self didTapArrowButton:PFlass];
//    }
//}


@end
