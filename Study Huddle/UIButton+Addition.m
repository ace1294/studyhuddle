
#import "UIButton+Addition.h"
#import <objc/runtime.h>

@implementation UIButton(WCButton)
static char BG_PROPERTY_KEY;
@dynamic backgrounds;

- (void)setBackgrounds:(NSMutableDictionary *)backgrounds
{
    objc_setAssociatedObject(self, &BG_PROPERTY_KEY, backgrounds, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)backgrounds
{
    return (NSMutableDictionary *)objc_getAssociatedObject(self, &BG_PROPERTY_KEY);
}


- (void) setBackgroundColor:(UIColor *)bgColor forState:(UIControlState)state
{
    if([self backgrounds] == NULL)
    {
        NSMutableDictionary *tmpDict = [[NSMutableDictionary alloc] init];
        [self setBackgrounds:tmpDict];
    }
    
    [[self backgrounds] setObject:bgColor forKey:[NSNumber numberWithInt:state]];
    
    if(!self.backgroundColor)
        self.backgroundColor = bgColor;
}

- (void)animateBackgroundToColor:(NSNumber *)key
{
    UIColor *background = [[self backgrounds] objectForKey:key];
    if(background)
    {
        [UIView animateWithDuration:0.2f animations:^{
            self.backgroundColor = background;
        }];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self animateBackgroundToColor:[NSNumber numberWithInt:UIControlStateHighlighted]];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self animateBackgroundToColor:[NSNumber numberWithInt:UIControlStateNormal]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self animateBackgroundToColor:[NSNumber numberWithInt:UIControlStateSelected]];
}

- (void)setState:(UIControlState)state
{
    [self animateBackgroundToColor:[NSNumber numberWithInt:state]];
}

@end
