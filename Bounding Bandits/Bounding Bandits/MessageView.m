//
//  MessageView.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MessageView.h"
#import <QuartzCore/QuartzCore.h>
#import "BBAppDelegate.h"

@implementation MessageView

@synthesize label = _label, activityIndicator = _activityIndicator, messageFrame = _messageFrame ;
@synthesize button = _button;
@synthesize quitButton = _quitButton;
@synthesize delegate;

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

-(void)tapped:(id)sender
{
    [ self sendActionsForControlEvents:UIControlEventTouchUpInside ];
}

-(void)quitTapped:(id)sender
{
    [[ BBAppDelegate sharedDelegate ] quitGame ];
}

-(UIButton *)button
{
	if ( !_button )
	{
		UIButton * button = [[ UIButton alloc ] initWithFrame:CGRectZero ] ;
		button.backgroundColor = [ UIColor clearColor ] ;
		button.opaque = NO ;
        
        UIImage* img = [ UIImage imageNamed:@"img/btn-taptoplay.png" ] ;
        
        button.frame = CGRectMake(0,0,img.size.width,img.size.height);
        
        [ button setImage:img forState:UIControlStateNormal ];
        [ button setImage:[ UIImage imageNamed:@"img/btn-taptoplay-active.png" ] forState:UIControlStateHighlighted ];
		[ button addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside ];
		[ self addSubview:button ] ;
		_button = button ;
	}
	
	return _button ;
}

-(UIButton *)quitButton
{
	if ( !_quitButton )
	{
		UIButton * button = [[ UIButton alloc ] initWithFrame:CGRectZero ] ;
		button.backgroundColor = [ UIColor clearColor ] ;
		button.opaque = NO ;
        
        UIImage* img = [ UIImage imageNamed:@"img/close.png" ] ;
        
        button.frame = CGRectMake(0,0,img.size.width,img.size.height);
        
        [ button setImage:img forState:UIControlStateNormal ];
		[ button addTarget:self action:@selector(quitTapped:) forControlEvents:UIControlEventTouchUpInside ];
		[ self addSubview:button ] ;
		_quitButton = button ;
	}
	
	return _quitButton ;
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
		messageFrame.backgroundColor = [ UIColor blackColor ];
        
        UIImage* img = [ UIImage imageNamed:@"img/bg-interstitial.png" ];
        UIImageView* iv = [[ UIImageView alloc ] initWithImage:img];
        iv.frame = messageFrame.bounds;
        iv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        iv.opaque = NO;
        
        self.imageView.hidden = NO;
        self.imageView.image = img;
        self.imageView.contentMode = UIViewContentModeCenter;
        [ self.imageView sizeToFit ];
        self.imageView.center = CGRectGetCenter(self.bounds);
        
        //[ messageFrame addSubview:iv ];
        
        self.frame = CGRectMake(0,0,img.size.width, img.size.height);
        
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
    
	self.button.center = CGPointMake(bounds.size.width / 2, bounds.size.height / 2);
    self.messageFrame.center = CGPointMake(bounds.size.width / 2, bounds.size.height / 2);
    self.imageView.center = CGRectGetCenter(self.bounds);
    
	self.quitButton.center = CGPointMake(bounds.size.width / 2 + self.imageView.image.size.width / 2 - 10, bounds.size.height / 2 - self.imageView.image.size.height / 2 + 10);
    
	self.label.center = CGPointMake(bounds.size.width / 2, bounds.size.height / 2 - self.imageView.image.size.height / 2 + self.label.bounds.size.height / 2 + 30 );
}

@end