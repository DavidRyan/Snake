//
//  SettingsController.h
//  Snake
//
//  Created by David Ryan on 11/21/11.
//  Copyright (c) 2011 DePaul University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsController : UIViewController {
    UILabel *difficultyLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *difficultyLabel;

- (IBAction)difficultyChanged:(id)sender;

@end
