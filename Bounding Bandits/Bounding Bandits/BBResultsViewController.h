//
//  BBResultsViewController.h
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Models.h"

@protocol PopoverDelegate <NSObject>

-(void)dismissPopover;

@end

@interface BBResultsViewController : UITableViewController

@property (nonatomic, strong) CollabGame* game;
@property (nonatomic, assign) id<PopoverDelegate> delegate;
@property (nonatomic) BOOL showStart;

@end
