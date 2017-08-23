//
//  ExplodeView.m
//  Sight Word Scramble
//
//  Created by Brian Foutty on 5/4/14.
//

#import "ExplodeView.h"
#import "QuartzCore/QuartzCore.h"

@implementation ExplodeView
{
    CAEmitterLayer* _emitter;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //initialize the emitter
        _emitter = (CAEmitterLayer*)self.layer;
        _emitter.emitterPosition = CGPointMake(self.bounds.size.width /0.15, self.bounds.size.height/0.15 );
        _emitter.emitterSize = self.bounds.size;
        _emitter.emitterMode = kCAEmitterLayerAdditive;
        _emitter.emitterShape = kCAEmitterLayerRectangle;
    }
    return self;
}

+ (Class) layerClass
{
    //configure the UIView to have emitter layer
    return [CAEmitterLayer class];
}

-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (self.superview==nil) return;
    
    UIImage* texture = [UIImage imageNamed:@"star.png"];
    NSAssert(texture, @"star.png not found");
    
    CAEmitterCell* emitterCell = [CAEmitterCell emitterCell];
    
    emitterCell.contents = (__bridge id)[texture CGImage];
    
    emitterCell.name = @"cell";
    
    emitterCell.birthRate = 1000;
    emitterCell.lifetime = 0.85;
    
    emitterCell.blueRange = 0.33;
    emitterCell.blueSpeed = -0.33;
    
    emitterCell.velocity = 160;
    emitterCell.velocityRange = 40;
    
    emitterCell.scaleRange = 0.5;
    emitterCell.scaleSpeed = -0.2;
    
    emitterCell.emissionRange = M_PI*5;
    
    _emitter.emitterCells = @[emitterCell];
    
    [self performSelector:@selector(disableEmitterCell) withObject:nil afterDelay:0.1];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2.0];
}

-(void)disableEmitterCell
{
    [_emitter setValue:@0 forKeyPath:@"emitterCells.cell.birthRate"];
}

@end
