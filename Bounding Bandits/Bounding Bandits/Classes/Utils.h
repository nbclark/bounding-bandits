//
//  Utils.h
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollabGame.h"

@interface Utils : NSObject

+(BOOL)isNetworkReachable;
+(NSString*)stringForScores:(CollabGame*)game gameOver:(BOOL)gameOver;

@end
