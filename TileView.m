//
//  TileView.m
//  Sight Word Scramble
//
//  Created by Brian Foutty on 3/18/14.
//

#import "TileView.h"
#import "config.h"
#import <QuartzCore/QuartzCore.h>


@implementation TileView
{
    int _xOffset, _yOffset;
    }


- (id)initWithFrame:(CGRect)frame
{
    NSAssert(NO, @"Use initWithLetter:andSideLength instead");
    return nil;
}

//create new tile for a given letter
-(instancetype)initWithLetter:(NSString*)letter andSideLength:(float)sideLength
{
    //the tile background
    UIImage* img = [UIImage imageNamed:@"tile.png"];
    
    //create a new object
    self = [super initWithImage:img];
    
    if (self != nil) {
        
        //resize the tile
        float scale = sideLength/img.size.width*0.5;
        self.frame = CGRectMake(0,0,img.size.width*scale, img.size.height*scale);
        
        //add a letter on top
        UILabel* lblChar = [[UILabel alloc] initWithFrame:self.bounds];
        lblChar.textAlignment = NSTextAlignmentCenter;
        lblChar.textColor = [UIColor whiteColor];
        lblChar.backgroundColor = [UIColor clearColor];
        lblChar.text = [letter lowercaseString];
        lblChar.font = [UIFont fontWithName:@"Verdana-Bold" size:99.0*scale];
        [self addSubview: lblChar];
        
        //begin in unmatched state
        self.isMatched = NO;
        
        //save the letter
        _letter = letter;
        
        //this allows user interaction with the letter tiles
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

-(void)randomize
{
    /*set random rotation of the tile
    //anywhere between -0.2 and 0.3 radians
    float rotation = randomf(0,50) / (float)100 - 0.0;
    self.transform = CGAffineTransformMakeRotation( rotation );
    
    //move randomly upwards
    int yOffset = (arc4random() % 10) - 0;
    self.center = CGPointMake(self.center.x, self.center.y + yOffset);
    */
}

#pragma mark - dragging the tile

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
        CGPoint pt = [[touches anyObject] locationInView:self.superview];
        _xOffset = pt.x - self.center.x;
        _yOffset = pt.y - self.center.y;
    
    [self.superview bringSubviewToFront:self];

}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt = [[touches anyObject] locationInView:self.superview];
    self.center = CGPointMake(pt.x - _xOffset, pt.y - _yOffset);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];

    if (self.dragDelegate) {
        [self.dragDelegate tileView:self didDragToPoint:self.center];

    }
    
}



@end