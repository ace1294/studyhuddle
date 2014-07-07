//
//  SHHuddleButtons.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/3/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHHuddleButtons.h"
#import "UIColor+HuddleColors.h"
#import "UIButton+Addition.h"
#import "UIView+AUISelectiveBorder.h"
#import "SHConstants.h"
#import "SHNewResourceViewController.h"

@interface SHHuddleButtons () <UITextFieldDelegate>

- (void)selectedButtonAction:(NSString *)selection;
- (void)addButtonAction:(id)sender;
- (void)buttonPressed:(id)sender;

@property (strong, nonatomic) NSMutableArray *buttonTitles;
@property (strong, nonatomic) NSMutableDictionary *buttons;

@property (strong, nonatomic) UITextField *addButtonField;
@property (strong, nonatomic) UILabel *addButtonHeader;



@end

CGRect initialFrame;
CGFloat initialButtonX;
CGFloat initialButtonY;
CGFloat buttonWidth;
CGFloat buttonHeight;
CGFloat totalButtonsHeight;
BOOL addButton;
BOOL addingNewButton;
NSString *addButtonString;

@implementation SHHuddleButtons

- (id)initWithFrame:(CGRect)frame items:(NSArray *)buttonList addButton:(NSString *)addString
{
    self = [super init];
    if (self) {
        
        self.buttonTitles = [[NSMutableArray alloc]initWithArray:buttonList];
        self.buttons = [[NSMutableDictionary alloc] init];
        
        initialButtonX = CGRectGetMinX(frame);
        initialButtonY = CGRectGetMinY(frame);
        buttonWidth = CGRectGetWidth(frame);
        buttonHeight = CGRectGetHeight(frame);
        if(addString){
            addButton = true;
            addButtonString = addString;
            [self.buttonTitles addObject:addButtonString];
        }
        

        
        self.textColor = [UIColor huddleSilver];
        self.backgroundColor = [UIColor whiteColor];
        self.selectedTextColor = [UIColor whiteColor];
        self.selectedBackgroundColor = [UIColor huddleOrange];
        self.borderColor = [UIColor colorWithWhite:.9 alpha:1];
        self.textFont = [UIFont fontWithName:@"Arial" size:14];
        self.headerFont = [UIFont fontWithName:@"Arial-BoldMT"size:14];
        self.addButtonPlaceHolder = @"Name";
        
        
        
    }
    return self;
}

- (void)setViewController:(UIViewController *)viewController
{
    _viewController = viewController;
    
    [self initButtons];
    
    [self setButtonFrames];
    
    totalButtonsHeight = (buttonHeight*([self.buttonTitles count]/2))+(buttonHeight*([self.buttonTitles count]%2));
    [self expandViewForHeight:totalButtonsHeight];
}


- (void)initButtons
{
    NSString *buttonTitle;
    UIButton *button;

    for(int i = 0; i < [self.buttonTitles count]; i++)
    {
        buttonTitle = self.buttonTitles[i];
        
        button = [[UIButton alloc]init];
        [self.buttons setObject:button forKey:[NSNumber numberWithInt:i]];

        button.tag = i;
        [button.titleLabel setFont:self.textFont];
        [button setBackgroundColor:self.backgroundColor];
        [button setTitleColor:self.textColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectedTextColor forState:UIControlStateHighlighted];
        [button setTitleColor:self.selectedTextColor forState:UIControlStateSelected];
        [button setBackgroundColor:self.backgroundColor forState:UIControlStateNormal];
        [button setBackgroundColor:self.selectedBackgroundColor forState:UIControlStateHighlighted];
        [button setBackgroundColor:self.selectedBackgroundColor forState:UIControlStateSelected];
        [button setTitle:buttonTitle forState:UIControlStateNormal];

        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.viewController.view addSubview:button];

    }
    if(addButton){
        [button addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Cancel" forState:UIControlStateSelected];
    }
    

    
}

- (void)setButtonFrames
{
    
    for(NSNumber *tag in self.buttons)
    {
        NSUInteger roundCorners = 0;
        
        UIButton *button = [self.buttons objectForKey:tag];
        button.clipsToBounds = YES;
        //Long button on buttom
        if((([tag intValue]+1) == [self.buttons count]) && ([self.buttons count]%2 == 1)){
            [button setFrame:CGRectMake(initialButtonX,initialButtonY+buttonHeight*([tag intValue]/2), buttonWidth*2, buttonHeight)];
            [self setMaskTo:button byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight];
            return;
        }
        else
            [button setFrame:CGRectMake(initialButtonX+buttonWidth*([tag intValue]%2),initialButtonY+buttonHeight*([tag intValue]/2), buttonWidth, buttonHeight)];
        
        //Round Top Corners
        if([tag intValue] == 0){
            roundCorners = UIRectCornerTopLeft;
        }
        else if ([tag intValue] == 1 || [self.buttons count] == 1)
             roundCorners = roundCorners | UIRectCornerTopRight;
        
        //Round Bottom Corners
        if(([tag intValue]+2) == [self.buttons count] && [tag intValue]!=1)
            roundCorners = roundCorners | UIRectCornerBottomLeft;
        else if(([tag intValue]+1) == [self.buttons count])
            roundCorners = roundCorners | UIRectCornerBottomRight;
        [self setMaskTo:button byRoundingCorners: roundCorners];
        
        //Borders
        if([tag intValue]%2 == 0 && ([tag intValue]+2) < [self.buttons count])
            button.selectiveBorderFlag = AUISelectiveBordersFlagBottom | AUISelectiveBordersFlagRight;
        else if([tag intValue]%2 == 0)
            button.selectiveBorderFlag = AUISelectiveBordersFlagRight;
        else if ([tag intValue]%2 == 1 && ([tag intValue]+1) < [self.buttons count])
            button.selectiveBorderFlag = AUISelectiveBordersFlagBottom;
            
        button.selectiveBordersColor = self.borderColor;
        button.selectiveBordersWidth = 1.0;
    }
    
}

- (void)buttonPressed:(id)sender
{
    UIButton *button = [self.buttons objectForKey:[NSNumber numberWithInt:[self.buttons count]-1]];
    
    if(addingNewButton){
        addingNewButton = !addingNewButton;
        button.selected = NO;
        [button setState:UIControlStateNormal];
        [self expandUp:addingNewButton];
        
        [self dismissAddField];

    }
    
    
    int buttonNumber = [sender tag];

    UIButton *selectedButton = [self.buttons objectForKey:[NSNumber numberWithInt:buttonNumber]];

    self.selectedButton = selectedButton.titleLabel.text;

    for(NSNumber *tag in self.buttons)
    {
        UIButton *button = [self.buttons objectForKey:tag];

        if(tag == [NSNumber numberWithInt:buttonNumber]){
            button.selected = YES;
            continue;
        }
        
        [button setState:UIControlStateNormal];
        button.selected = NO;
        button.highlighted = NO;
    }

}

#pragma mark - Add Button Methods


- (void)addButtonAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if(self.addButtonSet)
        return;
    
    if(addingNewButton){
        addingNewButton = !addingNewButton;
        button.selected = NO;
        [button setState:UIControlStateNormal];
        [self expandUp:addingNewButton];
        
        [self dismissAddField];
        
        return;
    }
    
    addingNewButton = !addingNewButton;
    
    if(!self.addButtonHeader){
        self.addButtonHeader = [[UILabel alloc]initWithFrame:CGRectMake(initialButtonX, initialButtonY+totalButtonsHeight+vertElemSpacing, buttonWidth, buttonHeight)];
        [self.addButtonHeader setFont:self.headerFont];
        [self.addButtonHeader setTextColor:self.textColor];
        [self.addButtonHeader setText:addButtonString];
        [self.viewController.view addSubview:self.addButtonHeader];
        
        self.addButtonField = [[UITextField alloc] init];
        self.addButtonField.delegate = self;
        self.addButtonField.placeholder = self.addButtonPlaceHolder;
        self.addButtonField.backgroundColor = self.backgroundColor;
        [self.addButtonField setTextColor:self.textColor];
        self.addButtonField.layer.cornerRadius = 3.0;
        UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [self.addButtonField setLeftViewMode:UITextFieldViewModeAlways];
        [self.addButtonField setLeftView:spacerView];
        
        [self.viewController.view addSubview:self.addButtonField];
    }
    [self.addButtonHeader setFrame:CGRectMake(initialButtonX, initialButtonY+totalButtonsHeight+vertElemSpacing, buttonWidth, buttonHeight)];
    [self.addButtonField setFrame:CGRectMake(initialButtonX, initialButtonY+totalButtonsHeight+buttonHeight, buttonWidth*2, buttonHeight)];
    self.addButtonHeader.hidden = NO;
    self.addButtonField.hidden = NO;
    
    [self expandUp:addingNewButton];

    
}



#pragma mark - Delegate Methods

- (void)expandViewForHeight:(CGFloat)height
{
    SHNewResourceViewController *vc=  (SHNewResourceViewController *)self.viewController;
    
    vc.modalFrameHeight += height;
    
    [vc.view setFrame:CGRectMake(0.0, 0.0, modalWidth, vc.modalFrameHeight)];
    
    

}

- (void)selectedButtonAction:(NSString *)selection
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didChangeButton:)]) {
        [self.delegate didChangeButton:selection];
    }
}



#pragma mark - UITextfield Delgate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
    
    UIButton *button = [self.buttons objectForKey:[NSNumber numberWithInt:[self.buttons count]-1]];

    [textField resignFirstResponder];
    
    if(textField.text.length > 0){
        self.selectedButton = textField.text;
        [button setTitle:textField.text forState:UIControlStateNormal];
        [button setTitle:textField.text forState:UIControlStateSelected];
        self.addButtonSet = true;
    }
    else{
        button.selected = NO;
        [button setState:UIControlStateNormal];
    }
    
    
    
    [self expandUp:NO];
    
    return YES;
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    [self moveUp:up];

}

- (void)expandUp: (BOOL) up
{
    if(!up)
        [self dismissAddField];
    
    SHNewResourceViewController *vc=  (SHNewResourceViewController *)self.viewController;
    
    CGFloat viewLengthen = (up ? buttonHeight*2 : -buttonHeight*2);
    
    vc.modalFrameHeight += viewLengthen;
    
    CGFloat originX = vc.view.frame.origin.x;
    CGFloat originY = vc.view.frame.origin.y;
    
    originY = originY -(viewLengthen/2);
    
    CGRect viewFrame = CGRectMake(originX, originY, modalWidth, vc.modalFrameHeight);
    
    [UIView animateWithDuration:0.5f animations:^{
        vc.view.frame = CGRectOffset(viewFrame, 0, -viewLengthen/2);

    }];
    
}

- (void)moveUp: (BOOL) up
{
    const int movementDistance = 110; // tweak as needed

    int movement = (up ? -movementDistance : movementDistance);
    
    if(up){
        initialFrame = self.viewController.view.frame;
        [UIView animateWithDuration:0.5f animations:^{
        self.viewController.view.frame = CGRectOffset(initialFrame, 0, movement);
        }];
    }
    else{
        [UIView animateWithDuration:0.5f animations:^{
        self.viewController.view.frame = initialFrame;
        }];
    }


}




#pragma mark - Helpers

- (void)dismissAddField
{
    addingNewButton = false;
    
    
    self.addButtonField.hidden = YES;
    self.addButtonHeader.hidden = YES;
    
}

-(void) setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners
{
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(3.0, 3.0)];
        
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
        
    view.layer.mask = shape;
}


@end
