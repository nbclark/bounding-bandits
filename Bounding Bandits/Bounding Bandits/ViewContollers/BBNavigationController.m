//
//  BBNavigationController.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 6/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBNavigationController.h"

@interface BBNavigationController ()

@end

@implementation BBNavigationController

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
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated ];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWillShow:) name: UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardDidShow:) name: UIKeyboardDidShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillHide:) name: UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [ super viewWillDisappear:animated ];
    
    NSNotificationCenter *nc = [ NSNotificationCenter defaultCenter ];
    [ nc removeObserver:UIKeyboardWillShowNotification ];
    [ nc removeObserver:UIKeyboardWillHideNotification ];
    [ nc removeObserver:UIKeyboardDidShowNotification ];
}

-(CGRect)keyboardSize:(NSNotification*)not
{
    CGRect keyboard = [[not.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue ];
    
    return [self.view convertRect:keyboard fromView:nil];
}

-(void) keyboardDidShow:(NSNotification*)not
{
    CGRect keyboard = [self keyboardSize:not];
    
    CGRect viewFrame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - keyboard.size.height);
    CGPoint center = CGRectGetCenter(viewFrame);
    
    CGRect wtf = self.topViewController.view.frame;
    
    if (center.y != self.view.center.y)
    {
        [UIView animateWithDuration:0.25 delay:0 options:0 animations:^{
            
            self.view.center = CGPointMake(self.view.window.center.y, self.view.window.center.x - keyboard.size.height / 4);
        } completion:nil];
    }
}

-(void) keyboardWillShow:(NSNotification*)not
{
    CGRect keyboard = [self keyboardSize:not];
    double duration = [[not.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSUInteger options = [[not.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    if (keyboard.size.width < keyboard.size.height)
    {
        float width = keyboard.size.width;
        keyboard.size.width = keyboard.size.height;
        keyboard.size.height = width;
    }
    
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        
        CGRect viewFrame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - keyboard.size.height);
        //self.view.center = CGRectGetCenter( viewFrame ) ;
        self.view.center = CGPointMake(self.view.window.center.y, self.view.window.center.x - keyboard.size.height / 4);
        
    } completion:nil];
}

-(void) keyboardWillHide:(NSNotification*)not
{
    double duration = [[not.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSUInteger options = [[not.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        
        CGRect viewFrame = self.view.window.bounds;
        self.view.center = CGPointMake(self.view.window.center.y, self.view.window.center.x);
        
    } completion:nil];
}

@end
