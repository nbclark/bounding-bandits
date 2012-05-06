//
//  UIWebView+Stylizer.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIWebView+Stylizer.h"

@implementation UIWebView (Stylizer)

-(void)stylize:(BOOL)allowRubberBanding
{
    [self setOpaque:NO];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    for (id subview in self.subviews)
    {
        if ([subview respondsToSelector:@selector(setBackgroundColor:)])
        {
            [subview setBackgroundColor:[UIColor whiteColor]];
        }
        
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
        {
            ((UIScrollView *)subview).bounces = allowRubberBanding;
            ((UIScrollView *)subview).scrollEnabled = allowRubberBanding;
        }
        
        for (UIView* imageView in [subview subviews])
        {
            if ([imageView isKindOfClass:[UIImageView class]])
            {
                imageView.hidden = YES;
            }
        }
    }
}

@end
