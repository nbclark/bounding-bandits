//
//  UIView+Loading.m
//  SellIT2
//
//  Created by Nicholas Clark on 2/20/12.
//  Copyright (c) 2012 DoubleDutch Inc. All rights reserved.
//

#import "UIView+Loading.h"
#import "MessageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Loading)

-(MessageView*)loadingView
{
    MessageView* loadingView = [self.layer valueForKey:@"loadingView"];
    
    if (nil == loadingView)
    {
        loadingView = [[ MessageView alloc ] initWithFrame:CGRectZero ] ;
		
		loadingView.backgroundColor = [ UIColor whiteColor ];
		loadingView.layer.cornerRadius = 3.0f ;
		loadingView.layer.borderColor = [[ UIColor whiteColor ] CGColor ] ;
		loadingView.layer.borderWidth = 1.0f ;		
		loadingView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin ;
		
        [ self setLoadingView:loadingView ] ;
    }
    
    return loadingView;
}

-(UIView*)fadeView
{
    UIView* fadeView = [self.layer valueForKey:@"fadeView"];
    
    if (nil == fadeView)
    {
        fadeView = [[ UIView alloc ] initWithFrame:CGRectZero ] ;
		
		fadeView.backgroundColor = [ UIColor blackColor ];
		fadeView.layer.cornerRadius = 3.0f ;
		fadeView.layer.borderColor = [[ UIColor whiteColor ] CGColor ] ;
		fadeView.layer.borderWidth = 1.0f ;		
		fadeView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin ;
        fadeView.alpha = 0.5f;
		
        [ self setFadeView:fadeView ] ;
    }
    
    return fadeView;
}

-(void)setLoadingView:(UIView *)loadingView
{
    UIView* currentView = [self.layer valueForKey:@"loadingView"];
    
    if (currentView != loadingView)
    {
        if (currentView)
        {
            [currentView removeFromSuperview];
        }
        
        loadingView.hidden = YES;
        [self addSubview:loadingView];
        [self.layer setValue:loadingView forKey:@"loadingView"];
    }
}

-(void)setFadeView:(UIView *)fadeView
{
    UIView* currentView = [self.layer valueForKey:@"fadeView"];
    
    if (currentView != fadeView)
    {
        if (currentView)
        {
            [currentView removeFromSuperview];
        }
        
        fadeView.hidden = YES;
        [self addSubview:fadeView];
        [self.layer setValue:fadeView forKey:@"fadeView"];
    }
}

-(void)showError:(BOOL)show
{
    [self showLoading:show text:@"No Connection Available"];
    
    if (show)
    {
        MessageView* loadingView = (MessageView*)self.loadingView ;
        loadingView.activityIndicator.hidden = YES;
        [ loadingView.activityIndicator stopAnimating ];
    }
}

-(void)showLoading:(BOOL)show
{
    [self showLoading:show text:nil];
}

-(void)showLoading:(BOOL)show text:(NSString*)text
{
    MessageView* loadingView = (MessageView*)self.loadingView ;
    
    if (show)
    {
        text = (nil != text) ? text : NSLocalizedString(@"Loading...", @"Loading dialog text");
        
        loadingView.frame = self.bounds;
        loadingView.label.text = text;
        loadingView.activityIndicator.hidden = NO;
        
        loadingView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		
		[ loadingView sizeToFit ] ;
		loadingView.center = CGRectGetCenter( self.bounds ) ;
		
        [ loadingView.activityIndicator startAnimating ];
    }
    
	[ self bringSubviewToFront:loadingView ] ;
    loadingView.hidden = !show;
}

-(void)showFade:(BOOL)show
{
    UIView* loadingView = self.fadeView ;
    float alpha = 0;
    
    if (show)
    {
        loadingView.frame = self.bounds;
        loadingView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		loadingView.center = CGRectGetCenter( self.bounds ) ;
        loadingView.alpha = 0;
        
        alpha = 0.7;
    }
    else {
        alpha = 0;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.15];
    [UIView setAnimationDelegate:self];
    loadingView.alpha = alpha;
    [UIView commitAnimations];
    
	[ self bringSubviewToFront:loadingView ] ;
    loadingView.hidden = !show;
}

@end
