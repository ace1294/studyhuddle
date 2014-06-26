//
//  SHUtility.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 6/19/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHUtility.h"
#import "SHConstants.h"
#import <Parse/Parse.h>

@implementation SHUtility

+ (NSMutableAttributedString *)listOfMemberNames:(NSArray *)members attributes:(NSDictionary *)attr
{
    NSString *fullName;
    NSMutableAttributedString *listOfNames = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *temp;
    NSArray* firstLastStrings;
    NSString* newNameStr;
    PFObject *student;
    
    for(int i = 0; (i < 3 && i < [members count]); i++)
    {
        student = members[i];
        
        fullName = student[SHStudentNameKey];
        
        firstLastStrings = [fullName componentsSeparatedByString:@" "];
        newNameStr = [NSString stringWithFormat:@"%@ %c", [firstLastStrings objectAtIndex:0], [[firstLastStrings objectAtIndex:1] characterAtIndex:0]];
        temp = [[NSMutableAttributedString alloc] initWithString:newNameStr attributes:attr];
        
        if (i+1<[members count]) {
            [temp appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@", " attributes:attr]];
        }
        
        [listOfNames appendAttributedString:temp];
    }
    if ([members count] > 3) {
        [listOfNames appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"..." attributes:attr]];
    }

    return listOfNames;
}

+ (NSMutableAttributedString *)listOfClasses:(PFRelation *)classes attributes:(NSDictionary *)attr
{
    PFQuery *classesQuery = [classes query];
    classesQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    NSArray *classObjects = [classesQuery findObjects];
    PFObject *class;

    NSMutableAttributedString *listOfClasses = [[NSMutableAttributedString alloc]init];
    NSMutableAttributedString *temp;
    
    for(int i = 0; (i < 3 && i < [classObjects count]); i++)
    {
        class = classObjects[i];
        
        [class fetchIfNeeded];
        
        temp = [[NSMutableAttributedString alloc] initWithString:class[SHClassShortNameKey] attributes:attr];
        if (i+1<[classObjects count]) {
            [temp appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@", " attributes:attr]];
        }
        
        [listOfClasses appendAttributedString:temp];
    }
    
    if ([classObjects count] > 3) {
        [listOfClasses appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"..." attributes:attr]];
    }
    
    return listOfClasses;
}




+ (UIImage *)getRoundedRectImageFromImage :(UIImage *)image onReferenceView :(UIImageView*)imageView withCornerRadius :(float)cornerRadius
{
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 0.0);
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds
                                cornerRadius:cornerRadius] addClip];
    [image drawInRect:imageView.bounds];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
    return finalImage;
}




@end
