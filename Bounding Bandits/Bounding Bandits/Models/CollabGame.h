//
//  CollabGame.h
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PFObjectExt.h"

@interface CollabGame : PFObjectExt

+(id)object;

@property (nonatomic, strong) NSString* state;
@property (nonatomic, strong) PFUser* activeUser;
@property (nonatomic, strong) PFUser* creator;
@property (nonatomic, strong) NSMutableArray* users;
@property (nonatomic, strong) NSMutableArray* rounds;
@property (nonatomic, strong) NSMutableArray* legacyRounds;
@property (nonatomic, readwrite) NSUInteger tokenCount;
@property (nonatomic, readwrite) BOOL completed;

-(BOOL)didUser:(PFUser*)user winRound:(NSUInteger)round;
-(NSMutableDictionary*)scoresForUsers;
-(PFUser*)otherUser;

@end
