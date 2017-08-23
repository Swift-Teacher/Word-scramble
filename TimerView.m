//
//  TimerView.m
//  Sight Word Scramble
//
//  Created by Brian Foutty on 3/25/14.
//

#import "TimerView.h"
#import "config.h"

@implementation TimerView

- (id)initWithFrame:(CGRect)frame {

UIDevice* thisDevice = [UIDevice currentDevice];
if(thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
    
//this is for an iPad screen
{
    {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        self.backgroundColor = [UIColor clearColor];
        self.font = kFontHUD;
        }
    
    return self;
    }
}
    
//this is for an iPhone/iPod screen size
    else{
            {
            self = [super initWithFrame:frame];
            if (self) {
                // Initialization code
                
                self.backgroundColor = [UIColor clearColor];
                self.font = kFontHUDSmall;
            }
            
            return self;
        }
    }
}


//helper method that implements time formatting
//to an int parameter (eg the seconds left)

-(void)setSeconds:(int)seconds
{
    self.text = [NSString stringWithFormat:@" %02.f : %02i", round(seconds / 60), seconds % 60 ];
}


@end
