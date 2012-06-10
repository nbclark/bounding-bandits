//
//  BBGamesTableViewController.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBGamesTableViewController.h"
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
#import "DDPullToRefreshView.h"
#import <UIKit/UIKit.h>
#import "BBResultsViewController.h"
#import "BBGameCell.h"

@interface BBGamesTableViewController ()<PF_EGORefreshTableHeaderDelegate,UIPopoverControllerDelegate>

@property (nonatomic, strong) NSMutableArray* myTurnGames;
@property (nonatomic, strong) NSMutableArray* theirTurnGames;
@property (nonatomic, strong) NSMutableArray* completedGames;
@property (nonatomic, strong) PF_EGORefreshTableHeaderView* refreshHeaderView;
@property (nonatomic, strong) UIPopoverController* popover;
@property (nonatomic, strong) BoringBlock closePopoverBlock;

@end

@implementation BBGamesTableViewController

@synthesize gameDelegate;
@synthesize myTurnGames;
@synthesize theirTurnGames;
@synthesize completedGames;
@synthesize refreshHeaderView;
@synthesize isLoading;
@synthesize popover;
@synthesize closePopoverBlock;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)userDidLogIn
{
    [ self loadData ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.refreshHeaderView = [[ DDPullToRefreshView alloc ] init ];
    self.refreshHeaderView.delegate = self;
    
    self.tableView.tableHeaderView = self.refreshHeaderView;
    
    self.completedGames = [ NSMutableArray array ];
    self.myTurnGames = [ NSMutableArray array ];
    self.theirTurnGames = [ NSMutableArray array ];
    self.isLoading = YES;
    
    // 2C2E32
    self.tableView.backgroundColor = [ UIColor colorWithRed:24/256.0 green:24/256.0 blue:24/256.0 alpha:1 ];
    //self.tableView.backgroundColor = [ UIColor clearColor ];
    UIImage* img = [ UIImage imageNamed:@"img/bg-app.jpg" ];
    //self.tableView.backgroundView = [[ UIImageView alloc ] initWithImage:img];
    //self.tableView.backgroundView.frame = self.tableView.bounds;
    
    [[ NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(userDidLogIn) name:@"kUserDidLogIn" object:nil ];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated ];
}

-(NSUInteger)activeGames
{
    return [ self.myTurnGames count ] + [ self.theirTurnGames count ];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(void)gameCreated:(CollabGame*)game
{
    [ self.myTurnGames insertObject:game atIndex:0 ];
    [ self.tableView reloadData ];
    
    [[ UIApplication sharedApplication ] setApplicationIconBadgeNumber:[ self.myTurnGames count ] ];
}

-(void)gameTurnEnded:(CollabGame*)game
{
    if ([ self.myTurnGames containsObject:game ])
    {
        [ self.myTurnGames removeObject:game ];
        [ self.theirTurnGames insertObject:game atIndex:0 ];
        [ self.tableView reloadData ];
    }
    
    [[ UIApplication sharedApplication ] setApplicationIconBadgeNumber:[ self.myTurnGames count ] ];
}

-(void)finishedLoading
{
    [ self.tableView reloadData ];
    [ self.tableView showLoading:NO ];
    
    self.isLoading = NO;
    
    [ self.gameDelegate signalLoadComplete:self ];
}

-(void)loadData
{
    self.isLoading = YES;
    [ self.tableView showLoading:YES ];
    [ self loadGames:NO ];
}

-(void)loadGames:(BOOL)forceRefresh
{
    if ([ PFUser currentUser ])
    {
        PFQuery *query = [ PFQuery queryWithClassName:@"CollabGame" ];
        
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
        
        [ query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             [ self processLoadedGames:objects fromCache:NO ];
             
         } ];
    }
}

-(void)processLoadedGames:(NSArray*)objects fromCache:(BOOL)fromCache
{
    if (!fromCache)
    {
        [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
    
    NSMutableArray* games = [ PFObjectExt arrayWithArray:objects className:@"CollabGame" loadSubObjects:NO ];
    
    NSMutableDictionary* userObjects = [ NSMutableDictionary dictionary ];
    NSMutableArray* userLists = [ NSMutableArray array ];
    
    for (CollabGame* game in games)
    {
        for (PFUser* user in game.users)
        {
            if (![ userObjects objectForKey:user.objectId ])
            {
                [ userObjects setObject:user forKey:user.objectId ];
            }
        }
        
        [ userLists addObject:game.users ];
    }
    
    if ([ userObjects count ])
    {
        PFQuery* query = [ PFQuery queryWithClassName:@"_User" ];
        [ query whereKey:@"objectId" containedIn:[ userObjects allKeys ]];
        
        for (PFObject* obj in [ query findObjects ])
        {
            for (NSMutableArray* array in userLists)
            {
                for (uint i = 0; i < [ array count ]; ++i)
                {
                    PFObject* userObj = [ array objectAtIndex:i ];
                    
                    if ([ userObj.objectId isEqualToString:obj.objectId ])
                    {
                        [ array replaceObjectAtIndex:i withObject:obj ];
                    }
                }
            }
        }
    }
    
    /*
    for (CollabGame* game in games)
    {
        game.rounds = [ NSMutableArray array ];
        int index = 0;
        for (PFObject* roundObj in game.legacyRounds)
        {
            CollabRound* round = [ CollabRound objectWithObject:roundObj ];
            
            NSDictionary* dictionary = [ NSDictionary dictionaryWithObjectsAndKeys:
                                        [ NSNumber numberWithInteger:index ], @"Index",
                                        round.userId, @"UserId",
                                        [ NSNumber numberWithBool:round.completed ], @"Completed",
                                        [ NSNumber numberWithBool:round.success ], @"Success",
                                        [ NSNumber numberWithFloat:round.duration ], @"Duration",
                                        [ NSNumber numberWithFloat:round.elapsed ], @"Elapsed",
                                        [ NSNumber numberWithInteger:round.moves ], @"Moves",
                                        round.moveLog, @"MoveLog",
                                        round.state, @"State",
                                        nil ];
            
            [ game.rounds addObject:dictionary ];
            index++;
        }
        
        [ game save ];
    }*/
    
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

-(void)dismissPopover
{
    [ self popoverControllerShouldDismissPopover:self.popover ];
    [ self.popover dismissPopoverAnimated:YES ];
}

#pragma mark - Table view data source

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

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ _tableView deselectRowAtIndexPath:indexPath animated:YES ];
    
    if (indexPath.section == 0)
    {
        
        NSArray* gameList = [ self dataForSection:indexPath.section ];
        [ self.gameDelegate selectGame:[ gameList objectAtIndex:indexPath.row ] isNew:NO ];
    }
    else
    {
        // show some details on the game here
        
        CollabGame* game = [[ self dataForSection:indexPath.section ] objectAtIndex:indexPath.row ];
        
        CGRect aFrame = [ self.tableView convertRect:[self.tableView rectForRowAtIndexPath:indexPath] toView:self.view.superview ];
        aFrame = CGRectMake(aFrame.origin.x, aFrame.origin.y, 50, 50);
        
        [ self showResults:game fromRect:aFrame onClose:nil ];
    }
}

-(void)showResults:(CollabGame*)game fromRect:(CGRect)aFrame onClose:(BoringBlock)onClose
{
    self.closePopoverBlock = onClose;
    
    BBResultsViewController* controller = [[ BBResultsViewController alloc ] initWithNibName:@"BBResultsViewController" bundle:nil ];
    controller.game = game;
    controller.delegate = self;
    controller.showStart = nil != onClose;
    
    if (aFrame.size.width == 0)
    {
        aFrame = CGRectMake(self.view.bounds.size.width / 2 - 25, 0, 50, 50);
    }
    
    self.popover = [[ UIPopoverController alloc ] initWithContentViewController:controller ];
    self.popover.popoverContentSize = CGSizeMake(520, 520+120+70);
    self.popover.delegate = self;
    
    [ self.view.superview showFade:NO ];
    [ self.popover presentPopoverFromRect:aFrame inView:self.view.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES ];
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    [ self.view.superview showFade:NO ];
    
    if (self.closePopoverBlock)
    {
        self.closePopoverBlock();
        self.closePopoverBlock = nil;
    }
    
    return YES;
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

-(void)refreshRow:(NSIndexPath*)indexPath
{
    [ self.tableView reloadRowsAtIndexPaths:[ NSArray arrayWithObject:indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic ];
}

-(UIView*)tableView:(UITableView *)_tableView viewForHeaderInSection:(NSInteger)section
{
    CAGradientLayer *gradient = [ CAGradientLayer layer ];
    gradient.frame = CGRectMake(0,0,_tableView.bounds.size.width,30);
    gradient.colors = [ NSArray arrayWithObjects:(id)[[ UIColor whiteColor ] CGColor ], (id)[[ UIColor colorWithRed:0.839 green:0.863 blue:0.898 alpha:1 ] CGColor ], nil];
    
    UIView* backgroundView = [[ UIView alloc ] initWithFrame:CGRectMake(0, 0, 20, 30) ];
    UIView* containerView = [[ UIView alloc ] initWithFrame:CGRectMake(0, 0, 20, 31) ];
    UILabel* textView = [[ UILabel alloc ] initWithFrame:CGRectMake(6, 0, 0, 30) ];
    containerView.backgroundColor = [ UIColor blackColor ];
    
    textView.font = [ UIFont boldSystemFontOfSize:12 ];
    textView.backgroundColor = [ UIColor clearColor ];
    textView.textColor = [ UIColor colorWithWhite:0 alpha:1 ];
    textView.text = [ self tableView:_tableView titleForHeaderInSection:section ];
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [ containerView addSubview:backgroundView ];
    [ containerView addSubview:textView ];
    [ backgroundView.layer insertSublayer:gradient atIndex:0 ];
    
    return containerView;
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 31;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	BBGameCell * cell = [ _tableView dequeueReusableCellWithIdentifier:@"BBGameCell" ] ;
    
    if (!cell)
    {
        cell = [ BBGameCell cell ];
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
    
    [ cell setValue:obj asActive:(indexPath.section == 0) asCompleted:(indexPath.section == 2) ];
    return cell;
    
    PFUser* otherUser = [ obj otherUser ];
    
    cell.textLabel.text = [ otherUser objectForKey:@"name" ];
    [(UIImageView*)cell.accessoryView loadImageWithURL:[ NSURL URLWithString:[ otherUser objectForKey:@"profilePicture" ]]defaultImage:[ UIImage imageNamed:@"img/noface.png" ] onComplete:^
     {
         [ self performSelectorOnMainThread:@selector(refreshRow:) withObject:indexPath waitUntilDone:NO ];
     }];
    
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
            return @"YOUR TURN (TAP TO PLAY)";
        case 1:
            return @"OPPONENT'S TURN";
        case 2:
            return @"RECENT GAMES";
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

#pragma mark Pull To Refresh Delegate


- (void)egoRefreshTableHeaderDidTriggerRefresh:(PF_EGORefreshTableHeaderView*)view
{
    if (!self.isLoading)
    {
        [ self loadGames:YES ];
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(PF_EGORefreshTableHeaderView*)view
{
    return self.isLoading;
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

@end
