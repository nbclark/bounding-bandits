//
//  BBAppDelegate.m
//  Bouncing Bandites
//
//  Created by Nicholas Clark on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBAppDelegate.h"
#import "BBViewController.h"
#import "BBSignUpViewController.h"
#import "BBLoginViewController.h"
#import "BBLoginViewController2.h"
#import "BBMainViewController.h"
#import "BBNavigationController.h"
#import "Utils.h"
#import "TestFlight.h"
#import <Parse/Parse.h>

@interface BBAppDelegate()<PFLogInViewControllerDelegate>

@end

@implementation BBAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize gamePieces = _gamePieces;
@synthesize isOnline;
@synthesize isUpgraded;
@synthesize isInGame;

static BBAppDelegate* _sharedDelegate;

+(BBAppDelegate*)sharedDelegate
{
    return _sharedDelegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.isUpgraded = NO;
    
    // Use the product identifier from iTunes to register a handler.
    [PFPurchase addObserverForProduct:@"MMMultiMode" block:^(SKPaymentTransaction *transaction) {
        // Write business logic that should run once this product is purchased.
        self.isUpgraded = YES;
    }];
    
    _sharedDelegate = self;

    [ [UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone ];
    
    [ application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound ];
    
    [[ NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(userDidLogIn) name:@"kUserDidLogIn" object:nil ];
    
    PFUser* currentUser = [PFUser currentUser];
    
    self.isOnline = YES;
    
    if (![ Utils isNetworkReachable ])
    {
        self.isOnline = NO;
    }
    
	[NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(checkConnectivity) userInfo:nil repeats:YES];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //self.viewController = [[BBViewController alloc] initWithNibName:@"BBViewController" bundle:nil];
    self.viewController = [[BBMainViewController alloc] initWithNibName:@"BBMainViewController" bundle:nil];
    self.viewController.wantsFullScreenLayout = YES;
    
    UINavigationController* nav = [[ UINavigationController alloc ] initWithRootViewController:self.viewController ];
    
    nav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    nav.navigationBarHidden = NO;
    nav.wantsFullScreenLayout = YES;
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    if (!self.isOnline)
    {
        return YES;
    }
    
    if (!currentUser)
    {
        [ NSUserDefaults resetStandardUserDefaults ];
        [[ NSUserDefaults standardUserDefaults ] synchronize ];
        
        BBLoginViewController* loginViewController = [[ BBLoginViewController alloc ] init ];
        loginViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        //loginViewController.wantsFullScreenLayout = YES;
        /*
        BBLoginViewController2* loginViewController = [[ BBLoginViewController2 alloc ] initWithNibName:@"BBLoginViewController2" bundle:[ NSBundle mainBundle ]];
         
         */
        
        BBNavigationController* nav = [[ BBNavigationController alloc ] initWithRootViewController:loginViewController ];
        nav.navigationBarHidden = YES;
        
        [ self.viewController addChildViewController:nav ];
        [ self.viewController.view addSubview:nav.view ];
        
        
        nav.view.frame = CGRectMake(0,0,542,500);
        
        nav.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        nav.view.center = self.viewController.view.center;
        // [ nav presentModalViewController:loginViewController animated:YES ];
    }
    else
    {
        [[ NSNotificationCenter defaultCenter ] postNotificationName:@"kUserDidLogIn" object:nil ];
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"GamePiece"];
    query.maxCacheAge = 60 * 60 * 24 * 7; // 1 week
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    
    self.gamePieces = [ query findObjects ];
    
    [ self applyTheme ];
    
    return YES;
}

-(void)applyTheme
{
    NSString* fontName = @"Airplane";

	//[[ UILabel appearance ] setFont:[ UIFont fontWithName:fontName size:16.0f ] ] ;
	//[[ UILabel appearanceWhenContainedIn:[ UISearchBar class ], nil ] setFont:[ UIFont fontWithName:fontName size:14.0f ] ] ;	
    
	//[[ UIButton appearance ] setFont:[ UIFont fontWithName:fontName size:16.0f ] ] ;
}

-(void)saveSetting:(id)object forKey:(NSString*)key
{
    [[ NSUserDefaults standardUserDefaults ] setObject:object forKey:key ];
    [[ NSUserDefaults standardUserDefaults ] synchronize ];
}

-(id)getSetting:(NSString*)key
{
    return [[ NSUserDefaults standardUserDefaults ] objectForKey:key ];
}

-(void)checkConnectivity
{
    if (![ Utils isNetworkReachable ])
    {
        // Lost network, do something...
        if (self.isOnline)
        {
            self.isOnline = NO;
            [[ NSNotificationCenter defaultCenter ] postNotificationName:@"kConnectionLost" object:nil ];
        }
    }
    else
    {
        if (!self.isOnline)
        {
            self.isOnline = YES;
            [[ NSNotificationCenter defaultCenter ] postNotificationName:@"kConnectionGained" object:nil ];
        }
    }
}

-(void)userDidLogIn
{
    if ([[[ PFUser currentUser ] objectForKey:@"receiveNotifications" ] boolValue ])
    {
        [ PFPush subscribeToChannelInBackground:[ PFUser currentUser ].objectId ];
    }
}

-(void)quitGame
{
    [ self.viewController showMenu ];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    // Tell Parse about the device token.
    [PFPush storeDeviceToken:newDeviceToken];
    // Subscribe to the global broadcast channel.
    [PFPush subscribeToChannelInBackground:@""];
}
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err 
{ 
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(str);    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [PFFacebookUtils handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [PFFacebookUtils handleOpenURL:url]; 
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
