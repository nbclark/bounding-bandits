//
//  BBSelectGameViewController.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBSelectGameViewController.h"
#import "UIResponder+ActionPerforming.h"

@interface BBSelectGameViewController ()<UIActionSheetDelegate>

@property (nonatomic, strong) IBOutlet UIButton* blitzModeButton;
@property (nonatomic, strong) IBOutlet UIButton* localModeButton;
@property (nonatomic, strong) IBOutlet UIButton* turnModeButton;

@end

@implementation BBSelectGameViewController

@synthesize blitzModeButton;
@synthesize localModeButton;
@synthesize turnModeButton;

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
    // Do any additional setup after loading the view from its nib.
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

-(IBAction)blitzModeClicked:(id)sender
{
    [ self dismissModalViewControllerAnimated:YES ];
	[ UIResponder sendAction:@selector( dismissModal ) to:self.view.window.rootViewController ] ;
}

-(IBAction)turnModeClicked:(id)sender
{
    //
}

-(IBAction)localModeClicked:(id)sender
{
    //
}

-(IBAction)newGameClicked:(id)sender
{
    UIButton* button = sender;
    
    UIActionSheet* sheet = [[ UIActionSheet alloc ] initWithTitle:@"Select game type..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Local Multiplayer", @"Blitz Mode", @"Turn Based", nil ];
    
    [ sheet showFromRect:button.frame inView:self.view animated:YES ];
}

@end
