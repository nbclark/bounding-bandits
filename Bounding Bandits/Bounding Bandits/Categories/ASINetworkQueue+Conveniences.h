//
//  ASINetworkQueue+Conveniences.h
//  SellIT2
//
//  Created by Niels Gabel on 1/3/12.
//  Copyright (c) 2012 DoubleDutch Inc. All rights reserved.
//

#import "ASINetworkQueue.h"

#define MAX_CONCURRENT_NETWORK_OPERATIONS 3

@interface ASINetworkQueue (Conveniences)

+(id)networkRequestQueue ;

@end
