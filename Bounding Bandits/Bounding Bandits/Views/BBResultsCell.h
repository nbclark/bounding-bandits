//
//  BBResultsCell.h
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Models.h"

@interface BBResultsCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel* moves1;
@property (nonatomic, strong) IBOutlet UILabel* moves2;

@property (nonatomic, strong) IBOutlet UILabel* time1;
@property (nonatomic, strong) IBOutlet UILabel* time2;

@property (nonatomic, strong) CollabRound* round1;
@property (nonatomic, strong) CollabRound* round2;

+(id)cell;

-(void)setValue:(CollabRound*)round1 round2:(CollabRound*)round2;

@end
