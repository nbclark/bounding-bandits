//
//  BBGameCell.h
//  Bounding Bandits
//
//  Created by Nicholas Clark on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Models.h"

@interface BBGameCell : UITableViewCell

+(id)cell;
-(void)setValue:(CollabGame*)game asActive:(BOOL)asActive asCompleted:(BOOL)asCompleted;

@end
