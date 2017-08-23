//
//  GameController.m
//  Sight Word Scramble
//
//  Created by Brian Foutty on 3/18/14.


#import "GameController.h"
#import "config.h"
#import "TileView.h"
#import "TargetView.h"
#import "ExplodeView.h"
#import "StarDustView.h"



@implementation GameController

{
    //tile lists
    NSMutableArray* _tiles;
    NSMutableArray* _targets;
    
    //timer variables
    NSInteger _secondsLeft;
    NSTimer* _timer;
}

//initialize the game controller
-(instancetype)init
{
    self = [super init];
    if (self != nil) {
        //initialize
        self.data = [[GameData alloc] init];
        self.counter = 0;
        self.correctWordList = [[NSMutableArray alloc] init];
        self.scrambledWordList = [[NSMutableArray alloc] init];
        
        //self.audioController = [[AudioController alloc] init];
        //[self.audioController preloadAudioEffects: kAudioEffectFiles];
        
    }
    return self;
}

//fetches a random word, deals the letter tiles and creates the targets
-(void)dealRandomWord
{

    
    
    //should maybe have some kind of loop here (like the one below) to have game go through all words in a unit rather than 1 at a time
    //for (int i=0;i<ana1len;i++) {
        //NSString* letter = [word1 substringWithRange:NSMakeRange(i, 1)];
    
    //random word
  //  NSInteger randomIndex = arc4random()%[self.unit.words count];
   // NSArray* anaPair = self.unit.words[ self.counter ];
    

    NSString* scrambledWord = self.scrambledWordList[self.counter];
    NSString* correctWord = self.correctWordList[self.counter];

    NSInteger scrambledLength = [scrambledWord length];
    NSInteger correctLength = [correctWord length];

    //NSLog(@"phrase1[%i]: %@", ana1len, word1);
    //NSLog(@"phrase2[%i]: %@", ana2len, word2);
    
    //UIDevice* thisDevice = [UIDevice currentDevice];
    //if(thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
        
//this is the view and sizing for an iPad
{
    //calculate the tile size
    CGFloat tileSide = ceilf( kScreenWidth * 0.85 / (CGFloat)MAX(scrambledLength, correctLength) ) - kTileMargin;
    
    //get the left margin for first tile
    CGFloat xOffset = (kScreenWidth - MAX(scrambledLength, correctLength) * (tileSide + kTileMargin));
    
    //adjust for tile center (instead of the tile's origin)
    xOffset += tileSide/2;
    
    //initialize target list
    _targets = [NSMutableArray arrayWithCapacity: correctLength];
    
    //create targets
    for (NSInteger i=0; i < correctLength; i++) {
        NSString* letter = [correctWord substringWithRange:NSMakeRange(i, 1)];
        
        if (![letter isEqualToString:@" "]) {
            TargetView* target = [[TargetView alloc] initWithLetter:letter andSideLength: tileSide];
            target.center = CGPointMake(xOffset + i*(tileSide + kTileMargin), (kScreenHeight-30)/4);
            
            [self.gameView addSubview:target];
            [_targets addObject: target];
        }
    }

    
    //initialize tile list
    _tiles = [NSMutableArray arrayWithCapacity: scrambledLength];
    
    //create tiles
    for (int i=0; i < scrambledLength; i++) {
        NSString* letter = [scrambledWord substringWithRange:NSMakeRange(i, 1)];
        
    
        if (![letter isEqualToString:@" "]) {
            TileView* tile = [[TileView alloc] initWithLetter:letter andSideLength:tileSide];
            tile.center = CGPointMake(xOffset + i*(tileSide + kTileMargin), (kScreenHeight-40)/2);
            
            [tile randomize];
            
            tile.dragDelegate = self;
            
            [self.gameView addSubview:tile];
            [_tiles addObject: tile];
        }
    }
}

/*this is for an iPhone/iPod size screen
else
{
    
    //calculate the tile size
    CGFloat tileSide = ceilf( kScreenWidth * 0.9 / (CGFloat)MAX(scrambledLength, correctLength) ) - kTileMargin;
    
    //get the left margin for first tile
    CGFloat xOffset = (kScreenWidth - MAX(scrambledLength, correctLength) * (tileSide + kTileMargin));
    
    //adjust for tile center (instead of the tile's origin)
    xOffset += tileSide/2;
    
    //initialize target list
    _targets = [NSMutableArray arrayWithCapacity: correctLength];
    
    //create targets
    for (NSInteger i=0; i < correctLength; i++) {
        NSString* letter = [correctWord substringWithRange:NSMakeRange(i, 1)];
        
        if (![letter isEqualToString:@" "]) {
            TargetView* target = [[TargetView alloc] initWithLetter:letter andSideLength: tileSide];
            target.center = CGPointMake(xOffset + i*(tileSide + kTileMargin), (kScreenHeight-30)/4);
            
            [self.gameView addSubview:target];
            [_targets addObject: target];
        }
    }
    
    
    //initialize tile list
    _tiles = [NSMutableArray arrayWithCapacity: scrambledLength];
    
    //create tiles
    for (int i=0; i < scrambledLength; i++) {
        NSString* letter = [scrambledWord substringWithRange:NSMakeRange(i, 1)];
        
        
        if (![letter isEqualToString:@" "]) {
            TileView* tile = [[TileView alloc] initWithLetter:letter andSideLength:tileSide];
            tile.center = CGPointMake(xOffset + i*(tileSide + kTileMargin), (kScreenHeight-40)/2.5);
            
            [tile randomize];
            
            tile.dragDelegate = self;
            
            [self.gameView addSubview:tile];
            [_tiles addObject: tile];
        }
    }
}


 //this is the ending curly brace for the possible for loop
}*/
    
    //start the timer
    [self startTimer];
}

//a tile was dragged, check if matches a target
-(void)tileView:(TileView*)tileView didDragToPoint:(CGPoint)pt
{
    TargetView* targetView = nil;
    
    for (TargetView* tv in _targets) {
        if (CGRectContainsPoint(tv.frame, pt)) {
            targetView = tv;
            break;
        }
    }
    
    // check if target was found
    if (targetView!=nil) {
        
        // check if letter matches
        if ([targetView.letter isEqualToString: tileView.letter]) {
            
            [self placeTile:tileView atTarget:targetView];
            
            //more stuff to do on success here
            //[self.audioController playEffect: kSoundDing];
            
            //give points
            self.data.points += self.pointsPerLetter;
            [self.hud.gamePoints countTo:self.data.points withDuration:1.5];
            
            
           
            
            //check for finished game
            [self checkForSuccess];
            
            //the anagram is completed!
            //[self.audioController playEffect:kSoundWin];
            
        } else {
            
            //visualize the mistake
            [tileView randomize];
            
            [UIView animateWithDuration:0.35
                                  delay:0.00
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 tileView.center = CGPointMake(tileView.center.x + randomf(-20, 20),
                                                               tileView.center.y + randomf(20, 30));
                             } completion:nil];
            
            //more stuff to do on failure here
            //[self.audioController playEffect:kSoundWrong];
            
            
            //subtract points
            self.data.points -= self.pointsPerLetter/1.5;
            [self.hud.gamePoints countTo:self.data.points withDuration:.75];
        }
    }
}

//checks to make sure the tile placement is correct
-(void)placeTile:(TileView*)tileView atTarget:(TargetView*)targetView
{
    targetView.isMatched = YES;
    tileView.isMatched = YES;
    
    tileView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.35
                          delay:0.00
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         tileView.center = targetView.center;
                         tileView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished){
                         targetView.hidden = YES;
                     }];
    
    ExplodeView* explode = [[ExplodeView alloc] initWithFrame:CGRectMake(tileView.center.x,tileView.center.y,10,10)];
    [tileView.superview addSubview: explode];
    [tileView.superview sendSubviewToBack:explode];
}

-(void)checkForSuccess
    {
        for (TargetView* t in _targets) {
            //no success, bail out
            if (t.isMatched==NO) return;
        }
        
        //NSLog(@"Game Over!");
        
        //stop the timer
        [self stopTimer];
        
        //win animation
        TargetView* firstTarget = _targets[0];
        
        int startX = 0;
        int endX = kScreenWidth + 300;
        int startY = firstTarget.center.y;
        
        StarDustView* stars = [[StarDustView alloc] initWithFrame:CGRectMake(startX, startY, 10, 10)];
        [self.gameView addSubview:stars];
        [self.gameView sendSubviewToBack:stars];
        
        [UIView animateWithDuration:3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             stars.center = CGPointMake(endX, startY);
                         } completion:^(BOOL finished) {
                             
                             //game finished
                             [stars removeFromSuperview];
                             
                             //when animation is finished, show menu
                             [self clearBoard];
                             
                            
                             
                             if(self.counter < (self.correctWordList.count-1)) {
                                  self.counter++;
                                 [self dealRandomWord];
                             }else{
                                 self.onWordSolved();
                             }

                         }];
        
}

-(void)startTimer
{
    //initialize the timer HUD
    _secondsLeft = self.timerValue;
    [self.hud.timer setSeconds:_secondsLeft];
    
    //schedule a new timer
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(tick:)
                                            userInfo:nil
                                             repeats:YES];
}

//stop the timer
-(void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
}

//timer on tick
-(void)tick:(NSTimer*)timer
{
    _secondsLeft --;
    [self.hud.timer setSeconds:_secondsLeft];
    
    if (_secondsLeft==0) {
        [self stopTimer];
    }
}

//clear the tiles and targets
-(void)clearBoard
{
    [_tiles removeAllObjects];
    [_targets removeAllObjects];
    
    for (UIView *view in self.gameView.subviews) {
        [view removeFromSuperview];
    }
}




@end
