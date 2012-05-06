//
//  BBWebView.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBWebView.h"

@interface DebugWebDelegate : NSObject
@end

@implementation DebugWebDelegate
@class WebView;
@class WebScriptCallFrame;
@class WebFrame;

- (void)webView:(WebView *)webView   exceptionWasRaised:(WebScriptCallFrame *)frame
       sourceId:(int)sid
           line:(int)lineno
    forWebFrame:(WebFrame *)webFrame
{
    NSLog(@"NSDD: exception: sid=%d line=%d function=%@, caller=%@, exception=%@", 
          sid, lineno, [frame functionName], [frame caller], [frame exception]);
}
@end


@implementation BBWebView
@class WebView;

- (void)webView:(WebView*)sender didClearWindowObject:(id)windowObject forFrame:(WebFrame*)frame
{
    [sender setScriptDebugDelegate:[[DebugWebDelegate alloc] init]];
}

@end
