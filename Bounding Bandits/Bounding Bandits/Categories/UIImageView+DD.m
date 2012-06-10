//
//  UIImageView+DD.m
//  Hive
//
//  Created by Hive on 2/8/12.
//  Copyright (c) 2012 DoubleDutch Inc. All rights reserved.
//

#import "UIImageView+DD.h"
#import "ASINetworkQueue+Conveniences.h"
#import "ASIDownloadCache.h"
#import "NSThread+BlockPerform.h"
#import <QuartzCore/QuartzCore.h>

@implementation DDImageManager

+(UIImage*)NoFaceImage
{
    static UIImage* noFaceImage = nil;
    
    if (!noFaceImage)
    {
        noFaceImage = [ UIImage imageNamed:@"img/noface.png" ];
    }
    
    return noFaceImage;
}

+(void)LoadImageWithUrl:(NSURL *)url imageControl:(id<DDImageControl>)imageControl defaultImage:(UIImage*)defaultImage onComplete:(void (^)())onComplete
{
	if ( url.absoluteString.length > 0 && (!imageControl.image || ![ url isEqual:imageControl.imageURL ] ))
	{
		[ imageControl cancelLoadImageWithURL ] ;
		imageControl.image = defaultImage;
		imageControl.imageURL = url ;
        
		NSData * data = [[ ASIDownloadCache sharedCache ] cachedResponseDataForURL:url ] ;
		if ( data.length > 0 )
		{
			imageControl.image = [ UIImage imageWithData:data ] ;
		}
		else 
		{
			ASIHTTPRequest * request = [ ASIHTTPRequest requestWithURL:url usingCache:[ ASIDownloadCache sharedCache ] andCachePolicy:ASICachePermanentlyCacheStoragePolicy ] ;
			[ request setHTTPCompletionBlock:^(ASIHTTPRequest * request)
             {
                 if ([[ imageControl.imageURL absoluteString ] isEqualToString:[ request.url absoluteString ]])
                 {
                     UIImage* img = [ UIImage imageWithData:request.responseData ] ;
                     
                     if ([ img size ].height)
                     {
                         imageControl.image = img;
                     }
                     
                     imageControl.loadImageRequest = nil ;
                 }
                 else {
                     sleep(0);
                 }
                 //				if ( block ) { block( self.image, nil ) ; }
                 if (onComplete)
                 {
                     onComplete();
                 }
             }];
			[ request setFailedBlock:^(ASIHTTPRequest * request) {
				//DebugLog(@"Failed to load image %@\n", request.url) ;
				imageControl.loadImageRequest = nil ;
				BOOL cancelled = request.isCancelled || ( request.error.domain == NetworkRequestErrorDomain && request.error.code == ASIRequestCancelledErrorType ) ;
				
				if ( !cancelled )
				{
                    [[ NSThread mainThread ] performBlock:^{
                        [ self LoadImageWithUrl:url imageControl:imageControl defaultImage:defaultImage onComplete:onComplete ];
                    } ];
				}
                
                //				if ( block ) { block( nil, request.error ) ; }
			}];
			[[ ASINetworkQueue networkRequestQueue ] addOperation:request ] ;
		}
	}
    else
    {
		imageControl.image = defaultImage;
    }
}

@end

@implementation UIImageView (NetworkLoading)
@dynamic imageURL ;
@dynamic image;

//-(void)loadImageWithURL:(NSURL*)url 
//{
//	[ self loadImageWithURL:url completionBlock:nil ] ;
//}

-(void)loadImageWithURL:(NSURL*)url defaultImage:(UIImage*)defaultImage onComplete:(void (^)())onComplete
{
    [ DDImageManager LoadImageWithUrl:url imageControl:self defaultImage:defaultImage onComplete:onComplete ];
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

@implementation UIButton (NetworkLoading)
@dynamic imageURL ;
@dynamic image;

-(UIImage*)image{
    return [ self imageForState:UIControlStateNormal ];
}

-(void)setImage:(UIImage *)image
{
    [ self setImage:image forState:UIControlStateNormal ];
}

//-(void)loadImageWithURL:(NSURL*)url 
//{
//	[ self loadImageWithURL:url completionBlock:nil ] ;
//}

-(void)loadImageWithURL:(NSURL*)url defaultImage:(UIImage*)defaultImage onComplete:(void (^)())onComplete
{
    [ DDImageManager LoadImageWithUrl:url imageControl:self defaultImage:defaultImage onComplete:onComplete ];
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
