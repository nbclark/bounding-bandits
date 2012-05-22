//
//  BBViewController.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBViewController.h"
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

#define ANIM_MULTIPLIER 1
#define SINGLEPLAYERDEBUG 1

@interface BBViewController ()<UIActionSheetDelegate,PF_FBRequestDelegate,PF_EGORefreshTableHeaderDelegate>

@property (nonatomic, strong) NSMutableArray* myTurnGames;
@property (nonatomic, strong) NSMutableArray* theirTurnGames;
@property (nonatomic, strong) NSMutableArray* completedGames;
@property (nonatomic, strong) NSMutableArray* friends;
@property (nonatomic, strong) MessageView* messageView;
@property (nonatomic, strong) UIActionSheet* actionSheet;
@property (nonatomic) BOOL isMenuVisible;
@property (nonatomic) GAME_TYPE gameType;
@property (nonatomic, strong) CollabGame* currentGame;
@property (nonatomic, strong) CollabRound* currentRound;
@property (nonatomic, strong) IBOutlet UIWebView* homeWebView;
@property (nonatomic, strong) IBOutlet UIButton* menuTab;
@property (nonatomic) BOOL isLoadingGames;
@property (nonatomic) BOOL isLoadingPeople;
@property (nonatomic, strong) PF_EGORefreshTableHeaderView* refreshHeaderView;

@end

@implementation BBViewController

@synthesize navController = _navController;
@synthesize webView = _webView;
@synthesize isMenuVisible;
@synthesize dimmingView;
@synthesize modalNavController;
@synthesize popoverController;
@synthesize tableView;
@synthesize completedGames;
@synthesize myTurnGames;
@synthesize theirTurnGames;
@synthesize messageView;
@synthesize actionSheet;
@synthesize gameType;
@synthesize currentGame;
@synthesize currentRound;
@synthesize homeWebView;
@synthesize friends;
@synthesize isLoadingGames;
@synthesize isLoadingPeople;
@synthesize menuTab;
@synthesize refreshHeaderView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)finishedLoading
{
    [ self.tableView reloadData ];
    [ self.tableView showLoading:NO ];
    
    self.isLoadingGames = NO;
    
    if (!self.isLoadingGames && !self.isLoadingPeople)
    {
        [ self showMenu ];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //
}

-(void)willResignActive
{
    float elapsedTime = [[ self.webView stringByEvaluatingJavaScriptFromString:@"pauseGame();" ] floatValue ];
    self.currentRound.elapsed = elapsedTime;
    
    [ self.currentGame save ];
}

-(void)willBecomeActive
{
    [ self.webView stringByEvaluatingJavaScriptFromString:@"resumeGame();" ];
}

- (void)viewDidLoad
{
    static id decoder = nil;
    
    if (!decoder)
    {
        decoder = [JSONDecoder decoder];
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.isMenuVisible = YES;
    self.messageView = [[ MessageView alloc ] init ];
    self.messageView.showMessageFrame = NO;
    
    self.messageView.hidden = YES;
    self.messageView.backgroundColor = [UIColor whiteColor];
    self.messageView.layer.opacity = 0.9f;
    self.messageView.label.font = [UIFont boldSystemFontOfSize:30];
    
    self.messageView.label.shadowColor = [ UIColor lightGrayColor ];
    self.messageView.label.shadowOffset = CGSizeMake(1, 1);
    [ self.messageView addTarget:self action:@selector(messageViewClick) forControlEvents:UIControlEventTouchUpInside ];    
     
    [ self.webView addSubview:self.messageView ];
    
	[ self addChildViewController:self.navController ] ;

    self.tableView.layer.shadowOffset = CGSizeMake(0, 0);
    self.tableView.layer.shadowColor = [[ UIColor whiteColor ] CGColor ];
    self.tableView.layer.shadowRadius = 5;
    self.tableView.layer.shadowOpacity = 1;
    
    self.refreshHeaderView = [[ PF_EGORefreshTableHeaderView alloc ] init ];
    self.refreshHeaderView.delegate = self;
    
    self.tableView.tableHeaderView = self.refreshHeaderView;
    
    self.completedGames = [ NSMutableArray array ];
    self.myTurnGames = [ NSMutableArray array ];
    self.theirTurnGames = [ NSMutableArray array ];
    
    [[ NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil ];
    
    [[ NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(willBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil ];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)loadData
{
    [ self.webView showLoading:YES ];
    [ self.tableView showLoading:YES ];
    [ self.homeWebView showLoading:YES ];
    
    self.isLoadingGames = self.isLoadingPeople = YES;
    
    {
        NSString *urlAddress = [[NSBundle mainBundle] pathForResource:@"people" ofType:@"html"];
        
        NSURL *url = [NSURL fileURLWithPath:urlAddress];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
        [ self.homeWebView loadRequest:requestObj ];
    }
    
    for (UIWebView* webView in [ NSArray arrayWithObjects:self.webView, self.homeWebView, nil ])
    {
        [webView setOpaque:NO];
        [webView setBackgroundColor:[UIColor whiteColor]];
        
        for (id subview in webView.subviews)
        {
            if (subview == self.messageView) continue;
            
            if ([subview respondsToSelector:@selector(setBackgroundColor:)])
            {
                [subview setBackgroundColor:[UIColor whiteColor]];
            }
            
            if ([[subview class] isSubclassOfClass: [UIScrollView class]] && webView == self.webView)
            {
                ((UIScrollView *)subview).bounces = NO;
                ((UIScrollView *)subview).scrollEnabled = NO;
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
    
    [ self loadGames:NO ];
}

-(void)loadGames:(BOOL)forceRefresh
{
    
    if ([PFUser currentUser])
    {
        PFQuery *query = [PFQuery queryWithClassName:@"CollabGame"];
        
        forceRefresh = YES;
        
        if (!forceRefresh)
        {
            query.maxCacheAge = 60 * 60 * 24 * 7; // 1 week
            query.cachePolicy = kPFCachePolicyCacheElseNetwork;
        }
        
        [ query whereKey:@"Users" equalTo:[ PFUser currentUser ]];
        [ query addDescendingOrder:@"updatedAt" ];
        [ query setLimit:40 ];
        
        BOOL inCache = [ query hasCachedResult ];
        
        if (inCache && !forceRefresh)
        {
            [ self processLoadedGames:[ query findObjects ] fromCache:YES];
            
            query.cachePolicy = kPFCachePolicyIgnoreCache;
        }
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             
             [ self processLoadedGames:objects fromCache:NO ];
             
         }];
    }
}

-(void)processLoadedGames:(NSArray*)objects fromCache:(BOOL)fromCache
{
    if (!fromCache)
    {
        [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
    
    NSMutableArray* games = [ PFObjectExt arrayWithArray:objects className:@"CollabGame" loadSubObjects:NO ];
    
    [ self.completedGames removeAllObjects ];
    [ self.myTurnGames removeAllObjects ];
    [ self.theirTurnGames removeAllObjects ];

    for (CollabGame* game in games)
    {                
        if (game.completed)
        {
            [ self.completedGames addObject:game ];
        }
        else
        {
            if ([ game.activeUser.objectId isEqualToString:[ PFUser currentUser ].objectId ])
            {
                [ self.myTurnGames addObject:game ];
            }
            else
            {
                [ self.theirTurnGames addObject:game ];
            }
        }
    }

[ self performSelectorOnMainThread:@selector(finishedLoading) withObject:nil waitUntilDone:NO ];
}

-(void)connectionLost
{
    [ self.webView showError:YES ];
    [ self.tableView showError:YES ];
    [ self.homeWebView showError:YES ];
}

-(void)connectionGained
{
    [ self.webView showError:NO ];
    [ self loadData ];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[ NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(connectionLost) name:@"kConnectionLost" object:nil ];
    [[ NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(connectionGained) name:@"kConnectionGained" object:nil ];
    
    self.navigationController.navigationBarHidden = YES;
    
    {
        NSString *urlAddress = [[NSBundle mainBundle] pathForResource:@"bb" ofType:@"html"];
        
        NSURL *url = [NSURL fileURLWithPath:urlAddress];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
        [self.webView loadRequest:requestObj];
    }
    
    self.webView.hidden = self.homeWebView.hidden = self.tableView.hidden = YES;
    
    if (![ BBAppDelegate sharedDelegate ].isOnline)
    {
        //[ self.webView showError:YES ];
        [ self.tableView showError:YES ];
        // [ self.homeWebView showError:YES ];
        
        {
            NSString *urlAddress = [[NSBundle mainBundle] pathForResource:@"error" ofType:@"html"];
            
            NSURL *url = [NSURL fileURLWithPath:urlAddress];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
            
            [ self.homeWebView loadRequest:requestObj];
        }
        
        return;
    }

    
    [ self loadData ];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // [ self showGameSelector ];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(showGameSelector)]];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showNewGameSelector)]];
    
    [ self.webView stringByEvaluatingJavaScriptFromString:@"loadGame(0);" ];
    
    self.homeWebView.layer.position = CGPointMake(-self.homeWebView.bounds.size.width / 2, self.homeWebView.bounds.size.height / 2);
    self.homeWebView.hidden = NO;
    
    self.webView.layer.position = CGPointMake(self.webView.bounds.size.width / 2, -self.webView.bounds.size.height / 2);
    
    self.tableView.layer.position = CGPointMake(self.view.bounds.size.width + self.tableView.bounds.size.width / 2, self.tableView.bounds.size.height / 2);
    self.tableView.hidden = NO;
    
    self.isMenuVisible = NO;
    
    UIPanGestureRecognizer* gesture = [[ UIPanGestureRecognizer alloc ] initWithTarget:self action:@selector(handlePan:) ];
    [ self.webView addGestureRecognizer:gesture ];
    
    if (![ BBAppDelegate sharedDelegate ].isOnline)
    {
        [ self showMenu ];
        return;
    }
}

- (void)handlePan:(UIPanGestureRecognizer*)recognizer {
    
    self.menuTab.highlighted = YES;
    
    if (self.isMenuVisible) return;
    
    CGPoint translation = [recognizer translationInView:recognizer.view];
    
    float x = MIN(MAX(translation.x, -self.tableView.bounds.size.width), 0);
    
    translation = CGPointMake(x, 0);
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {    
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        float ratio = self.homeWebView.bounds.size.width / self.tableView.bounds.size.width;
        float webRatio = self.webView.bounds.size.height / self.tableView.bounds.size.width;
        
        self.menuTab.transform = CGAffineTransformMakeTranslation(translation.x, 0);
        self.tableView.transform = CGAffineTransformMakeTranslation(translation.x, 0);
        self.homeWebView.transform = CGAffineTransformMakeTranslation(-translation.x * ratio, 0);
        self.webView.transform = CGAffineTransformMakeTranslation(0, translation.x * webRatio);
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        if (-translation.x > self.tableView.bounds.size.width / 2)
        {
            [ self showMenu ];
        }
        else
        {
            [ self hideMenu ];
        }
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
    [[ NSNotificationCenter defaultCenter ] removeObserver:self ];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
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
    self.menuTab.hidden = YES;
    self.isMenuVisible = YES;
    
    //BOOL keepTableView = [ self applyTranslationInView:self.tableView ];
    //BOOL keepHomeView = [ self applyTranslationInView:self.homeWebView ];
    //BOOL keepWebView = [ self applyTranslationInView:self.webView ];
    
    CGPoint pos = CGPointMake(self.view.frame.size.width - self.tableView.frame.size.width / 2, self.tableView.frame.size.height / 2);
    
    [ self moveView:self.tableView fromPoint:[ self positionWithTranslationInView:self.tableView ] toPoint:pos duration:0.5 ];
    
    pos = CGPointMake(self.homeWebView.frame.size.width / 2, self.homeWebView.frame.size.height / 2);
    
    [ self moveView:self.homeWebView fromPoint:[ self positionWithTranslationInView:self.homeWebView ] toPoint:pos duration:0.5 ];
    
    pos = CGPointMake(self.webView.frame.size.width / 2, -self.webView.frame.size.height / 2);
    
    [ self moveView:self.webView fromPoint:[ self positionWithTranslationInView:self.webView ] toPoint:pos duration:0.25 ];
    /*
    CGRect webRect = self.webView.frame;
    if (!keepWebView) self.webView.layer.position = CGPointMake(webRect.size.width / 2, webRect.size.height / 2);
    
    CGPoint webPos = CGPointMake(webRect.size.width / 2, -webRect.size.height / 2);
    
    CABasicAnimation * webAnim = [ CABasicAnimation animationWithKeyPath:@"position" ] ;
    webAnim.fillMode = kCAFillModeForwards;
    webAnim.removedOnCompletion = NO;
    webAnim.toValue = [ NSValue valueWithCGPoint:webPos ] ;
    webAnim.beginTime = 0;
    webAnim.duration = 0.25 ;
    webAnim.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    
    webAnim.delegate = [ AnimationDelegate delegateWithEndBlock:(void(^)(CAAnimation*, BOOL))^(CABasicAnimation * anim, BOOL didFinish ) {
        if ( didFinish )
        {
            self.webView.layer.position = webPos;
        }
    }];
    
    [self.webView.layer addAnimation:webAnim forKey:@"webPosition" ] ;
    */
    self.webView.transform = self.homeWebView.transform = self.tableView.transform = CGAffineTransformIdentity;
}

-(void)hideMenu
{
    [ self hideMenu:0.25 ];
}

-(void)hideMenu:(float)duration
{
    BOOL wasMenuVisible = self.isMenuVisible;
    self.isMenuVisible = NO;
    
    CGPoint pos = CGPointMake(self.view.frame.size.width + self.tableView.frame.size.width / 2, self.tableView.frame.size.height / 2);
    
    [ self moveView:self.tableView fromPoint:[ self positionWithTranslationInView:self.tableView ] toPoint:pos duration:0.5 ];
    
    pos = CGPointMake(-self.homeWebView.frame.size.width / 2, self.homeWebView.frame.size.height / 2);
    
    [ self moveView:self.homeWebView fromPoint:[ self positionWithTranslationInView:self.homeWebView ] toPoint:pos duration:0.5 ];
    
    pos = CGPointMake(self.webView.frame.size.width / 2, self.webView.frame.size.height / 2);
    
    if (self.webView.transform.ty || !wasMenuVisible)
    {
        [ self moveView:self.webView fromPoint:[ self positionWithTranslationInView:self.webView ] toPoint:pos duration:0.5 ];
    }
    else
    {
        CFTimeInterval beginTime = (self.webView.transform.ty) ? 0 : CACurrentMediaTime()+duration*ANIM_MULTIPLIER;
        
        CAKeyframeAnimation *webAnim = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
        webAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        webAnim.duration = duration*3*ANIM_MULTIPLIER;
        webAnim.beginTime = beginTime;
        webAnim.fillMode = kCAFillModeForwards;

        float height = self.webView.bounds.size.height;

        CGPoint webPos = CGPointMake(self.webView.bounds.size.width / 2, self.webView.bounds.size.height / 2);
        
        float offset = self.webView.transform.ty;
        self.webView.layer.position = [ self positionWithTranslationInView:self.webView ];
        self.webView.hidden = NO;
        
        NSMutableArray *values = [NSMutableArray arrayWithCapacity:100];
        double value = 0;
        float e = 2.71;
        for (int t = 0; t < 100; t++) {
            int i = t;
            
            value = -(height) * pow(e, -0.055*i) * cos(0.08*i) + height / 2;
            
            if (value > self.webView.layer.position.y)
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
                    self.webView.layer.position = webPos;
                }
            }
            endBlock:(void (^)(CAAnimation *, BOOL))^(CABasicAnimation * anim, BOOL didFinish )
            {
                if ( didFinish )
                {
                    self.webView.layer.position = webPos;
                    
                    self.menuTab.hidden = YES;
                    self.menuTab.frame = CGRectMake(self.view.bounds.size.width - 50, self.view.bounds.size.height / 2, 100, 100);
                }
            }];
        
        [self.webView.layer addAnimation:webAnim forKey:@"menuPosition" ];
    }
    
    self.webView.transform = self.homeWebView.transform = self.tableView.transform = CGAffineTransformIdentity;
}

-(void) done
{
    [ self.modalNavController dismissModalViewControllerAnimated:YES ];
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated
{
    if (self.popoverController)
    {
        [ self.popoverController dismissPopoverAnimated:YES ];
        self.popoverController = NULL;
    }
    self.popoverController = [[ UIPopoverController alloc] initWithContentViewController:viewControllerToPresent ];
    [self.popoverController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    return;
    
    if (!self.modalNavController)
    {
        self.modalNavController = [[UINavigationController alloc] initWithRootViewController:viewControllerToPresent];
        
        self.modalNavController.modalPresentationStyle = UIModalPresentationFormSheet;
        self.modalNavController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    }
    
    [ viewControllerToPresent.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(done)] ];
    
    [ self.view.window.rootViewController presentModalViewController:self.modalNavController animated:animated ];
}

-(void)showGameSelector
{
    if (self.isMenuVisible)
    {
        [ self hideMenu ];
    }
    else {
        [ self showMenu ];
    }
}

-(void)showNewGameSelector
{
    if (self.actionSheet)
    {
        if (self.actionSheet.visible)
        {
            [ self.actionSheet dismissWithClickedButtonIndex:-1 animated:NO ];
            self.actionSheet = nil;
            return;
        }
    }
    
    self.actionSheet = [[ UIActionSheet alloc ] initWithTitle:@"Select game type..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Local Multiplayer", @"Blitz Mode", @"Turn Based", nil ];
    
    [ self.actionSheet showFromBarButtonItem:self.navigationItem.leftBarButtonItem animated:YES ];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(void)dimissModal
{
    sleep(0);
}

-(IBAction)tabTouchDown:(id)sender
{
    //
}

-(IBAction)tabTouchDrag:(id)sender
{
    //
}

-(IBAction)tabTouchUp:(id)sender
{
    //
}

#pragma mark UIWebViewDelegate

-(void)messageViewClick
{
    [ self.webView stringByEvaluatingJavaScriptFromString:@"window.clickCallback();" ];
}

-(void)showMessage:(NSString*)message
{
    self.messageView.hidden = NO;
    self.messageView.label.text = message;
    [self.messageView sizeToFit];
    self.messageView.frame = CGRectMake(0, 0, self.tableView.frame.origin.x, self.view.bounds.size.height);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([ request.URL.scheme isEqualToString:@"bb" ])
    {
        if (webView == self.webView)
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
                
                if (self.gameType == GAME_TYPE_TURN)
                {
                    if ([self.currentGame.activeUser.objectId isEqualToString:[ PFUser currentUser ].objectId ])
                    {
                        self.currentGame.activeUser = [ self.currentGame otherUser ];
                        
                        [ self.myTurnGames removeObject:self.currentGame ];
                        [ self.theirTurnGames insertObject:self.currentGame atIndex:0 ];
                    }
                    else
                    {
                        [ self.tableView reloadData ];
                        return NO;
                    }
                    
                    self.currentRound.completed = YES;
                    self.currentRound.success = [[ results objectForKey:@"Success" ] boolValue ];
                    self.currentRound.duration = [[ results objectForKey:@"Duration" ] floatValue ];
                    self.currentRound.moves = [[ results objectForKey:@"Moves" ] integerValue ];
                    self.currentRound.moveLog = [[ results objectForKey:@"MoveLog" ] JSONString ];

                    [ self.currentGame saveInBackground ];
                    
                    [ self.tableView reloadData ];
                }
                else if (self.gameType == GAME_TYPE_BLITZ)
                {
                    BlitzGame* game = [ BlitzGame object ];
                }
                
                [ self showMenu ];
            }
        }
        else if (webView == self.homeWebView)
        {
            if ([request.URL.host isEqualToString:@"person"])
            {
                NSUInteger index = [[ request.URL.absoluteString stringByReplacingOccurrencesOfString:@"bb://person/" withString:@""] integerValue ];
                
                FacebookFriend* friend = [ self.friends objectAtIndex:index ];
                
                if (friend.user)
                {
                    self.currentGame = [ CollabGame object ];
                    self.currentGame.completed = NO;
                    self.currentGame.creator = [ PFUser currentUser ];
                    self.currentGame.activeUser = [ PFUser currentUser ];
                    self.currentGame.users = [ NSMutableArray arrayWithObjects:[ PFUser currentUser ], friend.user, nil ];
                    self.currentGame.rounds = [ NSMutableArray array ];
                    
                    [ self.myTurnGames insertObject:self.currentGame atIndex:0 ];
                    [ self.tableView reloadData ];
                    
                    [ self selectGame:self.currentGame ];
                }
            }
            else if ([request.URL.host isEqualToString:@"local"])
            {
                [ self loadGameType:GAME_TYPE_LOCAL ];
            }
            else if ([request.URL.host isEqualToString:@"blitz"])
            {
                [ self loadGameType:GAME_TYPE_BLITZ ];
            }
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
    if (webView == self.webView)
    {
        [ webView showLoading:NO ];
        
        [ webView stringByEvaluatingJavaScriptFromString:@"window._showMessage = function(message, func) { window.clickCallback = func; document.location = 'bb://showmessage/' + encodeURI(message); };" ];
        [ webView stringByEvaluatingJavaScriptFromString:@"window._hideMessage = function() { document.location = 'bb://hidemessage'; };" ];
        [ webView stringByEvaluatingJavaScriptFromString:@"window._endGame = function() { document.location = 'bb://endgame'; };" ];
    }
    else if (webView == self.homeWebView)
    {        
        if ([ BBAppDelegate sharedDelegate ].isOnline)
        {
            NSDate* lastSyncFriends = [[ BBAppDelegate sharedDelegate ] getSetting:kBB_LastSyncFBFriends ];
            
            if (nil == lastSyncFriends || [ lastSyncFriends timeIntervalSinceNow ] > 60 * 24 * 1) // 1 day
            {
                [[ PFFacebookUtils facebook ] requestWithGraphPath:@"me/friends" andDelegate:self ];
            }
            else
            {
                [ self processFBFriends ];
            }
        }
        else
        {
            [ webView showLoading:NO ];
        }
    }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //
}

#pragma  mark UITableViewDelegate

- (NSArray*)dataForSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return self.myTurnGames;
        case 1:
            return self.theirTurnGames ;
        case 2:
            return self.completedGames ;
    }
    
    return nil;
}

-(void)selectGame:(CollabGame*)game
{
    self.webView.hidden = NO;
    self.currentGame = game;
    self.gameType = GAME_TYPE_TURN;
    
    PFUser* activeUser = self.currentGame.activeUser;
    PFUser* creator = self.currentGame.creator;
    NSMutableArray* rounds = self.currentGame.rounds;
    
    PFUser* cu = [ PFUser currentUser ];

    BOOL isActive = [ activeUser.objectId isEqualToString:[ PFUser currentUser ].objectId ];
    BOOL isCreator = [ creator.objectId isEqualToString:[ PFUser currentUser ].objectId ];
    
    BOOL isTheirTurn = [self.theirTurnGames containsObject:game];
    
    // See if we are in a new round...
    BOOL generateState = (isCreator && [ rounds count ] % 2 == 0);
    BOOL createRound = (isCreator && [ rounds count ] % 2 == 0) || (!isCreator && [ rounds count ] % 2 == 1);
    
    if (isTheirTurn)
    {
        return;
    }
    
    NSString* state = self.currentGame.state;
    NSString* gameData = @"null";

    if (state && [ state length ])
    {
        gameData = state;
    }
    
    [ self hideMenu ];
    
    if (createRound)
    {
        NSString* json = [ self.webView stringByEvaluatingJavaScriptFromString:[ NSString stringWithFormat:@"loadGame(2, %@, %@, %@, 0);", isActive ? @"true" : @"false", gameData, generateState ? @"true" : @"false", nil ] ];
        
        NSLog(@"%@", json);
        
        self.currentRound = [ CollabRound object ];
        self.currentRound.userId = [ PFUser currentUser ].objectId;
        self.currentRound.completed = NO;
        self.currentRound.duration = 0;
        self.currentRound.elapsed = 0;
        self.currentRound.moves = 0;
        self.currentRound.moveLog = @"[]";
        
        [ rounds addObject:self.currentRound ];
        
        self.currentGame.state = json;
        self.currentGame.rounds = rounds;
        self.currentGame.tokenCount = 0;

        [ self.currentGame.baseObj save ];
    }
    else
    {
        self.currentRound = [ CollabRound objectWithObject:[ self.currentGame.rounds objectAtIndex:[ self.currentGame.rounds count ] - 1 ]];

        NSString* json = [ self.webView stringByEvaluatingJavaScriptFromString:[ NSString stringWithFormat:@"try { loadGame(2, %@, %@, false, %f); } catch (e) { _alert(e); }", isActive ? @"true" : @"false", gameData, self.currentRound.elapsed, nil ] ];
        
        NSLog(@"%@", json);
    }
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ _tableView deselectRowAtIndexPath:indexPath animated:YES ];
    
    if (indexPath.section == 0)
    {
        NSArray* gameList = [ self dataForSection:indexPath.section ];
        [ self selectGame:[ gameList objectAtIndex:indexPath.row ]];
    }
    else
    {
        // show some details on the game here
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return [ self.myTurnGames count ];
        case 1:
            return [ self.theirTurnGames count ];
        case 2:
            return [ self.completedGames count ];
    }
    
    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell * cell = [ _tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" ] ;
    
    if (!cell)
    {
        cell = [[ UITableViewCell alloc ] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell" ];
    }
    
    NSArray* list;

    switch (indexPath.section)
    {
        case 0:
            list = self.myTurnGames;
            break;
        case 1:
            list = self.theirTurnGames;
            break;
        case 2:
            list = self.completedGames;
            break;
    }

    CollabGame* obj = [ list objectAtIndex:indexPath.row ];
    NSArray* users = obj.users;
    
    for (PFUser* user in users)
    {
        if (user != [ PFUser currentUser ])
        {
            cell.textLabel.text = [ user objectForKey:@"name" ];
            //[cell.imageView loadImageWithURL:[ NSURL URLWithString:[ user objectForKey:@"profilePicture" ]]];
            break;
        }
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [ dateFormatter setDateFormat:@"MM/dd/YYYY" ];
     
    NSDate* date = (nil != obj.updatedAt) ? obj.updatedAt : obj.createdAt;
    
    cell.detailTextLabel.text = [ NSString stringWithFormat:@"Last updated: %@", [ dateFormatter stringFromDate:date ]] ;
    cell.detailTextLabel.text = [ Utils stringForScores:obj gameOver:obj.completed ];

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Your Turn, Their Turn, Past Games
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"Your Turn";
        case 1:
            return @"Their Turn";
        case 2:
            return @"Finished Games";
    }
    
    return @"";
}

- (PFUser*)randomUser
{
    PFQuery* userQuery = [PFQuery queryWithClassName:@"_User"];
    [ userQuery whereKey:@"objectId" notEqualTo:[ PFUser currentUser ].objectId ];
    [ userQuery setLimit:1 ];
    
    return [[ userQuery findObjects ] objectAtIndex:0 ];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [ self loadGameType:buttonIndex+1 ];
}

-(void)loadGameType:(GAME_TYPE)type
{
    NSString* executeString = @"";
    
    switch (type)
    {
        case GAME_TYPE_LOCAL:
        {
            executeString = @"try { loadGame(0); } catch(e) { _alert(e); }";
        }
            break;
        case GAME_TYPE_BLITZ:
        {
            executeString = @"loadGame(1);";
        }
            break;
        case GAME_TYPE_TURN:
        {
            executeString = @"loadGame(2);";
        }
            break;
    }
    
    self.gameType = type;
    
    if (type == GAME_TYPE_TURN)
    {
        self.webView.hidden = YES;
        self.homeWebView.hidden = NO;
    }
    else
    {
        self.currentGame = nil;
        [ self.webView stringByEvaluatingJavaScriptFromString:executeString ];
        
        [ self hideMenu ];
    }
    
    sleep(0);
}

#pragma mark FacebookDelegate

-(void)loadFriends
{
    NSMutableString* executeString = [[ NSMutableString alloc ] initWithString:@"try { document.getElementById('container').innerHTML = ''; window.load([" ];
    
    for (FacebookFriend* friend in self.friends)
    {
        [ executeString appendFormat:@"{ name: '%@', id: '%@', exists: %@ }, ", friend.name, friend.userId, friend.user ? @"true" : @"false", nil ];
    }
    
    [ executeString appendString:@"]); } catch (e) { alert('x:' + e); }" ];
    
    [ self.homeWebView stringByEvaluatingJavaScriptFromString:@"window.setClickHandler(function(index) { document.location = 'bb://person/' + index; });" ];
    [ self.homeWebView stringByEvaluatingJavaScriptFromString:executeString ];
    [ self.homeWebView showLoading:NO ];
    
    self.isLoadingPeople = NO;
    
    if (!self.isLoadingGames && !self.isLoadingPeople)
    {
        [ self showMenu ];
    }
}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(PF_FBRequest *)request didFailWithError:(NSError *)error
{
    [ self.homeWebView showLoading:NO ];
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number,
 * depending on thee format of the API response.
 */
- (void)request:(PF_FBRequest *)request didLoad:(id)result
{
    NSDictionary* dict = result;
    NSArray* data = [ dict objectForKey:@"data" ];
    
    [[ BBAppDelegate sharedDelegate ] saveSetting:data forKey:kBB_FBFriends ];
    [[ BBAppDelegate sharedDelegate ] saveSetting:[ NSDate date ] forKey:kBB_LastSyncFBFriends ];
    
    [ self processFBFriends ];
}

-(void)processFBFriends
{
    NSMutableDictionary* data = [[ BBAppDelegate sharedDelegate ] getSetting:kBB_FBFriends ];
    
    self.friends = [ NSMutableArray array ];
    NSMutableArray* ids = [ NSMutableArray array ];
    
    for (NSDictionary* item in data)
    {
        NSString* name = [ item objectForKey:@"name" ];
        NSString* userId = [ item objectForKey:@"id" ];
        
        FacebookFriend* friend = [[ FacebookFriend alloc ] init ];
        friend.name = name;
        friend.userId = userId;
        
        [self.friends addObject:friend ];
        [ ids addObject:userId ];
    }
    
    PFQuery* userQuery = [PFQuery queryWithClassName:@"_User"];
    userQuery.maxCacheAge = 60 * 60 * 24 * 1; // 1 day
    userQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    
    [ userQuery whereKey:@"facebookId" containedIn:ids ];
    
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         for (PFUser* user in objects)
         {
             NSString* facebookId = [ user objectForKey:@"facebookId" ];
             
             for (FacebookFriend* friend in self.friends)
             {
                 if ([ friend.userId isEqualToString:facebookId ])
                 {
                     friend.user = user;
                     break;
                 }
             }
         }
         
         [ self.friends sortUsingSelector:@selector(sortByLoyalty:) ];
         [ self performSelectorOnMainThread:@selector(loadFriends) withObject:nil waitUntilDone:NO ];
     }];
}

#pragma mark Pull To Refresh Delegate


- (void)egoRefreshTableHeaderDidTriggerRefresh:(PF_EGORefreshTableHeaderView*)view
{
    if (!self.isLoadingGames)
    {
        [ self loadGames:YES ];
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(PF_EGORefreshTableHeaderView*)view
{
    return self.isLoadingGames;
}

# pragma mark scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    [self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

/*
- (void)refreshLastUpdatedDate;
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
*/

@end
