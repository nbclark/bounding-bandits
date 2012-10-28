//
//  MessageView.h
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessageViewDelegate

@required
-(void)quitTapped;

@end

@interface MessageView : UIButton
@property ( nonatomic, strong, readonly ) UIView * messageFrame ;
@property ( nonatomic, strong, readonly ) UILabel * label ;
@property ( nonatomic, strong, readonly ) UIButton * button ;
@property ( nonatomic, strong, readonly ) UIButton * quitButton ;
@property ( nonatomic, strong, readonly ) UIActivityIndicatorView * activityIndicator ;
@property ( nonatomic ) BOOL showMessageFrame ;
@property (nonatomic, strong) id<MessageViewDelegate> delegate;
@end
