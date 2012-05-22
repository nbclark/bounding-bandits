//
//  BBGamesTableViewController.h
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBGameDelegate.h"

@interface BBGamesTableViewController : UITableViewController

@property (nonatomic, readwrite) BOOL isLoading;
@property (nonatomic, strong) id<BBGameDelegate> gameDelegate;

-(NSUInteger)activeGames;
-(void)gameCreated:(CollabGame*)game;
-(void)gameTurnEnded:(CollabGame*)game;
-(void)showResults:(CollabGame*)game fromRect:(CGRect)aFrame onClose:(BoringBlock)onClose;

@end
