//
//  SHChatEntryViewController.h
//  Study Huddle
//
//  Created by Jose Rafael Leon Bigio Anton on 7/4/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SHChatEntryViewController : UIViewController

-(id)initWithChatEntry:(PFObject*) aChatEntry;

@end
