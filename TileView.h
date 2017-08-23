//
//  TileView.h
//  Sight Word Scramble
//
//  Created by Brian Foutty on 3/18/14.
//

#import <UIKit/UIKit.h>
@class TileView;
@protocol TileDragDelegateProtocol <NSObject>

-(void)tileView:(TileView*)tileView didDragToPoint:(CGPoint)pt;


@end

@interface TileView : UIImageView

@property (strong, nonatomic, readonly) NSString* letter;
@property (assign, nonatomic) BOOL isMatched;
@property (weak, nonatomic) id<TileDragDelegateProtocol> dragDelegate;

-(instancetype)initWithLetter:(NSString*)letter andSideLength:(float)sideLength;

-(void)randomize;

@end
