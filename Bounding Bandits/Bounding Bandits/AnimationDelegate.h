//
//  AnimationDelegate.h
//  SellIT2
//
//  Created by Niels Gabel on 12/14/11.
//  Copyright (c) 2011 DoubleDutch Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface AnimationDelegate : NSObject
@property ( nonatomic, copy ) void (^startBlock)( CAAnimation * anim ) ;
@property ( nonatomic, copy ) void (^stopBlock)( CAAnimation * anim, BOOL didFinish ) ;

+(id)delegateWithStartBlock:(void (^)(CAAnimation *))startBlock
				   endBlock:(void (^)(CAAnimation*, BOOL))endBlock ;
+(id)delegateWithEndBlock:(void (^)(CAAnimation*, BOOL))stopBlock ;

@end
