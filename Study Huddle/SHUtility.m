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
#import "Student.h"

@implementation SHUtility

+ (void)fetchObjectsInArray:(NSArray *)objects
{
    for(PFObject *object in objects)
        [object fetchIfNeeded];
    
    return;
}

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
        
        [student fetchIfNeeded];
        
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

+ (NSMutableAttributedString *)listOfClasses:(NSArray *)classObjects attributes:(NSDictionary *)attr
{
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

+(BOOL)studentInArray:(NSArray *)list student:(Student *)student
{
    
    
    for(PFObject *object in list)
    {
        if ([[object objectId] isEqual:[student objectId]]) {
            return true;
        }
    }
    
    return false;
}



+ (void)separateOnlineOfflineData:(NSMutableDictionary *)data forOnlineKey:(NSString *)onlineKey;
{
    NSArray *both = [data objectForKey:@"both"];
    NSMutableArray *online = [[NSMutableArray alloc]init];
    NSMutableArray *offline = [[NSMutableArray alloc]init];
    
    for(PFObject *object in both)
    {
        [object fetchIfNeeded];
        if([object[onlineKey]boolValue]){
            [online addObject:object];
        }
        else{
            [offline addObject:object];
        }
    }
    
    [data setObject:online forKey:@"online"];
    [data setObject:offline forKey:@"offline"];
    
}

+ (NSMutableArray *)categoryNamesForCategoryObjects:(NSArray *)categories
{
    NSMutableArray *categoryNames = [[NSMutableArray alloc]init];
    
    for(PFObject *category in categories){
        [category fetchIfNeeded];
        [categoryNames addObject:category[SHCategoryNameKey]];
    }
    
    return categoryNames;
}


+(void) setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners
{
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(3.0, 3.0)];
    
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    view.layer.mask = shape;
}



@end
