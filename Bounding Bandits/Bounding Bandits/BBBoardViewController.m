//
//  BBBoardViewController.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBBoardViewController.h"
#import "BBAppDelegate.h"
#import "BBSelectGameViewController.h"
#import "AnimationDelegate.h"
#import "UIView+Loading.h"
#import "UIImageView+DD.h"
#import "NSString+URLDecoding.h"
#import "MessageView.h"
#import "JSONKit.h"
#import "Models.h"
#import "Utils.h"
#import <Parse/Parse.h>
#import <Parse/PF_EGORefreshTableHeaderView.h>
#import <UIKit/UIKit.h>

#import "UIWebView+Stylizer.h"

@interface BBBoardViewController ()

@property (nonatomic, strong) MessageView* messageView;

@end

@implementation BBBoardViewController

@synthesize messageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.messageView = [[ MessageView alloc ] init ];
    self.messageView.showMessageFrame = NO;
    
    self.messageView.hidden = YES;
    self.messageView.layer.opacity = 0.9f;
    self.messageView.label.font = [UIFont boldSystemFontOfSize:30];
    
    self.messageView.label.shadowColor = [ UIColor lightGrayColor ];
    self.messageView.label.shadowOffset = CGSizeMake(1, 1);
    [ self.messageView addTarget:self action:@selector(messageViewClick) forControlEvents:UIControlEventTouchUpInside ];    
    
    [ self.webView addSubview:self.messageView ];
    self.isLoading = YES;
    
    {
        NSString *urlAddress = [[NSBundle mainBundle] pathForResource:@"robots" ofType:@"html"];
        
        NSURL *url = [NSURL fileURLWithPath:urlAddress];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
        [self.webView loadRequest:requestObj];
    }
    
    [ self.webView stylize:NO ];
    self.messageView.backgroundColor = [UIColor whiteColor];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void)messageViewClick
{
    [ self.webView stringByEvaluatingJavaScriptFromString:@"try { window.clickCallback(); } catch (e) { _alert(e); }" ];
}

-(void)showMessage:(NSString*)message
{
    self.messageView.hidden = NO;
    self.messageView.label.text = message;
    [self.messageView sizeToFit];
    self.messageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([ request.URL.scheme isEqualToString:@"bb" ])
    {
        if ([request.URL.host isEqualToString:@"showmessage"])
        {
            NSString* message = [[request.URL.absoluteString stringByReplacingOccurrencesOfString:@"bb://showmessage/" withString:@""] stringByDecodingURLFormat];
            
            [ self showMessage:message ];
        }
        else if ([request.URL.host isEqualToString:@"hidemessage"])
        {
            if (!self.messageView.hidden)
            {
                self.messageView.hidden = YES;
            }
        }
        else if ([request.URL.host isEqualToString:@"endgame"])
        {
            // Game is over, request the new game state
            NSString* json = [ webView stringByEvaluatingJavaScriptFromString:@"try { endGame(); } catch (e) { _alert(e); }" ];
            NSDictionary* results =  [ json objectFromJSONString ];
            
            [ self.gameDelegate endGame:results ];
            [ self.gameDelegate showMenu ];
        }
        
        return NO;
    }
    
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    //
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.isLoading = NO;
    [ self.gameDelegate signalLoadComplete:self ];
    [ webView showLoading:NO ];
    
    [ webView stringByEvaluatingJavaScriptFromString:@"window._showMessage = function(message, func) { window.clickCallback = func; document.location = 'bb://showmessage/' + encodeURI(message); };" ];
    [ webView stringByEvaluatingJavaScriptFromString:@"window._hideMessage = function() { document.location = 'bb://hidemessage'; };" ];
    [ webView stringByEvaluatingJavaScriptFromString:@"window._endGame = function() { document.location = 'bb://endgame'; };" ];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //
}

#pragma  mark UITableViewDelegate

-(NSString*)loadGameWithGameType:(GAME_TYPE)gameType gameState:(NSString*)gameState generateState:(BOOL)generateState isActive:(BOOL)isActive elapsed:(float)elapsed
{
    NSLog(@"loadGame(%d, %@, %@, %@, %f);", ((int)gameType)-1, isActive ? @"true" : @"false", gameState, generateState ? @"true" : @"false", elapsed);
    return [ self.webView stringByEvaluatingJavaScriptFromString:[ NSString stringWithFormat:@"loadGame(%d, %@, %@, %@, %f);", ((int)gameType)-1, isActive ? @"true" : @"false", gameState, generateState ? @"true" : @"false", elapsed, nil ] ];
    
    /*
    NSString* json = [ self.webView stringByEvaluatingJavaScriptFromString:[ NSString stringWithFormat:@"try { loadGame(2, %@, %@, false, %f); } catch (e) { _alert(e); }", isActive ? @"true" : @"false", gameData, self.currentRound.elapsed, nil ] ];
    */
}

@end
