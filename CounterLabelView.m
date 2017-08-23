//
//  CounterLabelView.m
//  Sight Word Scramble
//
//  Created by Brian Foutty on 3/25/14.
//

#import "CounterLabelView.h"

@implementation CounterLabelView
{
    int endValue;
    double delta;
}

//create an instance of the counter label
+(instancetype)labelWithFont:(UIFont*)font frame:(CGRect)r andValue:(int)v
{
    CounterLabelView* label = [[CounterLabelView alloc] initWithFrame:r];
    if (label!=nil) {
        //initialization
        label.backgroundColor = [UIColor clearColor];
        label.font = font;
        label.value = v;
    }
    return label;
}

//update the label's text
-(void)setValue:(int)value
{
    _value = value;
    self.text = [NSString stringWithFormat:@" %i", self.value];
}

//increment/decrement method
-(void)updateValueBy:(NSNumber*)valueDelta
{
    //1 update the property
    self.value += [valueDelta intValue];
    
    //2 check for reaching the end value
    if ([valueDelta intValue] > 0) {
        if (self.value > endValue) {
            self.value = endValue;
            return;
        }
    } else {
        if (self.value < endValue) {
            self.value = endValue;
            return;
        }
    }
    
    //3 if not - do it again
    [self performSelector:@selector(updateValueBy:) withObject:valueDelta afterDelay:delta];
}

//count to a given value
-(void)countTo:(int)to withDuration:(float)t
{
    //1 detect the time for the animation
    delta = t/(abs(to-self.value)+1);
    if (delta < 0.05) delta = 0.05;
    
    //2 set the end value
    endValue = to;
    
    //3 cancel previous scheduled actions
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    //4 detect which way counting goes
    if (to-self.value>0) {
        //count up
        [self updateValueBy: @1];
    } else {
        //count down
        [self updateValueBy: @-1];
    }
}

@end
