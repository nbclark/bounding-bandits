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

typedef void (^VoidBlock)() ;

@interface BBSettingsViewController ()<UIActionSheetDelegate, PF_FBRequestDelegate>

@property (nonatomic, strong) IBOutlet UISwitch* facebookSwitch;
@property (nonatomic, strong) IBOutlet UISwitch* twitterSwitch;
@property (nonatomic, strong) IBOutlet UISwitch* createGameNotSwitch;
@property (nonatomic, strong) IBOutlet UISwitch* yourTurnNotSwitch;
@property (nonatomic, strong) IBOutlet UIButton* createGameButton;
@property (nonatomic, strong) IBOutlet UILabel* profileLabel;
@property (nonatomic, strong) IBOutlet UIImageView* profileImage;
@property (nonatomic, strong) BBPeopleViewController* peopleViewController;
@property (nonatomic, strong) VoidBlock destroyBlock;
@property (nonatomic, strong) VoidBlock cancelBlock;

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
@synthesize destroyBlock;
@synthesize cancelBlock;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)userDidLogIn
{
    [ self loadData ];
    
    [ self.facebookSwitch setOn:[ PFFacebookUtils isLinkedWithUser:[ PFUser currentUser ]]];
    [ self.twitterSwitch setOn:[ PFTwitterUtils isLinkedWithUser:[ PFUser currentUser ]]];
    
    [ self.yourTurnNotSwitch setOn:[[[ PFUser currentUser ] objectForKey:@"receiveNotifications" ] boolValue ]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.peopleViewController = [[ BBPeopleViewController alloc ] initWithNibName:@"BBPeopleViewController" bundle:[ NSBundle mainBundle ]];
    
    self.peopleViewController.view.hidden = YES;
    [ self.view addSubview:self.peopleViewController.view ];
    // 198, 31, 85
    self.view.backgroundColor = [ UIColor colorWithRed:0.173 green:0.18 blue:0.196 alpha:1 ];
    
    UIColor* redColor = [ UIColor colorWithRed:216/256.0 green:30/256.0 blue:64/256.0 alpha:1 ];
    
    [ self.facebookSwitch setOnTintColor:redColor];
    [ self.twitterSwitch setOnTintColor:redColor];
    [ self.yourTurnNotSwitch setOnTintColor:redColor];
    
    self.peopleViewController.gameDelegate = self;
    [[ NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(userDidLogIn) name:@"kUserDidLogIn" object:nil ];
}

- (void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated ];
    
    [ self.facebookSwitch setOn:[ PFFacebookUtils isLinkedWithUser:[ PFUser currentUser ]]];
    [ self.twitterSwitch setOn:[ PFTwitterUtils isLinkedWithUser:[ PFUser currentUser ]]];
    
    [ self.yourTurnNotSwitch setOn:[[[ PFUser currentUser ] objectForKey:@"receiveNotifications" ] boolValue ]];
}

-(IBAction)facebookToggled:(id)sender
{
    if (self.facebookSwitch.on)
    {
        if (![ PFFacebookUtils isLinkedWithUser:[ PFUser currentUser ]])
        {
            [ PFFacebookUtils linkUser:[ PFUser currentUser ] permissions:[ NSArray arrayWithObjects:@"email,user_birthday", nil ] block:^(BOOL succeeded, NSError *error)
            {
                [[ PFFacebookUtils facebook ] requestWithGraphPath:@"me?fields=id" andDelegate:self ];
            }];
        }
    }
    else {
        self.destroyBlock = ^{
            [ PFFacebookUtils unlinkUser:[ PFUser currentUser ] ];
            [[ PFUser currentUser ] setObject:@"" forKey:@"facebookId" ];
            [[ PFUser currentUser ] saveInBackground ];
        };
        self.cancelBlock = ^{
            self.facebookSwitch.on = YES;
        };
        
        UIActionSheet* as = [[ UIActionSheet alloc ] initWithTitle:@"Disconnect from Facebook?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Disconnect" otherButtonTitles:@"Cancel", nil ];
        
        [ as showInView:self.view ];
    }
}

- (void)request:(PF_FBRequest *)request didLoad:(id)result
{
    // Store the current user's Facebook ID on the user so that we can query for it.
    [[ PFUser currentUser ] setObject:[ result objectForKey:@"id" ] forKey:@"facebookId" ];
    [[ PFUser currentUser ] saveInBackground ];
}

-(IBAction)twitterToggled:(id)sender
{
    if (self.twitterSwitch.on)
    {
        if (![ PFTwitterUtils isLinkedWithUser:[ PFUser currentUser ]])
        {
            [ PFTwitterUtils linkUser:[ PFUser currentUser ] block:^(BOOL succeeded, NSError *error)
             {
                 [[ PFUser currentUser ] setObject:[[ PFTwitterUtils twitter ] screenName ] forKey:@"twitterSN" ];
                 [[ PFUser currentUser ] saveInBackground ];
            } ];
        }
    }
    else {
        self.destroyBlock = ^{
            [ PFTwitterUtils unlinkUser:[ PFUser currentUser ] ];
            [[ PFUser currentUser ] setObject:@"" forKey:@"twitterSN" ];
            [[ PFUser currentUser ] saveInBackground ];
        };
        self.cancelBlock = ^{
            self.twitterSwitch.on = YES;
        };
        
        UIActionSheet* as = [[ UIActionSheet alloc ] initWithTitle:@"Disconnect from Twitter?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Disconnect" otherButtonTitles:@"Cancel", nil ];
        
        [ as showInView:self.view ];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( [ actionSheet destructiveButtonIndex ] == buttonIndex )
    {
        self.destroyBlock();
    }
    else
    {
        self.cancelBlock();
    }
}

-(IBAction)notificationsToggled:(id)sender
{
    [[ PFUser currentUser ] setObject:[ NSNumber numberWithBool:self.yourTurnNotSwitch.on] forKey:@"receiveNotifications" ];
    [[ PFUser currentUser ] saveInBackground ];
    
    if (self.yourTurnNotSwitch.on)
    {
        [ PFPush subscribeToChannelInBackground:[ PFUser currentUser ].objectId ];
    }
    else
    {
        [ PFPush unsubscribeFromChannelInBackground:[ PFUser currentUser ].objectId ];
    }
}

-(void)loadData
{
    [ self.profileImage loadImageWithURL:[ NSURL URLWithString:[[ PFUser currentUser ] objectForKey:@"profilePicture" ]] defaultImage:[ UIImage imageNamed:@"img/noface.png" ] onComplete:nil ];
    
    self.profileLabel.text = [[ PFUser currentUser ] objectForKey:@"name" ];
}

-(IBAction)createGameClicked:(id)sender
{
    self.peopleViewController.view.frame = CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    self.peopleViewController.view.hidden = NO;
    
    [ self.peopleViewController show ];
    
    /*
    [ UIView beginAnimations:nil context:nil ];
    [ UIView setAnimationDuration:0.5 ];
    [ UIView setAnimationDelay:0 ];
    [ UIView setAnimationCurve:UIViewAnimationCurveEaseInOut ];
    
    self.peopleViewController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    [UIView commitAnimations];*/
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
    [ UIView animateWithDuration:0.15 animations:^{
        self.peopleViewController.view.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
        self.peopleViewController.view.alpha = 0;
    } completion:^(BOOL finished) {
        [ self.gameDelegate startGame:gameType ];
        self.peopleViewController.view.alpha = 1;
        self.peopleViewController.view.hidden = YES;
    }];
    /*
    [ UIView beginAnimations:nil context:nil ];
    [ UIView setAnimationDuration:0.15 ];
    [ UIView setAnimationDelay:0 ];
    [ UIView setAnimationCurve:UIViewAnimationCurveEaseInOut ];
    
    [ UIView setAnimationDelegate:[ AnimationDelegate delegateWithEndBlock:^(CAAnimation * anim, BOOL something) {
        [ self.gameDelegate startGame:gameType ];
        self.peopleViewController.view.hidden = YES;
    }]];
    
    self.peopleViewController.view.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    
    [UIView commitAnimations];
    */
}

-(void)selectGame:(CollabGame*)game isNew:(BOOL)isNew
{
    [ UIView animateWithDuration:0.15 animations:^{
        self.peopleViewController.view.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
        self.peopleViewController.view.alpha = 0;
    } completion:^(BOOL finished) {
        [ self.gameDelegate selectGame:game isNew:isNew ];
        self.peopleViewController.view.alpha = 1;
        self.peopleViewController.view.hidden = YES;
    }];
    
    /*
    [ UIView beginAnimations:nil context:nil ];
    [ UIView setAnimationDuration:0.15 ];
    [ UIView setAnimationDelay:0 ];
    [ UIView setAnimationCurve:UIViewAnimationCurveEaseInOut ];
    
    [ UIView setAnimationDelegate:[ AnimationDelegate delegateWithEndBlock:^(CAAnimation * anim, BOOL something) {        
        [ self.gameDelegate selectGame:game isNew:isNew ];
        self.peopleViewController.view.hidden = YES;
    }]];
    
    self.peopleViewController.view.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height);
    
    [UIView commitAnimations];
    */
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
