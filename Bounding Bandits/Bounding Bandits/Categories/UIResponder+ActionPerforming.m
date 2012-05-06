//
//  UIResponder+ActionPerforming.m
//  SellIT2
//
//  Created by Nicholas Clark on 12/9/11.
//  Copyright (c) 2011 DoubleDutch Inc. All rights reserved.
//

#import "UIResponder+ActionPerforming.h"
#import <objc/objc.h>
#import <objc/message.h>

@implementation UIResponder (ActionPerforming)

+(BOOL)sendAction:(SEL)action to:(UIResponder*)firstTarget withArgument:(id)obj0 withArgument:(id)obj1
{
	UIResponder * target = firstTarget ;
	while( target )
	{
		if ( [target respondsToSelector:action ] )
		{
            //			[ target performSelector:action withObject:obj0 withObject:obj1 ] ;
			objc_msgSend(target, action, obj0, obj1);			
			return YES ;
		}
		target = [ target nextResponder ] ;
	}
	return NO ;
}

+(BOOL)sendAction:(SEL)action to:(UIResponder*)firstTarget withArgument:(id)obj0
{
	UIResponder * target = firstTarget ;
	while( target )
	{
		if ( [target respondsToSelector:action ] )
		{
            //			[ target performSelector:action withObject:obj0 ] ;
			objc_msgSend(target, action, obj0);			
			return YES ;
		}
		target = [ target nextResponder ] ;
	}
	return NO ;
}

+(BOOL)sendAction:(SEL)action to:(UIResponder*)firstTarget
{
	UIResponder * target = firstTarget ;
	while( target )
	{
		if ( [target respondsToSelector:action ] )
		{
            //			[ target performSelector:action ] ;
			objc_msgSend(target, action);			
			return YES ;
		}
		target = [ target nextResponder ] ;
	}
	return NO ;
}

@end
