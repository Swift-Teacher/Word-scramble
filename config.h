//
//  config.h
//  Sight Word Scramble
//
//  Created by Brian Foutty on 3/18/14.
//

#ifndef configed

//UI defines
#define kScreenWidth [UIScreen mainScreen].bounds.size.height
#define kScreenHeight [UIScreen mainScreen].bounds.size.width

//add more definitions here
#define kTileMargin 10 
#define kFontHUDSmall [UIFont fontWithName:@"helveticaneue-bold" size:28.0]
#define kFontHUD [UIFont fontWithName:@"helveticaneue-bold" size:62.0]
#define kFontHUDBig [UIFont fontWithName:@"helveticaneue-bold" size:120.0


//handy math functions
#define rad2deg(x) x * 180 / M_PI
#define deg2rad(x) x * M_PI / 180
#define randomf(minX,maxX) ((float)(arc4random() % (maxX - minX + 1)) + (float)minX)


#define configed 1
#endif