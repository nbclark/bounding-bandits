//
//  ASIHTTPRequest+DD.h
//  SellIT2
//
//  Created by Niels Gabel on 1/4/12.
//  Copyright (c) 2012 DoubleDutch Inc. All rights reserved.
//

#import "ASIHTTPRequest.h"

@interface ASIHTTPRequest ( DD )

+(void)fetchImage:(NSURL*)url 
			 completionBlock:(void(^)(ASIHTTPRequest * request, UIImage * image))completionBlock
				 failedBlock:(void(^)(ASIHTTPRequest * request))failedBlock ;

@end
