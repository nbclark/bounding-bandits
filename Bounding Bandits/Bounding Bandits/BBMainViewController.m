//
//  BBMainViewController.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBAppDelegate.h"
#import "BBMainViewController.h"
#import "BBViewController.h"
#import "BBGamesTableViewController.h"
#import "BBBoardViewController.h"
#import "BBSettingsViewController.h"
#import "AnimationDelegate.h"
#import "JSONKit.h"
#import "DDAlertManager.h"
#import "BBFirstRunViewController.h"

#define ANIM_MULTIPLIER 1

@interface BBMainViewController ()<BBGameDelegate>

@property (nonatomic, strong) IBOutlet BBSettingsViewController* settingsController;
@property (nonatomic, strong) IBOutlet BBBoardViewController* boardController;
@property (nonatomic, strong) IBOutlet BBGamesTableViewController* gamesController;
@property (nonatomic, strong) IBOutlet UIImageView* backgroundView;
@property (nonatomic, readwrite) BOOL isMenuVisible;
@property (nonatomic, readwrite) GAME_TYPE gameType;
@property (nonatomic, strong) CollabGame* currentGame;
@property (nonatomic, strong) CollabRound* currentRound;

@end

@implementation BBMainViewController

@synthesize settingsController;
@synthesize boardController;
@synthesize gamesController;
@synthesize isMenuVisible;
@synthesize gameType;
@synthesize currentGame;
@synthesize currentRound;
@synthesize backgroundView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
    [ super loadView ];
    
    self.settingsController.gameDelegate = self.boardController.gameDelegate = self.gamesController.gameDelegate = self;
    
    for (UIViewController* controller in [ NSArray arrayWithObjects:self.boardController, self.gamesController, self.settingsController, nil ])
    {
        [ self addChildViewController:controller ];
        
        [ self.view addSubview:controller.view ];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated ];
    
    self.settingsController.view.hidden = self.gamesController.view.hidden = self.boardController.view.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [ super viewWillAppear:animated ];
    
    CGSize size = self.view.bounds.size;
    
    self.settingsController.view.frame = CGRectMake(size.width - 300, 0, 300, size.height);
    self.boardController.view.frame = CGRectMake(0, 0, size.width, size.height );
    self.gamesController.view.frame = CGRectMake(0, 0, size.width - 300, size.height );
    
    self.gamesController.view.layer.position = CGPointMake(-self.gamesController.view.bounds.size.width / 2 - 5, self.gamesController.view.bounds.size.height / 2);
    
    self.boardController.view.layer.position = CGPointMake(self.boardController.view.bounds.size.width / 2, -self.boardController.view.bounds.size.height / 2 - 5);
    
    self.settingsController.view.layer.position = CGPointMake(5 + self.view.bounds.size.width + self.settingsController.view.bounds.size.width / 2, self.settingsController.view.bounds.size.height / 2);
    
    self.backgroundView.frame = self.view.bounds;
    
    UIPanGestureRecognizer* gesture = [[ UIPanGestureRecognizer alloc ] initWithTarget:self action:@selector(handlePan:) ];
    [ self.boardController.view addGestureRecognizer:gesture ];
    
    for (UIView* view in [ NSArray arrayWithObjects:self.boardController.view, self.settingsController.view, self.gamesController.view, nil ])
    {
        view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
        view.layer.borderColor = [[ UIColor whiteColor ] CGColor ];
        
        view.layer.shadowOffset = CGSizeMake(0, 0);
        view.layer.shadowColor = [[ UIColor blackColor ] CGColor ];
        view.layer.shadowRadius = 5;
        view.layer.shadowOpacity = 1;
        view.clipsToBounds = NO;
    }
}

- (void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    if (self.isMenuVisible || [ BBAppDelegate sharedDelegate ].isInGame) return;
    
    CGPoint translation = [recognizer translationInView:recognizer.view];
    
    float x = MIN(MAX(translation.x, -(self.settingsController.view.bounds.size.width+5)), 0);
    
    translation = CGPointMake(x, 0);
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {    
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        float ratio = (self.gamesController.view.bounds.size.width+5) / (self.settingsController.view.bounds.size.width+5);
        float webRatio = (self.boardController.view.bounds.size.height+5) / (self.settingsController.view.bounds.size.width+5);
        
        self.settingsController.view.transform = CGAffineTransformMakeTranslation(translation.x, 0);
        self.gamesController.view.transform = CGAffineTransformMakeTranslation(-translation.x * ratio, 0);
        self.boardController.view.transform = CGAffineTransformMakeTranslation(0, translation.x * webRatio);
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        if (-translation.x > self.settingsController.view.bounds.size.width / 2)
        {
            [ self showMenu ];
        }
        else
        {
            [ self hideMenu ];
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark BBGameDelegate

-(void)startGame:(GAME_TYPE)_gameType
{
    if (_gameType == GAME_TYPE_TURN)
    {
        return;
    }
    
    VoidBlock launchGame = ^()
    {
        [ self.boardController loadGameWithGameType:_gameType gameState:@"null" generateState:NO isActive:YES elapsed:0 ];
        [ self hideMenu ];
    };
    
    NSNumber* firstRun = [[ BBAppDelegate sharedDelegate ] getSetting:@"IsFirstRun" ];
    
    if (!firstRun || ![ firstRun boolValue ])
    {
        BBFirstRunViewController* vc = [[ BBFirstRunViewController alloc ] init ];
        [ self.navigationController presentModalViewController:vc animated:YES ];
        vc.delegate = launchGame;
        
        [[ BBAppDelegate sharedDelegate ] saveSetting:[ NSNumber numberWithBool:YES ] forKey:@"IsFirstRun" ];
    }
    else
    {
        launchGame();
    }
}

-(void)selectGame:(CollabGame*)game isNew:(BOOL)isNew
{
    if (isNew)
    {
        if (self.gamesController.activeGames >= 2)
        {
            NSString* proProduct = @"MMMultiMode";
            
            if (![ BBAppDelegate sharedDelegate ].isUpgraded)
            {
                [ DDAlertManager alertWithTitle:@"Game Limit Reached" message:@"You have reached the limit of active games (2) for the free version. Would you like to upgrade?" closeBlock:^(int buttonIndex) {
                    
                    if (buttonIndex > 0)
                    {
                        [PFPurchase buyProduct:proProduct block:^(NSError *error) {
                            if (!error)
                            {
                                // Run UI logic that informs user the product has been purchased, such as displaying an alert view.
                                [ BBAppDelegate sharedDelegate ].isUpgraded = YES;
                                [ self selectGame:game isNew:isNew ];
                            }
                            else
                            {
                                [[[ UIAlertView alloc ] initWithTitle:@"Error Purchasing" message:[ error localizedDescription ] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil ] show ];
                            }
                        }];
                    }
                } cancelButtonTitle:@"No, Thanks" otherButtonTitles:@"Upgrade", nil ];
                return;
            }
            /*
            if (![ InventoryKit productActivated:proProduct ])
            {
                [ DDAlertManager alertWithTitle:@"Game Limit Reached" message:@"You have reached the limit of active games (5) for the free version. Would you like to upgrade?" closeBlock:^(int buttonIndex) {
                    
                    if (buttonIndex > 0)
                    {
                        IKBasicBlock tStart = ^{ 
                            // notify user of pending transaction using dispatch_async to schedule operations on the main thread
                        };
                        IKStringBlock tSuccess = ^(NSString* productKey) {
                            // notify user of successful purchase using dispatch_async to schedule operations on the main thread
                            [ InventoryKit activateProduct:proProduct ];
                        };
                        IKErrorBlock tFailure = ^(int code, NSString* description) {
                            // notify user of failed purchase using dispatch_async to schedule operations on the main thread
                        };
                        [InventoryKit purchaseProduct:proProduct startBlock:tStart successBlock:tSuccess failureBlock:tFailure];
                    }
                } cancelButtonTitle:@"No, Thanks" otherButtonTitles:@"Upgrade", nil ];
                
                return;
            }
        */
        }
    }
    
    self.boardController.view.hidden = NO;
    self.currentGame = game;
    self.gameType = GAME_TYPE_TURN;
    
    PFUser* activeUser = self.currentGame.activeUser;
    PFUser* creator = self.currentGame.creator;
    NSMutableArray* rounds = self.currentGame.rounds;
    
    BOOL isActive = [ activeUser.objectId isEqualToString:[ PFUser currentUser ].objectId ];
    BOOL isCreator = [ creator.objectId isEqualToString:[ PFUser currentUser ].objectId ];
    
    // See if we are in a new round...
    BOOL generateState = (isCreator && [ rounds count ] % 2 == 0);
    BOOL createRound = (isCreator && [ rounds count ] % 2 == 0) || (!isCreator && [ rounds count ] % 2 == 1);
    
    NSString* state = self.currentGame.state;
    NSString* gameData = @"null";
    
    if (state && [ state length ])
    {
        gameData = state;
    }
    
    if (createRound)
    {
        // We should show the previous round's progress
        BoringBlock gameBlock = ^{
            NSString* json = [ self.boardController loadGameWithGameType:GAME_TYPE_TURN gameState:gameData generateState:generateState isActive:isActive elapsed:0 ];
            
            self.currentRound = [ CollabRound object ];
            self.currentRound.userId = [ PFUser currentUser ].objectId;
            self.currentRound.completed = NO;
            self.currentRound.duration = 0;
            self.currentRound.elapsed = 0;
            self.currentRound.moves = 0;
            self.currentRound.moveLog = @"[]";
            self.currentRound.state = json;
            
            [ rounds addObject:self.currentRound.baseObj ];
            
            self.currentGame.state = json;
            self.currentGame.rounds = rounds;
            self.currentGame.tokenCount = 0;
            
            [ self.currentGame.baseObj save ];
            
            [ self hideMenu ];
        };
        
        if ((!isNew && [ rounds count ]))
        {
            // Show the progress here
            [ self.gamesController showResults:game fromRect:CGRectZero onClose:gameBlock ];
        }
        else
        {
            gameBlock();
        }
    }
    else
    {
        self.currentRound = [ CollabRound objectWithObject:[ self.currentGame.rounds objectAtIndex:[ self.currentGame.rounds count ] - 1 ]];
        
        NSString* json = [ self.boardController loadGameWithGameType:GAME_TYPE_TURN gameState:gameData generateState:NO isActive:isActive elapsed:self.currentRound.elapsed ];
        
        NSLog(@"%@", json);
        
        [ self hideMenu ];
    }
    
    if (isNew)
    {
        [ self.gamesController gameCreated:currentGame ];
    }
    
    [ BBAppDelegate sharedDelegate ].isInGame = YES;
}

-(void)endGame:(NSDictionary *)results
{
    [ BBAppDelegate sharedDelegate ].isInGame = NO;
    
    if (self.gameType == GAME_TYPE_TURN)
    {
        if ([self.currentGame.activeUser.objectId isEqualToString:[ PFUser currentUser ].objectId ])
        {
            self.currentGame.activeUser = [ self.currentGame otherUser ];
        }
        else
        {
            return;
        }
        
        self.currentRound.completed = YES;
        self.currentRound.success = [[ results objectForKey:@"Success" ] boolValue ];
        self.currentRound.duration = [[ results objectForKey:@"Duration" ] floatValue ];
        self.currentRound.moves = [[ results objectForKey:@"Moves" ] integerValue ];
        self.currentRound.moveLog = [[ results objectForKey:@"MoveLog" ] JSONString ];
        
        PFUser* otherUser = [ self.currentGame otherUser ];
        NSString* message = [ NSString stringWithFormat:@"Your move with %@!", [ otherUser objectForKey:@"name" ] ];
        
        // Game is over after 17 rounds
        if ([ self.currentGame.rounds count ] == 17*2)
        {
            NSDictionary* scores = [ self.currentGame scoresForUsers ];
            int yourScore = [[ scores objectForKey:[ PFUser currentUser ].objectId ] intValue ];
            int theirScore = [[ scores objectForKey:otherUser.objectId ] intValue ];
            
            if (yourScore > theirScore)
            {
                message = [ NSString stringWithFormat:@"You beat %@ (%d to %d)!", [ otherUser objectForKey:@"name" ], yourScore, theirScore ];
            }
            else if (theirScore > yourScore)
            {
                message = [ NSString stringWithFormat:@"%@ beat you (%d to %d)!", [ otherUser objectForKey:@"name" ], yourScore, theirScore ];
            }
            else
            {
                message = [ NSString stringWithFormat:@"You tied %@ (%d to %d)!", [ otherUser objectForKey:@"name" ], yourScore, theirScore ];
            }
            
            self.currentGame.completed = YES;
        }
        
        PFQuery* query = [ PFQuery queryWithClassName:@"CollabGame" ];
        [ query whereKey:@"ActiveUser" equalTo:otherUser ];
        [ query whereKey:@"objectId" notEqualTo:self.currentGame.objectId ];
        
        [ query countObjectsInBackgroundWithBlock:^(int number, NSError *error)
        {
            // Exclude the current game and add 1
            NSDictionary* data = [ NSMutableDictionary dictionaryWithCapacity:5 ];
            [ data setValue:message forKey:@"alert" ];
            [ data setValue:[ NSString stringWithFormat:@"%d", number+1 ] forKey:@"badge" ];
            
            PFPush* push = [[ PFPush alloc ] init ];
            [ push setChannel:otherUser.objectId ];
            [ push setData:data ];
            [ push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                sleep(0);
            } ];
        }];
        
        // Show the round score here...
        //[ self.gamesController showResults:self.currentGame fromRect:self.view.bounds onClose:nil ];

        [ self.currentGame saveInBackground ];
    }
    else if (self.gameType == GAME_TYPE_BLITZ)
    {
        BlitzGame* game = [ BlitzGame object ];
    }
    
    [ self.gamesController gameTurnEnded:self.currentGame ];
}

-(void)signalLoadComplete:(id)sender
{
    if (!self.gamesController.isLoading && !self.boardController.isLoading)
    {
        [ self showMenu ];
    }
}

-(void)moveView:(UIView*)view fromPoint:(CGPoint)from toPoint:(CGPoint)to duration:(float)duration
{    
    CABasicAnimation * anim = [ CABasicAnimation animationWithKeyPath:@"position" ] ;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    anim.toValue = [ NSValue valueWithCGPoint:to ] ;
    anim.duration = ANIM_MULTIPLIER * duration ;
    anim.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    
    anim.delegate = [ AnimationDelegate delegateWithEndBlock:(void(^)(CAAnimation*, BOOL))^(CABasicAnimation * anim, BOOL didFinish )
                     {
                         if ( didFinish )
                         {
                             view.layer.position = to;
                         }
                     }];
    
    view.layer.position = from;
    
    [ view.layer addAnimation:anim forKey:@"menuPosition" ] ;
}

-(CGPoint)positionWithTranslationInView:(UIView*)view
{
    if (view.transform.tx || view.transform.ty)
    {
        float x = view.transform.tx;
        float y = view.transform.ty;
        
        CGPoint pos = view.layer.position;
        
        return CGPointMake(view.layer.position.x + x, view.layer.position.y + y);
    }
    
    return view.layer.position;
}

-(void) showMenu
{
    self.settingsController.view.hidden = NO;
    self.gamesController.view.hidden = NO;
    self.isMenuVisible = YES;

    CGPoint pos = CGPointMake(self.view.frame.size.width - self.settingsController.view.frame.size.width / 2, self.settingsController.view.frame.size.height / 2);
    
    [ self moveView:self.settingsController.view fromPoint:[ self positionWithTranslationInView:self.settingsController.view ] toPoint:pos duration:0.5 ];
    
    pos = CGPointMake(self.gamesController.view.frame.size.width / 2, self.gamesController.view.frame.size.height / 2);
    
    [ self moveView:self.gamesController.view fromPoint:[ self positionWithTranslationInView:self.gamesController.view ] toPoint:pos duration:0.5 ];
    
    pos = CGPointMake(self.boardController.view.frame.size.width / 2, -self.boardController.view.frame.size.height / 2 - 5);
    
    [ self moveView:self.boardController.view fromPoint:[ self positionWithTranslationInView:self.boardController.view ] toPoint:pos duration:0.25 ];
    
    self.boardController.view.transform = self.gamesController.view.transform = self.settingsController.view.transform = CGAffineTransformIdentity;
}

-(void)hideMenu
{
    [ self hideMenu:0.25 ];
}

-(void)hideMenu:(float)duration
{
    BOOL wasMenuVisible = self.isMenuVisible;
    self.isMenuVisible = NO;
    
    CGPoint pos = CGPointMake(self.view.frame.size.width + self.settingsController.view.frame.size.width / 2 + 5, self.settingsController.view.frame.size.height / 2);
    
    [ self moveView:self.settingsController.view fromPoint:[ self positionWithTranslationInView:self.settingsController.view ] toPoint:pos duration:0.5 ];
    
    pos = CGPointMake(-self.gamesController.view.frame.size.width / 2 - 5, self.gamesController.view.frame.size.height / 2);
    
    [ self moveView:self.gamesController.view fromPoint:[ self positionWithTranslationInView:self.gamesController.view ] toPoint:pos duration:0.5 ];
    
    pos = CGPointMake(self.boardController.view.frame.size.width / 2, self.boardController.view.frame.size.height / 2);
    
    if (self.boardController.view.transform.ty || !wasMenuVisible)
    {
        [ self moveView:self.boardController.view fromPoint:[ self positionWithTranslationInView:self.boardController.view ] toPoint:pos duration:0.5 ];
    }
    else
    {
        CFTimeInterval beginTime = (self.boardController.view.transform.ty) ? 0 : CACurrentMediaTime()+duration*ANIM_MULTIPLIER;
        
        CAKeyframeAnimation *webAnim = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
        webAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        webAnim.duration = duration*3*ANIM_MULTIPLIER;
        webAnim.beginTime = beginTime;
        webAnim.fillMode = kCAFillModeForwards;
        
        float height = self.boardController.view.bounds.size.height;
        
        CGPoint webPos = CGPointMake(self.boardController.view.bounds.size.width / 2, self.boardController.view.bounds.size.height / 2);
        
        float offset = self.boardController.view.transform.ty;
        self.boardController.view.layer.position = [ self positionWithTranslationInView:self.boardController.view ];
        self.boardController.view.hidden = NO;
        
        NSMutableArray *values = [NSMutableArray arrayWithCapacity:100];
        double value = 0;
        float e = 2.71;
        for (int t = 0; t < 100; t++) {
            int i = t;
            
            value = -(height) * pow(e, -0.055*i) * cos(0.08*i) + height / 2;
            
            if (value > self.boardController.view.layer.position.y)
            {
                [values addObject:[NSNumber numberWithFloat:value]];
            }
        }
        webAnim.values = values;
        
        webAnim.delegate = [ AnimationDelegate
                            delegateWithStartBlock:(void (^)(CAAnimation *))^(CABasicAnimation * anim )
                            {
                                if (beginTime)
                                {
                                    self.boardController.view.layer.position = webPos;
                                }
                            }
                            endBlock:(void (^)(CAAnimation *, BOOL))^(CABasicAnimation * anim, BOOL didFinish )
                            {
                                if ( didFinish )
                                {
                                    self.boardController.view.layer.position = webPos;
                                }
                            }];
        
        [self.boardController.view.layer addAnimation:webAnim forKey:@"menuPosition" ];
    }
    
    self.boardController.view.transform = self.gamesController.view.transform = self.settingsController.view.transform = CGAffineTransformIdentity;
}

@end
