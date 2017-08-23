//
//  GameData.m
//  Sight Word Scramble
//
//  Created by Brian Foutty on 3/25/14.
//

#import "GameData.h"

@implementation GameData

//custom setter - keep the score positive
-(void)setPoints:(int)points
{
    _points = MAX(points, 0);
}

@end
