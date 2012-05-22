//
//  CollabRound.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CollabRound.h"

@interface CollabRound()


@end

@implementation CollabRound

@synthesize baseObj;

+(id)objectWithObject:(NSMutableDictionary*)obj
{    
    return [[ CollabRound alloc ] initWithObject:obj ];
}

+(id)object
{
    return [[ CollabRound alloc ] initWithObject:[ NSMutableDictionary dictionary ]];
}

-(id)initWithObject:(NSMutableDictionary*)obj
{    
    self = [ super init ];
    self.baseObj = obj;
    
    return self;
}

-(NSString*)userId
{
    return [ self.baseObj objectForKey:@"UserId" ];
}

-(void)setUserId:(NSString *)userId
{
    [ self.baseObj setObject:userId forKey:@"UserId" ];
}

-(BOOL)completed
{
    return [[ self.baseObj objectForKey:@"Completed" ] boolValue ];
}

-(void)setCompleted:(BOOL)completed
{
    [ self.baseObj setObject:[ NSNumber numberWithBool:completed ] forKey:@"Completed" ];
}

-(BOOL)success
{
    return [[ self.baseObj objectForKey:@"Success" ] boolValue ];
}

-(void)setSuccess:(BOOL)success
{
    [ self.baseObj setObject:[ NSNumber numberWithBool:success ] forKey:@"Success" ];
}

-(float)duration
{
    return [[ self.baseObj objectForKey:@"Duration" ] floatValue ];
}

-(void)setDuration:(float)duration
{
    [ self.baseObj setObject:[ NSNumber numberWithFloat:duration ] forKey:@"Duration" ];
}

-(float)elapsed
{
    return [[ self.baseObj objectForKey:@"Elapsed" ] floatValue ];
}

-(void)setElapsed:(float)elapsed
{
    [ self.baseObj setObject:[ NSNumber numberWithFloat:elapsed ] forKey:@"Elapsed" ];
}

-(NSUInteger)moves
{
    return [[ self.baseObj objectForKey:@"Moves" ] intValue ];
}

-(void)setMoves:(NSUInteger)moves
{
    [ self.baseObj setObject:[ NSNumber numberWithUnsignedInteger:moves ] forKey:@"Moves" ];
}

-(NSString*)moveLog
{
    return [ self.baseObj objectForKey:@"MoveLog" ];
}

-(void)setMoveLog:(NSString *)moveLog
{
    [ self.baseObj setObject:moveLog forKey:@"MoveLog" ];
}

-(NSString*)state
{
    return [ self.baseObj objectForKey:@"State" ];
}

-(void)setState:(NSString *)state
{
    [ self.baseObj setObject:state forKey:@"State" ];
}

@end
