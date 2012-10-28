//
//  BBResultsCell.h
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Models.h"

@protocol BBShowReplayDelegate

@required
-(void)selectCell:(id)cell;

@end

@interface BBResultsCell : UITableViewCell<UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIButton* moves1;
@property (nonatomic, strong) IBOutlet UIButton* moves2;

@property (nonatomic, strong) IBOutlet UILabel* roundLabel;
@property (nonatomic, strong) IBOutlet UIWebView* replayView;

@property (nonatomic, strong) CollabRound* round1;
@property (nonatomic, strong) CollabRound* round2;

@property (nonatomic) BOOL replayVisible;
@property (nonatomic) BOOL user1Active;

@property (nonatomic, strong) id<BBShowReplayDelegate> delegate;

+(id)cell;

-(void)setValue:(NSUInteger)roundNumber round1:(CollabRound*)_round1 round2:(CollabRound*)_round2;

@end
