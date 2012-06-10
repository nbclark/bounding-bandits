//
//  BBGameDelegate.h
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Models.h"

typedef enum
{
    GAME_TYPE_LOCAL = 1,
    GAME_TYPE_BLITZ = 2,
    GAME_TYPE_TURN = 3,
    GAME_TYPE_RANDOM = 4
} GAME_TYPE;

@protocol BBGameDelegate <NSObject>

@required

-(void)startGame:(GAME_TYPE)gameType;
-(void)selectGame:(CollabGame*)game isNew:(BOOL)isNew;
-(void)endGame:(NSDictionary*)results;
-(void)signalLoadComplete:(id)sender;
-(void)showMenu;
-(void)hideMenu;

@optional

@end
