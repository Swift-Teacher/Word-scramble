//
//  CounterLabelView.h
//  Sight Word Scramble
//
//  Created by Brian Foutty on 3/25/14.
//

#import <UIKit/UIKit.h>

@interface CounterLabelView : UILabel

@property (assign, nonatomic) int value;

+(instancetype)labelWithFont:(UIFont*)font frame:(CGRect)r andValue:(int)v;
-(void)countTo:(int)to withDuration:(float)t;


@end
