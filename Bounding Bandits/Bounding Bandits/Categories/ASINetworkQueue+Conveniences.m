//
//  ASINetworkQueue+Conveniences.m
//  SellIT2
//
//  Created by Niels Gabel on 1/3/12.
//  Copyright (c) 2012 DoubleDutch Inc. All rights reserved.
//

#import "ASINetworkQueue+Conveniences.h"

static ASINetworkQueue * __sharedQueue = nil ;

@implementation ASINetworkQueue (Conveniences)

+(void)load
{
	@autoreleasepool {
		__sharedQueue = [[ ASINetworkQueue alloc ] init ] ;
		__sharedQueue.maxConcurrentOperationCount = MAX_CONCURRENT_NETWORK_OPERATIONS ;
		[ __sharedQueue go ] ;
	}
}

+(id)networkRequestQueue 
{
	return __sharedQueue ;
}

@end
