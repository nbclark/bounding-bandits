//
//  BBSignUpViewController.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBSignUpViewController.h"
#import "UIView+Loading.h"
#import <QuartzCore/QuartzCore.h>

@implementation BBSignUpViewController


-(void)viewDidLoad
{
    [ super viewDidLoad ];
    
    self.view.backgroundColor = [ UIColor clearColor ];
    self.signUpView.usernameField.backgroundColor = [ UIColor colorWithWhite:1 alpha:0.2 ];
    self.signUpView.passwordField.backgroundColor = [ UIColor colorWithWhite:1 alpha:0.2 ];
    self.signUpView.emailField.backgroundColor = [ UIColor colorWithWhite:1 alpha:0.2 ];
    
    self.signUpView.usernameField.textColor = [ UIColor blackColor ];
    self.signUpView.passwordField.textColor = [ UIColor blackColor ];
    self.signUpView.emailField.textColor = [ UIColor blackColor ];
    
    UIImage* img = [ UIImage imageNamed:@"img/bg-login.png" ];
    UIImage* logo = [ UIImage imageNamed:@"img/logo-login.png" ];
    
    UIImageView* imageView = [[ UIImageView alloc ] initWithImage:img];
    imageView.frame = CGRectMake(0,self.view.bounds.size.height - img.size.height,img.size.width, img.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    UIImageView* logoView = [[ UIImageView alloc ] initWithImage:logo];
    logoView.frame = CGRectMake(0,0,logo.size.width, logo.size.height + 60);
    logoView.contentMode = UIViewContentModeTop;
    
    [ self.signUpView.dismissButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents ];
    [ self.signUpView.dismissButton addTarget:self action:@selector(dismissTapped:) forControlEvents:UIControlEventTouchUpInside ];
    self.signUpView.logo = logoView;
    
    [ self.view insertSubview:imageView atIndex:0 ];
    
    self.view.frame = CGRectMake(0, 0, 542,560);
    self.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated ];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [ super viewWillDisappear:animated ];
}

-(void)dismissTapped:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [ self.navigationController popViewControllerAnimated:NO ];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{    
    PFUser* currentUser = [ PFUser currentUser ];
    
    if (![[ currentUser objectForKey:@"premium" ] boolValue ])
    {
        [currentUser setObject:[ NSNumber numberWithBool:NO ] forKey:@"premium"];
    }
    
    [currentUser setObject:[ NSNumber numberWithBool:YES ] forKey:@"receiveNotifications"];
    [currentUser setObject:user.username forKey:@"name"];
    [currentUser saveInBackground];
    [ self.navigationController.view removeFromSuperview ];
    [ self.navigationController removeFromParentViewController ];
    
    [[ NSNotificationCenter defaultCenter ] postNotificationName:@"kUserDidLogIn" object:nil ];
}

@end
