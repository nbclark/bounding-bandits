//
//  BBSettingsViewController.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBSettingsViewController.h"
#import "BBPeopleViewController.h"
#import "UIImageView+DD.h"
#import <Parse/Parse.h>
#import "AnimationDelegate.h"

@interface BBSettingsViewController ()

@property (nonatomic, strong) IBOutlet UISwitch* facebookSwitch;
@property (nonatomic, strong) IBOutlet UISwitch* twitterSwitch;
@property (nonatomic, strong) IBOutlet UISwitch* createGameNotSwitch;
@property (nonatomic, strong) IBOutlet UISwitch* yourTurnNotSwitch;
@property (nonatomic, strong) IBOutlet UIButton* createGameButton;
@property (nonatomic, strong) IBOutlet UILabel* profileLabel;
@property (nonatomic, strong) IBOutlet UIImageView* profileImage;
@property (nonatomic, strong) BBPeopleViewController* peopleViewController;

@end

@implementation BBSettingsViewController

@synthesize facebookSwitch;
@synthesize twitterSwitch;
@synthesize createGameButton;
@synthesize createGameNotSwitch;
@synthesize yourTurnNotSwitch;
@synthesize profileImage;
@synthesize profileLabel;
@synthesize gameDelegate;
@synthesize peopleViewController;

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
    
    self.peopleViewController = [[ BBPeopleViewController alloc ] initWithNibName:@"BBPeopleViewController" bundle:[ NSBundle mainBundle ]];
    
    self.peopleViewController.view.hidden = YES;
    [ self.view addSubview:self.peopleViewController.view ];
    self.view.backgroundColor = [ UIColor colorWithRed:0.173 green:0.18 blue:0.196 alpha:1 ];
    
    self.peopleViewController.gameDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [ self.profileImage loadImageWithURL:[ NSURL URLWithString:[[ PFUser currentUser ] objectForKey:@"profilePicture" ]] onComplete:nil ];
    
    self.profileLabel.text = [[ PFUser currentUser ] objectForKey:@"name" ];
}

-(IBAction)createGameClicked:(id)sender
{
    self.peopleViewController.view.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    self.peopleViewController.view.hidden = NO;
    
    [ UIView beginAnimations:nil context:nil ];
    [ UIView setAnimationDuration:0.5 ];
    [ UIView setAnimationDelay:0 ];
    [ UIView setAnimationCurve:UIViewAnimationCurveEaseInOut ];
    
    self.peopleViewController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    [UIView commitAnimations];
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

-(void)startGame:(GAME_TYPE)gameType
{     
    [ UIView beginAnimations:nil context:nil ];
    [ UIView setAnimationDuration:0.15 ];
    [ UIView setAnimationDelay:0 ];
    [ UIView setAnimationCurve:UIViewAnimationCurveEaseInOut ];
    
    [ UIView setAnimationDelegate:[ AnimationDelegate delegateWithEndBlock:^(CAAnimation * anim, BOOL something) {
        [ self.gameDelegate startGame:gameType ];
    }]];
    
    self.peopleViewController.view.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    
    [UIView commitAnimations];
}

-(void)selectGame:(CollabGame*)game isNew:(BOOL)isNew
{         
    [ UIView beginAnimations:nil context:nil ];
    [ UIView setAnimationDuration:0.15 ];
    [ UIView setAnimationDelay:0 ];
    [ UIView setAnimationCurve:UIViewAnimationCurveEaseInOut ];
    
    [ UIView setAnimationDelegate:[ AnimationDelegate delegateWithEndBlock:^(CAAnimation * anim, BOOL something) {        
        [ self.gameDelegate selectGame:game isNew:isNew ];
    }]];
    
    self.peopleViewController.view.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    
    [UIView commitAnimations];
}

-(void)endGame:(NSDictionary*)results;
{
    [ self.gameDelegate endGame:results ];
}

-(void)signalLoadComplete:(id)sender;
{
    [ self.gameDelegate signalLoadComplete:sender ];
}

-(void)showMenu
{
    [ self.gameDelegate showMenu ];
}

-(void)hideMenu
{
    [ self.gameDelegate hideMenu ];
}

@end
