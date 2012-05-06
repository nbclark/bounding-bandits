//
//  BlitzGame.h
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PFObjectExt.h"

@interface BlitzGame : PFObjectExt

+(id)object;

@property (nonatomic, readwrite) BOOL success;
@property (nonatomic, readwrite) float duration;
@property (nonatomic, readwrite) NSUInteger moves;
@property (nonatomic, readwrite) NSUInteger captures;
@property (nonatomic, readwrite) NSUInteger bestSolutions;
@property (nonatomic, strong) PFUser* user;

@end
