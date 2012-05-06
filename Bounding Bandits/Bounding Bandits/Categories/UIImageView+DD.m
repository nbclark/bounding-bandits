//
//  UIImageView+DD.m
//  SellIT2
//
//  Created by Niels Gabel on 2/8/12.
//  Copyright (c) 2012 DoubleDutch Inc. All rights reserved.
//

#import "UIImageView+DD.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue+Conveniences.h"
#import "ASIDownloadCache.h"

#import <QuartzCore/QuartzCore.h>

@interface UIImageView (DD_Private)
@property ( nonatomic, copy ) NSURL * imageURL ;
@property ( nonatomic, strong ) ASIHTTPRequest * loadImageRequest ;
@end

@implementation UIImageView (DD)
@dynamic imageURL ;

-(void)loadImageWithURL:(NSURL*)url onComplete:(void (^)())onComplete
{
	if ( url.absoluteString.length > 0 && (!self.image || ![ url isEqual:self.imageURL ] ))
	{
		[ self cancelLoadImageWithURL ] ;
		self.image = nil ;
		self.imageURL = url ;
		
		NSData * data = [[ ASIDownloadCache sharedCache ] cachedResponseDataForURL:url ] ;
		if ( data.length > 0 )
		{
			self.image = [ UIImage imageWithData:data ] ;
		}
		else 
		{
			ASIHTTPRequest * request = [ ASIHTTPRequest requestWithURL:url usingCache:[ ASIDownloadCache sharedCache ] andCachePolicy:ASICachePermanentlyCacheStoragePolicy ] ;
            request.password = [ url absoluteString ];
            
			[ request setHTTPCompletionBlock:^(ASIHTTPRequest * request) {
                
                if ([[ self.imageURL absoluteString ] isEqualToString:request.password ])
                {
                    self.image = [ UIImage imageWithData:request.responseData ] ;
                    self.loadImageRequest = nil ;
                }
                else {
                    sleep(0);
                }
                
                if (onComplete)
                {
                    onComplete();
                }
			}];
			[ request setFailedBlock:^(ASIHTTPRequest * request) {
				//DebugLog(@"Failed to load image %@\n", request.url) ;
				self.loadImageRequest = nil ;
				BOOL cancelled = request.isCancelled || ( request.error.domain == NetworkRequestErrorDomain && request.error.code == ASIRequestCancelledErrorType ) ;
				
				if ( !cancelled )
				{
					// [ self performSelectorOnMainThread:@selector( loadImageWithURL: ) withObject:request.url waitUntilDone:NO ] ;
				}
			}];
			[[ ASINetworkQueue networkRequestQueue ] addOperation:request ] ;
		}
	}
}

-(void)cancelLoadImageWithURL
{
    if (self.loadImageRequest)
    {
        [ self.loadImageRequest cancel ] ;
        self.loadImageRequest = nil ;
        self.imageURL = nil;
    }
}

@end

@implementation UIImageView (DD_Private)

-(void)setImageURL:(NSURL *)imageURL
{
	[ self.layer setValue:imageURL forKey:@"DDImageURL" ] ;
}

-(NSURL *)imageURL
{
	return [ self.layer valueForKey:@"DDImageURL" ] ;
}

-(void)setLoadImageRequest:(ASIHTTPRequest *)loadImageRequest
{
	[self.layer setValue:loadImageRequest forKey:@"DDLoadImageRequest" ] ;
}

-(ASIHTTPRequest*)loadImageRequest
{
	return [ self.layer valueForKey:@"DDLoadImageRequest" ] ;
}

@end
