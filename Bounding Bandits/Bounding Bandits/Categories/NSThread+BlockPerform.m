//
//  NSThread+BlockPerform.m
//  SellIT2
//
//  Created by Niels Gabel on 12/9/11.
//  Copyright (c) 2011 DoubleDutch Inc. All rights reserved.
//

// Taken from http://www.informit.com/blogs/blog.aspx?uk=Ask-Big-Nerd-Ranch-Blocks-in-Objective-C

#import "NSThread+BlockPerform.h"

@implementation NSThread (BlockPerform)

- (void)performBlock:(void (^)())block
{
	if ([[NSThread currentThread] isEqual:self])
	{
		block();
	}
	else
	{
		[self performBlock:block waitUntilDone:NO];
	}
}

- (void)performBlock:(void (^)())block waitUntilDone:(BOOL)wait
{
    [NSThread performSelector:@selector(ng_runBlock:)
                     onThread:self
                   withObject:[block copy]
                waitUntilDone:wait];
}

+ (void)ng_runBlock:(void (^)())block
{
	block();
}

+ (void)performBlockInBackground:(void (^)())block
{
	[NSThread performSelectorInBackground:@selector(ng_runBlock:)
	                           withObject:[ block copy ] ];
}

@end
