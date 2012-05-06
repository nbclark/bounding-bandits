//
//  AnimationDelegate.m
//  SellIT2
//
//  Created by Niels Gabel on 12/14/11.
//  Copyright (c) 2011 DoubleDutch Inc. All rights reserved.
//

#import "AnimationDelegate.h"

@implementation AnimationDelegate

@synthesize startBlock ;
@synthesize stopBlock ;

- (void)animationDidStart:(CAAnimation *)anim
{
	if ( self.startBlock ) { startBlock(anim); }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	if ( self.stopBlock ) { stopBlock(anim, flag ) ; }
}

+(id)delegateWithStartBlock:(void (^)(CAAnimation *))startBlock
				   endBlock:(void (^)(CAAnimation*, BOOL))stopBlock
{
	AnimationDelegate * result = [ [ self alloc ] init ] ;
	result.startBlock = startBlock ;
	result.stopBlock = stopBlock ;
	
	return result ;
}

+(id)delegateWithEndBlock:(void (^)(CAAnimation*, BOOL))stopBlock
{
	return [ self delegateWithStartBlock:nil endBlock:stopBlock ] ;
}

@end
