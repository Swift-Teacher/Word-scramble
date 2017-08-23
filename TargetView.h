//
//  TargetView.h
//  Sight Word Scramble
//
//  Created by Brian Foutty on 3/24/14.
//

#import <UIKit/UIKit.h>

@interface TargetView : UIImageView

@property (strong, nonatomic, readonly) NSString* letter;
@property (assign, nonatomic) BOOL isMatched;

-(instancetype)initWithLetter:(NSString*)letter andSideLength:(float)sideLength;

@end
