//
//  HUDView.h
//  Sight Word Scramble
//
//  Created by Brian Foutty on 3/25/14.
//

#import <UIKit/UIKit.h>
#import "TimerView.h"
#import "CounterLabelView.h"

@interface HUDView : UIView

@property (strong, nonatomic) TimerView* timer;
@property (strong, nonatomic) CounterLabelView* gamePoints;
@property (strong, nonatomic) UIDevice* thisDevice;

+(instancetype)viewWithRect:(CGRect)r;

@end
