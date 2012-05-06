//
//  BlitzGame.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BlitzGame.h"

@implementation BlitzGame

+(id)object
{
    return [ PFObjectExt objectWithClassName:@"BlitzGame" ];
}

-(PFUser*)user
{
    return [ self.baseObj objectForKey:@"User" ];
}

-(void)setUser:(PFUser *)user
{
    [ self.baseObj setObject:user forKey:@"User" ];
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

-(NSUInteger)moves
{
    return [[ self.baseObj objectForKey:@"Moves" ] intValue ];
}

-(void)setMoves:(NSUInteger)moves
{
    [ self.baseObj setObject:[ NSNumber numberWithUnsignedInteger:moves ] forKey:@"Moves" ];
}

-(NSUInteger)captures
{
    return [[ self.baseObj objectForKey:@"Captures" ] intValue ];
}

-(void)setCaptures:(NSUInteger)captures
{
    [ self.baseObj setObject:[ NSNumber numberWithUnsignedInteger:captures ] forKey:@"Captures" ];
}

-(NSUInteger)bestSolutions
{
    return [[ self.baseObj objectForKey:@"BestSolutions" ] intValue ];
}

-(void)setBestSolutions:(NSUInteger)bestSolutions
{
    [ self.baseObj setObject:[ NSNumber numberWithUnsignedInteger:bestSolutions ] forKey:@"BestSolutions" ];
}

-(void)calculateScore
{
    //
}

-(NSUInteger)score
{
    return [[ self.baseObj objectForKey:@"Score" ] intValue ];
}

-(void)setScore:(NSUInteger)score
{
    [ self.baseObj setObject:[ NSNumber numberWithUnsignedInteger:score ] forKey:@"Score" ];
}

@end
