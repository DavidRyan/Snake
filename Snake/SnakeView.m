//
//  SnakeView.m
//  Snake
//
//  Created by David Ryan on 11/13/11.
//  Copyright (c) 2011 DePaul University. All rights reserved.
//

#import "SnakeView.h"
#import "Sprite.h"
#include <stdlib.h>


#define DOWN 0
#define UP 1
#define LEFT 2
#define RIGHT 3
#define HARD (0.125f)
#define MEDIUM (0.250f)
#define EASY (0.375f)
#define STATE_ALIVE 0
#define STATE_DEAD 1

@implementation SnakeView


@synthesize scoreLabel;
@synthesize body;
@synthesize touch;
@synthesize food;
@synthesize framesPerSecond;
@synthesize score;
@synthesize state;

-(id)initWithCoder:(NSCoder *)aDecoder 
{    
    if ((self = [super initWithCoder:aDecoder])) { 
        
        scoreLabel = [[UILabel alloc] init];
        [self initSnake];
        
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
        NSString *documentsDirectory = [paths objectAtIndex:0]; //2
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"SettingsList.plist"]; //3
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath: path]) //4
        {
            NSString *bundle = [[NSBundle mainBundle] pathForResource:@"SettingsList"ofType:@"plist"]; //5 //5
            
            [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
        }

        NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
        
        //load from savedStock example int value
        int value;
        value = [[savedStock objectForKey:@"difficulty"] intValue];
        [savedStock release];
        
        if (value == 1) {
            framesPerSecond = EASY;
        } else if (value == 2) {
            framesPerSecond = MEDIUM;
        } else if (value == 3) {
            framesPerSecond = HARD;
        }
        
    }
    
    
    
    [NSTimer scheduledTimerWithTimeInterval: framesPerSecond target:self selector:@selector(gameloop) userInfo:nil repeats:YES];
    return self;
}


- (void) initSnake 
{
    [body release];
    score = 0;
    [scoreLabel setText:@"0"];
    
    state = STATE_ALIVE;
    
    Sprite *head = [[Sprite alloc] init];
    head.x = 100;
    head.y = 100;
    head.width = 50;
    head.height = 50;
    head.direction = 0;
    head.texture = [UIImage alloc];
    head.texture = [UIImage imageNamed:@"image.jpeg"]; 
    
    
    food = [[Sprite alloc] init];
    food.width = 10;
    food.height = 10;
    food.x = 0;
    food.y = 200;
    
    body = [[NSMutableArray alloc] init];
    [body addObject:head];
    //[head release];
    
    
    //debug purposes
    Sprite *b1 =  [[Sprite alloc] init];
    b1.width = 50;
    b1.height = 50;
    b1.x = 100;
    b1.y = 50;
    Sprite *b2 =  [[Sprite alloc] init];
    b2.width = 50;
    b2.height = 50;
    b2.x = 100;
    b2.y = 0;
    
    [body addObject:b1];
    [body addObject:b2];
    [b1 release];
    [b2 release];
}

- (void) dealloc 
{
    [body release];
    [scoreLabel release];
    [food release];
}

- (void)gameloop 
{
    if(state == STATE_ALIVE) {
        [self moveHead];
        [self setNeedsDisplay];
        [self checkCollision];
        [self checkWalls];
    }
}


- (void) moveHead {
    /*
     For the body, simply retain extra links and make each link the location of the one previous
     */
    Sprite *oldHead = [Sprite alloc];
    Sprite *head = [Sprite alloc];
    head = [body objectAtIndex:0];
    oldHead.x = head.x;
    oldHead.y = head.y;
    if (head.direction == DOWN) {
        head.y = head.y+50;
    } else if (head.direction == UP) {
        head.y = head.y-50;
    } else if (head.direction == LEFT) {
        head.x = head.x-50;
    } else if (head.direction == RIGHT) {
        head.x = head.x+50;
    }
    
    Sprite *b;
    for(int x = 1; x < body.count; x++) {
        b = [body objectAtIndex:x];
        Sprite *tmp = [Sprite alloc];
        tmp.x = b.x;
        tmp.y = b.y;
        b.x = oldHead.x;
        b.y = oldHead.y;
        oldHead.x = tmp.x;
        oldHead.y = tmp.y;
    }
    [oldHead release];
}


/*
- (void)drawRect:(CGRect)rect
{
    Sprite *b; 
    for(int x = 0; x < body.count; x++) { 
        b = [body objectAtIndex:x]; 
        UIImage *myImage = b.texture; 
        CGRect imageRect = CGRectMake(b.x,b.y,b.width,b.height); 
        [myImage drawInRect:imageRect]; 
    } 
}
*/


 - (void)drawRect:(CGRect)rect {
          
     CGContextRef myContext = UIGraphicsGetCurrentContext();
     Sprite *b;
     for(int x = 0; x < body.count; x++) {
         b = [body objectAtIndex:x];
         CGContextSetRGBFillColor (myContext, 100,100,100,20);// 3
         CGContextFillRect (myContext, CGRectMake(b.x, b.y, b.width, b.height) );
     }
     
    CGContextFillRect (myContext, CGRectMake(food.x, food.y, food.width, food.height) );
 }
 

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    NSArray *pTouches = [touches allObjects];
	UITouch *first = [pTouches objectAtIndex:0];
    Sprite *head = [body objectAtIndex:0];
	touch = [first locationInView:self];
    
    if((touch.y > (head.y+head.height))&&((head.direction == LEFT)||(head.direction == RIGHT))) {
        //go up
        NSLog(@"UP");
        head.direction = DOWN;
    } else if((touch.y < head.y)&&((head.direction == LEFT)||(head.direction == RIGHT))) {
        //go down
        NSLog(@"DOWN");
        head.direction = UP;
    } else if ((touch.x < head.x)&&((head.direction == UP)||(head.direction == DOWN))) {
        //go left
        NSLog(@"LEFT");
        head.direction = LEFT;
    } else if ((touch.x > (head.x+head.width))&&((head.direction == UP)||(head.direction == DOWN))) {
        //go left
        head.direction = RIGHT;
        NSLog(@"RIGHT");
    }
}

- (void)checkCollision
{
    Sprite *tail = [Sprite alloc];
    Sprite *head = [Sprite alloc];
    head = [body objectAtIndex:0];
    
    CGRect intersectRect;
    
    for(int x = 1; x < body.count; x++) {
        tail = [body objectAtIndex:x];
        intersectRect = CGRectIntersection ( CGRectMake(head.x+1, head.y+1, head.width-1, head.height-1),
                                             CGRectMake(tail.x+1, tail.y+1, tail.width-1, tail.height-1) );
        if (!CGRectIsNull(intersectRect)) {
            NSLog(@"DIE");
            [self die];
        } 
    }
    
    intersectRect = CGRectIntersection ( CGRectMake(head.x+1, head.y+1, head.width-1, head.height-1),
                                         CGRectMake(food.x+1, food.y+1, food.width-1, food.height-1) );
    
    if(!CGRectIsNull(intersectRect)) {
        [self addLink];
    }

        
}

- (void) checkWalls 
{
    Sprite *head = [Sprite alloc];
    head = [body objectAtIndex:0];
    
    if(head.x+head.width == 350 && head.direction == RIGHT) {
        head.x = 300-head.width;
        [self die];
    } else if(head.x == -50 && head.direction == LEFT) {
        [self die];
    } else if(head.y+head.height == 450 && head.direction == DOWN) {
        head.y = 400-head.height;
        [self die];
    } else if(head.y == -50 && head.direction == UP) {
        [self die];
    }
}

- (void) die 
{
    state = STATE_DEAD;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You Died!" 
                                                    message:@"" 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}


- (void) genFood {

    Sprite *tmp = [Sprite alloc];
    Boolean colliding;
    CGRect intersectRect;
    int x;
    int y;
    Boolean loop = true;
    while (loop) {
        colliding = false;
        
        x = ((rand() % 5)*50)+25;
        y = ((rand() % 7)*50)+25;
        food.width = 10;
        food.height = 10;
        food.x = x;
        food.y = y;
        
        for(int x = 0; x < body.count; x++) { 
            tmp = [body objectAtIndex:x];
            intersectRect = CGRectIntersection ( CGRectMake(tmp.x, tmp.y, tmp.width, tmp.height),
                                                 CGRectMake(food.x, food.y, food.width, food.height) );    
            if (!CGRectIsNull(intersectRect)) {
                colliding = true;
                break;
            }
        }

        if(colliding == false) {
            loop = false;
        }
    }   
}

- (void) addLink {
    Sprite *newLink;
    Sprite *head;
    Sprite *last;
    last = [body objectAtIndex:[body count]-1];    
    head = [Sprite alloc];
    head = [body objectAtIndex:0];
    
    newLink = [Sprite alloc];
    newLink.width = 50;
    newLink.height = 50;
    
    if(head.direction == UP) {
        newLink.x = last.x;
        newLink.y = last.y-50;
    } else if (head.direction == DOWN) {
        newLink.x = last.x;
        newLink.y = last.y+50;
    } else if (head.direction == LEFT) {
        newLink.x = last.x+50;
        newLink.y = last.y;
    } else if (head.direction == RIGHT) {
        newLink.x = last.x-50;
        newLink.y = last.y;
    }
    
    [body addObject:newLink];
    if(framesPerSecond == HARD) {
        score = score+15;
    } else if (framesPerSecond == MEDIUM) {
        score = score+10;
    } else if (framesPerSecond == EASY) {
        score = score+5;
    }
    
    printf("%i\n",score);
    [scoreLabel setText:[[NSString alloc] initWithFormat:@"%i",score]];
    [self genFood];
}


- (IBAction)pressRestart:(id)sender {
    [self initSnake];
}

@end
