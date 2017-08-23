//
//  HUDView.m
//  Sight Word Scramble
//
//  Created by Brian Foutty on 3/25/14.
//

#import "HUDView.h"
#import "config.h"

@implementation HUDView

+(instancetype)viewWithRect:(CGRect)r{

UIDevice* thisDevice = [UIDevice currentDevice];
if(thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
    
//this is the view and sizing for an iPad
{
    //create the hud layer
    HUDView* hud = [[HUDView alloc] initWithFrame:r];
    hud.userInteractionEnabled = NO;
    
    //the timer
    hud.timer = [[TimerView alloc] initWithFrame: CGRectMake(kScreenWidth/2-200, 0, 300, 150)];
    hud.timer.seconds = 0;
    [hud addSubview: hud.timer];
    
    //this is for the "points" label
    UILabel* pts = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2+150, 0, 250, 150)];
    pts.backgroundColor = [UIColor clearColor];
    pts.font = kFontHUD;
    pts.text = @"Points =";
    [hud addSubview:pts];
    
    //this is the changing points label
    hud.gamePoints = [CounterLabelView labelWithFont:kFontHUD frame:CGRectMake(kScreenWidth/2+425, 0, 200, 150) andValue:0];
    hud.gamePoints.textColor = [UIColor redColor];
    [hud addSubview:hud.gamePoints];
    
    return hud;
}
    
//this is for an iPhone/iPod size screen
else
{
    //create the hud layer
    HUDView* hud = [[HUDView alloc] initWithFrame:r];
    hud.userInteractionEnabled = NO;
    
    //the timer
    hud.timer = [[TimerView alloc] initWithFrame: CGRectMake(kScreenWidth/2-100, 5, 100, 50)];
    hud.timer.seconds = 0;
    [hud addSubview: hud.timer];
    
    //this is for the "points" label
    UILabel* pts = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2+75, 5, 110, 50)];
    pts.backgroundColor = [UIColor clearColor];
    pts.font = kFontHUDSmall;
    pts.text = @"Points=";
    [hud addSubview:pts];
    
    //this is the changing points label
    hud.gamePoints = [CounterLabelView labelWithFont:kFontHUDSmall frame:CGRectMake(kScreenWidth/2+200,5,70,50) andValue:0];
    hud.gamePoints.textColor = [UIColor redColor];
    [hud addSubview:hud.gamePoints];
    
    return hud;
}
}

@end
