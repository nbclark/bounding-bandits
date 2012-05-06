//
//  BBViewController.h
//  Bounding Bandits
//
//  Created by Nicholas Clark on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBGameDelegate.h"

@interface BBViewController : UIViewController<UIWebViewDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIPopoverController* popoverController;
@property (nonatomic, strong) UINavigationController* modalNavController;
@property (nonatomic, strong) IBOutlet UINavigationController* navController;
@property (nonatomic, strong) IBOutlet UIWebView* webView;
@property (nonatomic, strong) IBOutlet UIView* dimmingView;
@property (nonatomic, strong) IBOutlet UITableView* tableView;

@end
