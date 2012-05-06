//
//  BBSettingsViewController.h
//  Bounding Bandits
//
//  Created by Nicholas Clark on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBGameDelegate.h"

@interface BBSettingsViewController : UIViewController<BBGameDelegate>

@property (nonatomic, strong) id<BBGameDelegate> gameDelegate;

@end
