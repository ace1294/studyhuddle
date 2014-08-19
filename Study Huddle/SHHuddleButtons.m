//
//  SHHuddleButtons.m
//  Study Huddle
//
//  Created by Jason Dimitriou on 7/3/14.
//  Copyright (c) 2014 StudyHuddle. All rights reserved.
//

#import "SHHuddleButtons.h"
#import "UIColor+HuddleColors.h"
#import "UIView+AUISelectiveBorder.h"
#import "SHConstants.h"
#import "SHModalViewController.h"
#import "UIImage+Color.h"

@interface SHHuddleButtons () <UITextFieldDelegate>

- (void)selectedButtonAction:(NSString *)selection;
- (void)addButtonAction:(id)sender;
- (void)buttonPressed:(id)sender;

@property (strong, nonatomic) NSMutableDictionary *buttonObjects;
@property (strong, nonatomic) NSMutableDictionary *buttons;

@property (strong, nonatomic) UITextField *addButtonField;
@property (strong, nonatomic) UILabel *addButtonHeader;



@end

CGFloat initialHeight;
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

- (id)initWithFrame:(CGRect)frame items:(NSMutableDictionary *)buttonDictionary addButton:(NSString *)addString
{
    self = [super init];
    if (self) {
        
        self.buttonObjects = buttonDictionary;
        self.buttons = [[NSMutableDictionary alloc] init];
        self.selectedButtons = [[NSMutableArray alloc]init];
        
        initialButtonX = CGRectGetMinX(frame);
        initialButtonY = CGRectGetMinY(frame);
        buttonWidth = CGRectGetWidth(frame);
        buttonHeight = CGRectGetHeight(frame);
        if(addString){
            addButton = true;
            addButtonString = addString;
            [self.buttonObjects addObject:addButtonString];
        }
        
        self.textColor = [UIColor huddleSilver];
        self.backgroundColor = [UIColor whiteColor];
        self.selectedTextColor = [UIColor whiteColor];
        self.selectedBackgroundColor = [UIColor huddleOrange];
        self.borderColor = [UIColor colorWithWhite:.9 alpha:1];
        self.textFont = [UIFont fontWithName:@"Arial" size:12];
        self.headerFont = [UIFont fontWithName:@"Arial-BoldMT"size:14];
        self.addButtonPlaceHolder = @"Name";
        
        
        
    }
    return self;
}

- (void)setViewController:(UIViewController *)viewController
{
    _viewController = viewController;
    initialHeight = viewController.view.frame.size.height;
    
    
    [self initButtons];
    
    [self setButtonFrames];
    
    totalButtonsHeight = (buttonHeight*([self.buttonObjects count]/2))+(buttonHeight*([self.buttonObjects count]%2));
    
    if (vertViewSpacing+initialButtonY+totalButtonsHeight > initialHeight) {
        [self expandViewForHeight:(vertViewSpacing+initialButtonY+totalButtonsHeight-initialHeight)];
    }
    
    
}


- (void)initButtons
{
    NSString *buttonTitle;
    UIButton *button;

    for(int i = 0; i < [self.buttonObjects count]; i++)
    {
        buttonTitle = self.buttonObjects[i];
        
        button = [[UIButton alloc]init];
        [self.buttons setObject:button forKey:[NSNumber numberWithInt:i]];

        button.tag = i;
        [button.titleLabel setFont:self.textFont];
        [button setTitleColor:self.textColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectedTextColor forState:UIControlStateHighlighted|UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageWithColor:self.backgroundColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:self.selectedBackgroundColor] forState:UIControlStateSelected|UIControlStateHighlighted];
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
    
    for(NSNumber *tag in [self.buttons allKeys])
    {
        NSUInteger roundCorners = 0;
        
        UIButton *button = [self.buttons objectForKey:tag];
        button.clipsToBounds = YES;
        //Long button on buttom
        if((([tag intValue]+1) == [self.buttons count]) && ([self.buttons count]%2 == 1)){
            [button setFrame:CGRectMake(initialButtonX,initialButtonY+buttonHeight*([tag intValue]/2), buttonWidth*2, buttonHeight)];
            if([self.buttons count] == 1)
                [self setMaskTo:button byRoundingCorners: UIRectCornerAllCorners];
            else
                [self setMaskTo:button byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight];
            continue;
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
        if(([tag intValue]+2) == [self.buttons count] && [tag intValue]!=1 && [self.buttons count]%2 != 1)
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
    UIButton *button = [self.buttons objectForKey:[NSNumber numberWithInteger:[self.buttons count]-1]];
    
    if(addingNewButton){
        addingNewButton = !addingNewButton;
        [self setButtonState:button state:NO];
        [self expandUp:addingNewButton];
        
        [self dismissAddField];

    }
    
    
    NSInteger buttonNumber = [sender tag];

    UIButton *selectedButton = (UIButton *)sender;

    self.selectedButton = selectedButton.titleLabel.text;
    
    if (!self.multipleSelection) {
        for(NSNumber *tag in self.buttons)
        {
            UIButton *button = [self.buttons objectForKey:tag];

            if([tag intValue] == buttonNumber)
               [self setButtonState:button state:YES];
            else
                [self setButtonState:button state:NO];
        }
    }
    else{
        
        if ([self.selectedButtons containsObject:self.selectedButton]) {
            [self.selectedButtons removeObject:self.selectedButton];
            [self setButtonState:selectedButton state:NO];
        }else{
            [self.selectedButtons addObject:self.selectedButton];
            [self setButtonState:selectedButton state:YES];
        }
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
        [self setButtonState:button state:NO];
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
    SHModalViewController *vc =  (SHModalViewController *)self.viewController;
    
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
    
    UIButton *button = [self.buttons objectForKey:[NSNumber numberWithInteger:[self.buttons count]-1]];

    [textField resignFirstResponder];
    
    if(textField.text.length > 0){
        self.selectedButton = textField.text;
        [button setTitle:textField.text forState:UIControlStateNormal];
        [button setTitle:textField.text forState:UIControlStateSelected];
        self.addButtonSet = true;
    }
    else{
        button.selected = NO;
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
    
    SHModalViewController *vc=  (SHModalViewController *)self.viewController;
    
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

- (float)getButtonHeight
{
    return totalButtonsHeight;
}

- (void)setInitialPressedButtons:(NSArray *)buttons
{
    for (NSNumber *tag in self.buttons) {
        UIButton *button = [self.buttons objectForKey:tag];
        if([buttons containsObject:button.titleLabel.text]){
            [self setButtonState:button state:YES];
        }
    }
    [self.selectedButtons addObjectsFromArray:buttons];
}

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

- (void)setButtonState:(UIButton *)button state:(BOOL)selected
{
    if (selected) {
        [button setTitleColor:self.selectedTextColor forState:UIControlStateNormal];
        [button setTitleColor:self.textColor forState:UIControlStateHighlighted|UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageWithColor:self.selectedBackgroundColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:self.backgroundColor] forState:UIControlStateSelected|UIControlStateHighlighted];
        
    } else {
        [button setTitleColor:self.textColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectedTextColor forState:UIControlStateHighlighted|UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageWithColor:self.backgroundColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:self.selectedTextColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    }
}

@end
