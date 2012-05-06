//
//  UIImageView+DD.h
//  SellIT2
//
//  Created by Niels Gabel on 2/8/12.
//  Copyright (c) 2012 DoubleDutch Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (DD)

@property ( nonatomic, copy ) NSURL * imageURL ;

-(void)loadImageWithURL:(NSURL*)url onComplete:(void (^)())onComplete ;
-(void)cancelLoadImageWithURL ;


@end
