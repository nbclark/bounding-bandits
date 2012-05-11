//
//  CollabRound.h
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PFObjectExt.h"

@interface CollabRound : PFObjectExt

+(id)object;

@property (nonatomic, readwrite) BOOL completed;
@property (nonatomic, readwrite) BOOL success;
@property (nonatomic, readwrite) float duration;
@property (nonatomic, readwrite) float elapsed;
@property (nonatomic, readwrite) NSUInteger moves;
@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSString* moveLog;
@property (nonatomic, strong) NSString* state;

@end
