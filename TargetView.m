//
//  TargetView.m
//  Sight Word Scramble
//
//  Created by Brian Foutty on 3/24/14.
//

#import "TargetView.h"


@implementation TargetView

- (id)initWithFrame:(CGRect)frame

{
    NSAssert(NO, @"Use initWithLetter:andSideLength instead");
    return nil;
    
    }

//create a new target, store the letter should it match
-(instancetype)initWithLetter:(NSString *)letter andSideLength:(float)sideLength
{
    UIImage* img = [UIImage imageNamed:@"slot"];
    self = [super initWithImage: img];
    
    if (self !=nil) {
        //initialization
        self.isMatched = NO;
        
        float scale = sideLength/img.size.width;
        self.frame = CGRectMake(0,0,img.size.width*scale*0.5, img.size.height*scale*0.5);
        
        _letter = letter;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
