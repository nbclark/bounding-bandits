//
//  BBPeopleViewController.h
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIWebViewController.h"
#import "BBGameDelegate.h"

@interface BBPeopleViewController : UIViewController

@property (nonatomic, strong) id<BBGameDelegate> gameDelegate;

-(void)show;
-(IBAction)randomGameClicked:(id)sender;

@end
