//
//  MessageView.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MessageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MessageView

@synthesize label = _label, activityIndicator = _activityIndicator, messageFrame = _messageFrame ;
@synthesize showMessageFrame;

-(UILabel *)label
{
	if ( !_label )
	{
		UILabel * label = [[ UILabel alloc ] initWithFrame:CGRectZero ] ;
		label.backgroundColor = [ UIColor clearColor ] ;
		label.opaque = NO ;
		
		[ self addSubview:label ] ;
		_label = label ;
	}
	
	return _label ;
}

-(UIActivityIndicatorView *)activityIndicator
{
	if ( !_activityIndicator )
	{
		UIActivityIndicatorView * activityIndicator = [[ UIActivityIndicatorView alloc ] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray ] ;
		
		[ self addSubview:activityIndicator ] ;
		
		_activityIndicator = activityIndicator ;
	}
	
	return _activityIndicator ;
}

-(UIView *)messageFrame
{
	if ( !_messageFrame )
	{
		UIView * messageFrame = [[ UIView alloc ] initWithFrame:CGRectZero ] ;
		messageFrame.backgroundColor = [ UIColor whiteColor ];
        messageFrame.layer.borderWidth = 2;
        messageFrame.layer.borderColor = [[ UIColor blackColor ] CGColor ];
        
		[ self insertSubview:messageFrame belowSubview:[ self.subviews objectAtIndex:0] ] ;
		
		_messageFrame = messageFrame ;
	}
	
	return _messageFrame ;
}


-(void)sizeToFit
{
	CGSize size = self.activityIndicator.frame.size ;
	[ self.label sizeToFit ] ;
    
	size.height = MAX( size.height, self.label.frame.size.height ) ;
	size.width = size.width + 12.0f + self.label.frame.size.width ;
	
	size.width += 20.0f ;
	size.height += 20.0f ;
	
	CGRect bounds = self.bounds ;
	bounds.size = size ;
	
	//self.bounds = bounds ;
}

-(void)layoutSubviews
{
	CGRect bounds = self.bounds ;
	//bounds = UIEdgeInsetsInsetRect( bounds, (const UIEdgeInsets){ 10.0f, 10.0f, 10.0f, 10.0f }) ;
    
    float width = self.activityIndicator.bounds.size.width + self.label.bounds.size.width;
    float labelW = self.label.bounds.size.width;
    float activW = self.activityIndicator.bounds.size.width;
	
    if (self.showMessageFrame)
    {
        self.messageFrame.bounds = CGRectMake(0, 0, width + 100, self.label.bounds.size.height + 70);
    }
    
	self.activityIndicator.center = CGPointMake(bounds.size.width / 2 - labelW / 2, bounds.size.height / 2);
    
	self.label.center = CGPointMake(bounds.size.width / 2 + activW, bounds.size.height / 2);
    self.messageFrame.center = CGPointMake(bounds.size.width / 2, bounds.size.height / 2);
}

@end