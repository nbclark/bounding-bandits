//
//  FacebookFriend.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FacebookFriend.h"

@implementation FacebookFriend

@synthesize name;
@synthesize userId;
@synthesize user;

-(id)initWithId:(NSString*)_userId name:(NSString*)_name
{
    if ((self = [ super init ]))
    {
        self.userId = userId;
        self.name = name;
    }
    
    return self;
}

-(NSComparisonResult)sortByLoyalty:(FacebookFriend*)b
{
    if (self.user && !b.user)
    {
        return NSOrderedAscending;
    }
    else if (!self.user && b.user)
    {
        return NSOrderedDescending;
    }
    
    return [ self.name compare:b.name ];
}

@end
