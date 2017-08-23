//
//  GameController.h
//  Sight Word Scramble
//
//  Created by Brian Foutty on 3/18/14.

#import <Foundation/Foundation.h>
#import "TileView.h"
#import "HUDView.h"
#import "GameData.h"
#import "BT_viewUtilities.h"
#import "BT_strings.h"
#import "BT_item.h"
#import "BT_application.h"

typedef void (^CallbackBlock)();

@interface GameController : NSObject <TileDragDelegateProtocol>

@property (weak, nonatomic) UIView* gameView;
@property (weak, nonatomic) HUDView* hud;
@property (strong, nonatomic) GameData* data;
@property (strong, nonatomic) NSString *landingScreenNickname;



@property (strong, nonatomic) CallbackBlock onWordSolved;

@property (nonatomic) NSInteger timerValue;
@property (nonatomic) NSInteger pointsPerLetter;

@property (strong, nonatomic) NSMutableArray *correctWordList;
@property (strong, nonatomic) NSMutableArray *scrambledWordList;

@property (nonatomic) NSInteger counter;

//display a new word on the screen
-(void)dealRandomWord;


@end
