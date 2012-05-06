//
//  UIResponder+ActionPerforming.h
//  SellIT2
//
//  Created by Nicholas Clark on 12/9/11.
//  Copyright (c) 2011 DoubleDutch Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (ActionPerforming)

+(BOOL)sendAction:(SEL)action to:(UIResponder*)firstTarget withArgument:(id)obj0 withArgument:(id)obj1 ;
+(BOOL)sendAction:(SEL)action to:(UIResponder*)firstTarget withArgument:(id)obj0 ;
+(BOOL)sendAction:(SEL)action to:(UIResponder*)firstTarget ;

@end
