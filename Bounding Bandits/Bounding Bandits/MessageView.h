//
//  MessageView.h
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageView : UIButton
@property ( nonatomic, strong, readonly ) UIView * messageFrame ;
@property ( nonatomic, strong, readonly ) UILabel * label ;
@property ( nonatomic, strong, readonly ) UIActivityIndicatorView * activityIndicator ;
@property ( nonatomic ) BOOL showMessageFrame ;
@end
