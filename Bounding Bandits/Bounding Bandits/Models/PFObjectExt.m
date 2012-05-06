//
//  PFObjectExt.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PFObjectExt.h"

@implementation PFObjectExt

@synthesize baseObj;

+(NSMutableArray*)arrayWithArray:(NSArray*)objects className:(NSString*)className
{
    NSMutableArray* arr = [ NSMutableArray array ];
    
    for (PFObject* obj in objects)
    {
        [ arr addObject:[[ NSClassFromString(className) alloc ] initWithObject:obj ]];
    }
    
    return arr;
}

+(id)objectWithClassName:(NSString*)className
{
    PFObject* obj = [ PFObject objectWithClassName:className ];
    
    return [[ NSClassFromString(className) alloc ] initWithObject:obj ];
}

+(id)objectWithObject:(PFObject*)obj
{    
    return [[ NSClassFromString(obj.className) alloc ] initWithObject:obj ];
}

-(id)initWithObject:(PFObject*)obj
{
    if ((self = [ super init ]))
    {
        self.baseObj = obj;
        [ obj fetchIfNeeded ];
        
        [ self prepare ];
    }
    
    return self;
}

-(void)prepare
{
    //
}

-(void)save
{
    NSError* err;
    [ self.baseObj save:&err ];
    
    if (err)
    {
        sleep(0);
    }
}

-(void)saveInBackground
{
    [ self.baseObj saveInBackground ];
}

-(NSString*)objectId
{
    return self.baseObj.objectId;
}

-(NSDate*)createdAt
{
    return self.baseObj.createdAt;
}

-(NSDate*)updatedAt
{
    return self.baseObj.updatedAt;
}

@end
