//
//  NSThread+BlockPerform.h
//  SellIT2
//
//  Created by Niels Gabel on 12/9/11.
//  Copyright (c) 2011 DoubleDutch Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSThread (BlockPerform)

- (void)performBlock:(void (^)())block;
- (void)performBlock:(void (^)())block waitUntilDone:(BOOL)wait;
+ (void)performBlockInBackground:(void (^)())block;

@end
