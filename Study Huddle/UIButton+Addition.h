#import <UIKit/UIKit.h>

@interface UIButton(WCButton)
@property (nonatomic, retain) NSMutableDictionary *backgrounds;

- (void) setBackgroundColor:(UIColor *)bgColor forState:(UIControlState)state;
- (void)setState:(UIControlState)state;

@end
