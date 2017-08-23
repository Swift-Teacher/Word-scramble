//
//  TimerView.h
//  Sight Word Scramble
//
//  Created by Brian Foutty on 3/25/14.
//

#import <UIKit/UIKit.h>

@interface TimerView : UILabel

@property (strong, nonatomic) UIDevice* thisDevice;

-(void)setSeconds:(int)seconds;

@end
