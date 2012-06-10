//
//  UIImageView+DD.h
//  Hive
//
//  Created by Hive on 2/8/12.
//  Copyright (c) 2012 DoubleDutch Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@protocol DDImageControl

@required
@property(nonatomic,retain) UIImage *image;
@property(nonatomic,copy) NSURL * imageURL ;
@property ( nonatomic, strong ) ASIHTTPRequest * loadImageRequest ;
-(void)cancelLoadImageWithURL;

@end

@interface DDImageManager

+(UIImage*)NoFaceImage;
+(void)LoadImageWithUrl:(NSURL*)url imageControl:(id<DDImageControl>)imageControl defaultImage:(UIImage*)defaultImage onComplete:(void (^)())onComplete;

@end

@interface UIImageView (NetworkLoading)<DDImageControl>

@property ( nonatomic, copy ) NSURL * imageURL ;
@property ( nonatomic, strong ) ASIHTTPRequest * loadImageRequest ;

-(void)loadImageWithURL:(NSURL*)url defaultImage:(UIImage*)defaultImage onComplete:(void (^)())onComplete ;
-(void)cancelLoadImageWithURL ;

@end

@interface UIButton (NetworkLoading)<DDImageControl>

@property ( nonatomic, copy ) NSURL * imageURL ;
@property ( nonatomic, retain ) UIImage * image ;
@property ( nonatomic, strong ) ASIHTTPRequest * loadImageRequest ;

-(void)loadImageWithURL:(NSURL*)url defaultImage:(UIImage*)defaultImage onComplete:(void (^)())onComplete ;
-(void)cancelLoadImageWithURL ;

@end
