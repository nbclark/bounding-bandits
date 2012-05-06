//
//  UIView+Loading.h
//  SellIT2
//
//  Created by Nicholas Clark on 2/20/12.
//  Copyright (c) 2012 DoubleDutch Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Loading)

@property (nonatomic, retain) UIView* loadingView;
@property (nonatomic, retain) UIView* fadeView;

-(void)showError:(BOOL)show;

-(void)showLoading:(BOOL)show;
-(void)showLoading:(BOOL)show text:(NSString*)text;

-(void)showFade:(BOOL)show;

@end
