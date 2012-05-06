//
//  Utils.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <sys/socket.h>
#import <netinet/in.h>

@implementation Utils

+(BOOL)isNetworkReachable
{
	// Create zero addy 
	struct sockaddr_in zeroAddress; 
	bzero(&zeroAddress, sizeof(zeroAddress)); 
	zeroAddress.sin_len = sizeof(zeroAddress); 
	zeroAddress.sin_family = AF_INET; 
	// Recover reachability flags 
	SCNetworkReachabilityRef defaultRouteReachability = 
	SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress); 
	SCNetworkReachabilityFlags flags; 
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags); 
	CFRelease(defaultRouteReachability); 
    
	if(!didRetrieveFlags)
    {
		return NO; 
	} 
    
	BOOL isReachable = flags & kSCNetworkFlagsReachable; 
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired; 
	return isReachable && !needsConnection;
}

+(NSDictionary*)dictionaryForArray:(NSArray*)objects
{
    NSMutableDictionary* dict = [ NSMutableDictionary dictionaryWithCapacity:[ objects count ] ];
    
    for (PFObject* obj in objects)
    {
        [ dict setObject:obj forKey:obj.objectId ];
    }
    
    return dict;
}

+(NSString*)stringForScores:(CollabGame*)game gameOver:(BOOL)gameOver
{
    NSDictionary* scores = [ game scoresForUsers ];
    NSArray* users = game.users;
    
    PFUser* user1 = [ users objectAtIndex:0 ];
    PFUser* user2 = [ users objectAtIndex:1 ];
    
    NSUInteger score1 = [[ scores objectForKey:user1.objectId ] intValue];
    NSUInteger score2 = [[ scores objectForKey:user2.objectId ] intValue];
    
    if (score1 == score2)
    {
        return [ NSString stringWithFormat:@"You are tied with %d tokens", score1, nil ];
    }
    else
    {
        BOOL selfIsP1 = [[ PFUser currentUser ].objectId isEqualToString:user1.objectId ];
        BOOL selfInLead = (score1 > score2 && selfIsP1) || (score2 > score1 && !selfIsP1);
        NSString* verb = (selfInLead) ? @"lead" : @"trail";
        NSUInteger yourScore = (selfIsP1) ? score1 : score2;
        NSUInteger theirScore = (!selfIsP1) ? score1 : score2;
        
        return [ NSString stringWithFormat:@"You %@ %d to %d tokens", verb, yourScore, theirScore ];
    }
    
    /*for (NSString* userId in scores)
    {
        NSUInteger score = [[ scores objectForKey:userId ] intValue];
        
        if (score > topScore)
        {
            [ topUsers removeAllObjects ];
            topScore = score;
        }
        
        if (score >= topScore)
        {
            [ topUsers addObject:userId ];
        }
    }
    
    if ( [ topUsers count ] == 1)
    {
        NSString* userId = [ topUsers objectAtIndex:0 ];
        
        PFUser* topUser = [ users objectForKey:userId];
        NSString* name = ([ topUser.objectId isEqualToString:[ PFUser currentUser ].objectId ]) ? @"You lead" : [ NSString stringWithFormat:@"%@ leads", [ topUser objectForKey:@"name" ]];
        
        return [ NSString stringWithFormat:@"%@ with %d", name, topScore, otherScore ];
    }
    else
    {
        return [ NSString stringWithFormat:@"%d users tied with %d", [ topUsers count ], topScore, nil ];
    }*/
}

@end
