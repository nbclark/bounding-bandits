//
//  BBResultsHeaderView.h
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Models.h"

@interface BBResultsHeaderView : UIView

@property (nonatomic, strong) IBOutlet UIImageView* profileImage1;
@property (nonatomic, strong) IBOutlet UIImageView* profileImage2;
@property (nonatomic, strong) IBOutlet UILabel* score1;
@property (nonatomic, strong) IBOutlet UILabel* score2;
@property (nonatomic, strong) CollabGame* game;

+(id)headerWithGame:(CollabGame*)game;

@end
