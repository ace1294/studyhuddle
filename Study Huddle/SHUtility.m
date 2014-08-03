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
#import "SHCache.h"

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
        class = [[SHCache sharedCache] objectForClass:(PFObject *)classObjects[i]];
        
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

+ (NSMutableArray *)namesForObjects:(NSArray *)objects withKey:(NSString *)key
{
    NSMutableArray *names = [[NSMutableArray alloc]init];
    
    for(PFObject *object in objects){
        [object fetchIfNeeded];
        [names addObject:object[key]];
    }
    
    return names;
}


+(void) setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners
{
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(3.0, 3.0)];
    
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    view.layer.mask = shape;
}

+ (void) moveView: (UIView*)view distance: (CGFloat)distance andDuration: (float) duration
{
    
    [UIView animateWithDuration:duration animations:^{
        view.frame = CGRectOffset(view.frame, 0, distance);
    }];
    
}

+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(UIImageView*) getScreenImageOfSize:(CGSize)size andView:(UIView*)view
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(view.window.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(view.window.bounds.size);

    [view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
  
    return [[UIImageView alloc]initWithImage:image];
}

+(BOOL)user: (PFUser*)user isInHuddle: (PFObject*)huddle
{
  
    NSArray* userHuddles = user[SHStudentHuddlesKey];
    for (PFObject* userHuddle in userHuddles)
        if([[huddle objectId]isEqual:[userHuddle objectId]])
            return true;
    return false;
}

+(BOOL)user: (PFUser*)user isInClass: (PFObject*)classObject
{
    NSArray* userClasses = user[SHStudentClassesKey];
    for (PFObject* userClass in userClasses)
        if([[classObject objectId]isEqual:[userClass objectId]])
            return true;
    return false;
}

+(void)hakySave: (PFObject*) pfobject
{
    NSString* objectID = [pfobject objectId];
    NSString* objectClass = [pfobject parseClassName];
    PFObject* obj = [PFQuery getObjectOfClass:objectClass objectId:objectID];
    [obj save];
}

+(PFObject*)getInstanceOfPFObject: (PFObject*)obj
{
    NSString* objectID = [obj objectId];
    NSString* objectClass = [obj parseClassName];
    return [PFQuery getObjectOfClass:objectClass objectId:objectID];
}

+ (NSArray *)objectIDsForObjects:(NSArray *)objects
{
    NSMutableArray *objectIDs = [[NSMutableArray alloc]initWithCapacity:[objects count]];
    
    for(PFObject *object in objects){
        [objectIDs addObject:[object objectId]];
    }
    return objectIDs;
}


@end
