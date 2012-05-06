//
//  ASIHTTPRequest+DD.m
//  SellIT2
//
//  Created by Niels Gabel on 1/4/12.
//  Copyright (c) 2012 DoubleDutch Inc. All rights reserved.
//

#import "ASIHTTPRequest+DD.h"
#import "ASINetworkQueue+Conveniences.h"

@implementation ASIHTTPRequest ( DD )

+(void)fetchImage:(NSURL*)url 
  completionBlock:(void(^)(ASIHTTPRequest * request, UIImage * image))completionBlock
	  failedBlock:(void(^)(ASIHTTPRequest * request))failedBlock
{
	ASIHTTPRequest * request = [ ASIHTTPRequest requestWithURL:url ] ;
	[ request setHTTPCompletionBlock:^(ASIHTTPRequest * request) {
		UIImage * image = [ UIImage imageWithData:[ request responseData ] ] ;
		if ( completionBlock) { completionBlock( request, image ) ; }
	}];
	[ request setFailedBlock:^(ASIHTTPRequest * request) {
		if ( failedBlock ) { failedBlock( request ) ; }
	}];
	
	[ [ ASINetworkQueue networkRequestQueue ] addOperation:request ] ;
}

@end
