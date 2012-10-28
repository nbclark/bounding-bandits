//
//  BBAppDelegate.h
//  test
//
//  Created by Nicholas Clark on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class BBMainViewController;

#define kBB_FBFriends @"BB_FBFriends"
#define kBB_LastSyncFBFriends @"BB_LastSyncFBFriends"
#define kBB_TWFriends @"BB_TWFriends"
#define kBB_LastSyncTWFriends @"BB_LastSyncTWFriends"

@interface BBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) BBMainViewController *viewController;
@property (strong, nonatomic) NSArray* gamePieces;
@property (nonatomic) BOOL isOnline;
@property (nonatomic) BOOL isUpgraded;
@property (nonatomic) BOOL isInGame;

+(BBAppDelegate*)sharedDelegate;
-(void)saveSetting:(id)object forKey:(NSString*)key;
-(id)getSetting:(NSString*)key;
-(void)quitGame;

@end
