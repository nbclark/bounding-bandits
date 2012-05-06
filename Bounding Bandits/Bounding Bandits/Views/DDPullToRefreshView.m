//
//  DDPullToRefreshView.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DDPullToRefreshView.h"

@implementation DDPullToRefreshView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)init
{
    if (( self = [ super init ]))
    {
        _statusLabel.textColor = [ UIColor whiteColor ];
        _lastUpdatedLabel.textColor = [ UIColor whiteColor ];
        _activityView.color = [ UIColor whiteColor ];
        
        _statusLabel.layer.shadowRadius = 0;
        _lastUpdatedLabel.layer.shadowRadius = 0;
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
