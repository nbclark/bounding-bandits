//
//  UIWebViewController.h
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBGameDelegate.h"

@interface UIWebViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIWebView* webView;
@property (nonatomic, readwrite) BOOL isLoading;
@property (nonatomic, strong) id<BBGameDelegate> gameDelegate;

@end
