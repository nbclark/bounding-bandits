//
//  PFObjectExt.h
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Parse/Parse.h>

@interface PFObjectExt : NSObject

+(NSMutableArray*)arrayWithArray:(NSArray*)objects className:(NSString*)className;
+(id)objectWithClassName:(NSString*)className;
+(id)objectWithObject:(PFObject*)obj;
-(id)initWithObject:(PFObject*)obj;
-(void)prepare;
-(void)saveInBackground;
-(void)save;

@property (nonatomic, strong) PFObject* baseObj;

@property (nonatomic, readonly) NSString* objectId;
@property (nonatomic, readonly) NSDate* createdAt;
@property (nonatomic, readonly) NSDate* updatedAt;

@end
