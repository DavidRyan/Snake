//
//  SnakeView.h
//  Snake
//
//  Created by David Ryan on 11/13/11.
//  Copyright (c) 2011 DePaul University. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Sprite;

@interface SnakeView : UIView {
    NSMutableArray *body;
    CGPoint touch;
    Sprite *food;
    float framesPerSecond;
    UILabel *scoreLabel;
    int score;
    int state;
}

@property (nonatomic,retain) NSMutableArray *body;
@property (nonatomic,retain) Sprite *food;
@property (assign) CGPoint touch;
@property (assign) float framesPerSecond;
@property (assign) int score;
@property (assign) int state;
@property (nonatomic, retain) IBOutlet UILabel *scoreLabel;

- (void) gameloop;
- (void) checkCollision;
- (void) checkWalls;
- (void) moveHead;
- (void) addLink;
- (void) die;
- (void) genFood;
- (void) initSnake;
- (IBAction)pressRestart:(id)sender;

@end
