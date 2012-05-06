//
//  BBBoardViewController.h
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIWebViewController.h"
#import "BBViewController.h"

@interface BBBoardViewController : UIWebViewController

-(NSString*)loadGameWithGameType:(GAME_TYPE)gameType gameState:(NSString*)gameState generateState:(BOOL)generateState isActive:(BOOL)isActive elapsed:(float)elapsed;

@end
