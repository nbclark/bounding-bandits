//
//  BBAppDelegate.h
//  test
//
//  Created by Nicholas Clark on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class BBViewController;

#define kBB_FBFriends @"BB_FBFriends"
#define kBB_LastSyncFBFriends @"BB_LastSyncFBFriends"

@interface BBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) BBViewController *viewController;
@property (strong, nonatomic) NSArray* gamePieces;
@property (nonatomic) BOOL isOnline;

+(BBAppDelegate*)sharedDelegate;
-(void)saveSetting:(id)object forKey:(NSString*)key;
-(id)getSetting:(NSString*)key;

@end
