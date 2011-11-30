//
//  Sprite.h
//  Snake
//
//  Created by David Ryan on 11/13/11.
//  Copyright (c) 2011 DePaul University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sprite : NSObject {
    CGFloat x;
    CGFloat y;
    CGFloat height;
    CGFloat width;
    int direction;
    UIImage *texture;
}

@property (assign) CGFloat x;
@property (assign) CGFloat y;
@property (assign) CGFloat height;
@property (assign) CGFloat width;
@property (assign) int direction;
@property (nonatomic, retain) UIImage *texture;

@end
