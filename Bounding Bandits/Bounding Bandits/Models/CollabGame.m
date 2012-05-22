//
//  CollabGame.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CollabGame.h"
#import "CollabRound.h"

@implementation CollabGame

+(id)object
{
    return [ PFObjectExt objectWithClassName:@"CollabGame" ];
}

-(void)prepare
{
    [ PFObject fetchAllIfNeeded:self.users ];
    //[ PFObject fetchAllIfNeeded:self.rounds ];
}

-(PFUser*)otherUser
{
    PFUser* user1 = [ self.users objectAtIndex:0 ];
    PFUser* user2 = [ self.users objectAtIndex:1 ];
    
    if ([[ PFUser currentUser ].objectId isEqualToString:user1.objectId ])
    {
        return user2;
    }
    
    return user1;
}

-(BOOL)didUser:(PFUser*)user winRound:(NSUInteger)round
{
    NSArray* rounds = self.rounds;
    
    if ([ rounds count ] < (round+1)*2)
    {
        return NO;
    }
    
    CollabRound* roundA = [ CollabRound objectWithObject:[ rounds objectAtIndex:round*2 ]];
    CollabRound* roundB = [ CollabRound objectWithObject:[ rounds objectAtIndex:round*2+1 ]];
    
    if (!roundA.completed || !roundB.completed)
    {
        return NO;
    }
    
    if ([ user.objectId isEqualToString:roundA.userId ])
    {
        return roundA.moves <= roundB.moves;
    }
    
    return roundB.moves <= roundA.moves;
}

-(NSMutableDictionary*)scoresForUsers
{
    NSArray* users = self.users;
    NSArray* rounds = self.rounds;
    
    NSUInteger userCount = [ users count ];
    NSUInteger roundCount = floor([ rounds count ] / userCount) * userCount;
    NSMutableDictionary* userScores = [ NSMutableDictionary dictionaryWithCapacity:userCount ];
    
    for (uint i = 0; i < userCount; ++i)
    {
        [ userScores setValue:[ NSNumber numberWithInteger:0 ] forKey:((PFUser*)[ users objectAtIndex:i ]).objectId ];
    }
    
    for (uint i = 0; i < roundCount; i += userCount)
    {
        NSMutableArray* bestRounds = [ NSMutableArray array ];
        NSUInteger bestMoves = NSUIntegerMax;
        
        for (uint u = 0; u < userCount; ++u)
        {
            if ([ rounds count ] > i + u)
            {
                CollabRound* round = [ CollabRound objectWithObject:[ rounds objectAtIndex:i+u ]];
                
                if ( round.moves < bestMoves )
                {
                    bestMoves = round.moves;
                    
                    [ bestRounds removeAllObjects ];
                    [ bestRounds addObject:round.userId ];
                }
                else if (round.moves == bestMoves)
                {
                    [ bestRounds addObject:round.userId ];
                }
            }
        }
        
        if ([ bestRounds count ])
        {
            for (NSString* userId in bestRounds)
            {
                uint newScore = [[ userScores objectForKey:userId] intValue ] + 1;
                
                [ userScores setValue:[ NSNumber numberWithInt:newScore ] forKey:userId];
            }
        }
    }
    
    return userScores;
}

-(NSString*)state
{
    return [ self.baseObj objectForKey:@"State" ];
}

-(void)setState:(NSString *)state
{
    [ self.baseObj setObject:state forKey:@"State" ];
}

-(PFUser*)activeUser
{
    return [ self.baseObj objectForKey:@"ActiveUser" ];
}

-(void)setActiveUser:(PFUser *)activeUser
{
    [ self.baseObj setObject:activeUser forKey:@"ActiveUser" ];
}

-(PFUser*)creator
{
    return [ self.baseObj objectForKey:@"Creator" ];
}

-(void)setCreator:(PFUser *)creator
{
    [ self.baseObj setObject:creator forKey:@"Creator" ];
}

-(NSMutableArray*)users
{
    return [ self.baseObj objectForKey:@"Users" ];
}

-(void)setUsers:(NSMutableArray *)users
{
    [ self.baseObj setObject:users forKey:@"Users" ];
}

-(NSMutableArray*)rounds
{
    return [ self.baseObj objectForKey:@"Turns" ];
}

-(void)setRounds:(NSMutableArray *)rounds
{
    [ self.baseObj setObject:rounds forKey:@"Turns" ];
}

-(NSMutableArray*)legacyRounds
{
    return [ self.baseObj objectForKey:@"Rounds" ];
}

-(void)setLegacyRounds:(NSMutableArray *)legacyRounds
{
    [ self.baseObj setObject:legacyRounds forKey:@"Rounds" ];
}

-(NSUInteger)tokenCount
{
    return [[ self.baseObj objectForKey:@"TokenCount" ] integerValue ];
}

-(void)setTokenCount:(NSUInteger)tokenCount
{
    [ self.baseObj setObject:[ NSNumber numberWithInteger:tokenCount ] forKey:@"TokenCount" ];
}

-(BOOL)completed
{
    return [[ self.baseObj objectForKey:@"Completed" ] boolValue ];
}

-(void)setCompleted:(BOOL)completed
{
    [ self.baseObj setObject:[ NSNumber numberWithBool:completed ] forKey:@"Completed" ];
}

@end
