//
//  BBPeopleViewController.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBPeopleViewController.h"
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

#import "UIWebView+Stylizer.h"

@interface BBPeopleViewController ()<PF_EGORefreshTableHeaderDelegate,PF_FBRequestDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray* friends;
@property (nonatomic, strong) NSMutableArray* sections;
@property (nonatomic, strong) NSMutableArray* objects;
@property (nonatomic, strong) IBOutlet UITableView* tableView;
@property (nonatomic, strong) PF_EGORefreshTableHeaderView* refreshHeaderView;
@property (nonatomic, readwrite) BOOL isLoading;
@property (nonatomic, readwrite) BOOL forceRefresh;

@end

@implementation BBPeopleViewController

@synthesize friends;
@synthesize isLoading;
@synthesize sections;
@synthesize objects;
@synthesize tableView;
@synthesize gameDelegate;
@synthesize forceRefresh;
@synthesize refreshHeaderView;

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
    
    NSString *urlAddress = [[NSBundle mainBundle] pathForResource:@"people" ofType:@"html"];
    
    NSURL *url = [NSURL fileURLWithPath:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    self.refreshHeaderView = [[ DDPullToRefreshView alloc ] init ];
    self.refreshHeaderView.delegate = self;
    
    self.tableView.tableHeaderView = self.refreshHeaderView;
    
    //[ self.webView loadRequest:requestObj ];
    //[ self.webView stylize:YES ];
    
    if ([ BBAppDelegate sharedDelegate ].isOnline)
    {
        NSDate* lastSyncFriends = [[ BBAppDelegate sharedDelegate ] getSetting:kBB_LastSyncFBFriends ];
        
        if (YES || nil == lastSyncFriends || [ lastSyncFriends timeIntervalSinceNow ] > 60 * 24 * 1) // 1 day
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
        [ self.view showLoading:NO ];
    }
    
    self.sections = [ NSMutableArray arrayWithCapacity:26 ];
    self.objects = [ NSMutableArray arrayWithCapacity:26 ];
    self.tableView.backgroundColor = [ UIColor colorWithRed:0.173 green:0.18 blue:0.196 alpha:1 ];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(IBAction)localGameClicked:(id)sender
{
    [ self.gameDelegate startGame:GAME_TYPE_LOCAL ];
}

#pragma mark UITableViewDataSource

- (NSArray*)dataForSection:(NSInteger)section
{
    /*switch (section)
    {
        case 0:
            return self.myTurnGames;
        case 1:
            return self.theirTurnGames ;
        case 2:
            return self.completedGames ;
    }*/
    
    return nil;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ _tableView deselectRowAtIndexPath:indexPath animated:YES ];

    FacebookFriend* friend = [((NSMutableArray*)[ self.objects objectAtIndex:indexPath.section ]) objectAtIndex:indexPath.row ];
    
    if (friend.user)
    {
        CollabGame* currentGame = [ CollabGame object ];
        currentGame.completed = NO;
        currentGame.creator = [ PFUser currentUser ];
        currentGame.activeUser = [ PFUser currentUser ];
        currentGame.users = [ NSMutableArray arrayWithObjects:[ PFUser currentUser ], friend.user, nil ];
        currentGame.rounds = [ NSMutableArray array ];
        
        [ self.gameDelegate selectGame:currentGame isNew:YES ];
    }
    
    /*
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
        
        BBResultsViewController* controller = [[ BBResultsViewController alloc ] initWithNibName:@"BBResultsViewController" bundle:nil ];
        controller.game = game;
        
        self.popover = [[ UIPopoverController alloc ] initWithContentViewController:controller ];
        self.popover.popoverContentSize = CGSizeMake(520, 600);
        self.popover.delegate = self;
        
        CGRect aFrame = [ self.tableView convertRect:[self.tableView rectForRowAtIndexPath:indexPath]  toView:self.view.superview ];
        aFrame = CGRectMake(aFrame.origin.x, aFrame.origin.y, 50, 50);
        
        [ self.view.superview showFade:YES ];
        [ self.popover presentPopoverFromRect:aFrame inView:self.view.superview permittedArrowDirections:UIPopoverArrowDirectionLeft|UIPopoverArrowDirectionDown|UIPopoverArrowDirectionUp animated:YES ];
    }
    */
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [ self.sections objectAtIndex:section ];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!self.objects) return 0;
    
    return [ self.objects count ];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.objects) return 0;
    return [[ self.objects objectAtIndex:section ] count ];
    //return [[ self.groupedFriends objectAtIndex:section ] count ];
    /*
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
    */
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
    return 50;
}

-(void)refreshRow:(NSIndexPath*)indexPath
{
    [ self.tableView reloadRowsAtIndexPaths:[ NSArray arrayWithObject:indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic ];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray* s = [ NSMutableArray arrayWithArray:self.sections ];
    
    if ([ s count ])
    {
        [ s replaceObjectAtIndex:0 withObject:@"*" ];
    }
    
    return s;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell * cell = [ _tableView dequeueReusableCellWithIdentifier:@"BBPersonCell" ] ;
    
    if (!cell)
    {
        cell = [[ UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BBPersonCell" ];
        cell.accessoryView = [[ UIImageView alloc ] initWithFrame:CGRectMake(0, 0, 50, 50) ];
        // cell.backgroundView = [[ UIImageView alloc ] initWithImage:[ UIImage imageNamed:@"img/cell-gradient.png" ]];
        cell.backgroundColor =  [ UIColor colorWithRed:0.173 green:0.18 blue:0.196 alpha:1 ];
        cell.detailTextLabel.backgroundColor = [ UIColor clearColor ];
        cell.textLabel.backgroundColor = [ UIColor clearColor ];
        cell.textLabel.textColor = [ UIColor whiteColor ];
        cell.textLabel.font = [ UIFont boldSystemFontOfSize:14 ];
        
        UIView* spacer = [[ UIImageView alloc ] initWithImage:[ UIImage imageNamed:@"img/cell-border.png" ]];
        spacer.frame = CGRectMake(0, cell.bounds.size.height - 2, cell.bounds.size.width, 2);
        spacer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
        [ cell addSubview:spacer ];
    }
    
    FacebookFriend* friend = [((NSArray*)[ self.objects objectAtIndex:indexPath.section ]) objectAtIndex:indexPath.row ];
    
    cell.accessoryView.frame = CGRectMake(0, 0, 50, 50);
    cell.accessoryView.clipsToBounds = YES;
    cell.accessoryView.contentMode = UIViewContentModeScaleAspectFill;
    
    cell.textLabel.text = friend.name;
    
     ((UIImageView*)cell.accessoryView).image = nil;
    
    [ ((UIImageView*)cell.accessoryView) loadImageWithURL:[ NSURL URLWithString:[ NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", friend.userId ]] onComplete:^
     {
         //[ self performSelectorOnMainThread:@selector(refreshRow:) withObject:indexPath waitUntilDone:NO ];
     }];
    
    return cell;
}

#pragma mark FacebookDelegate

-(void)loadFriends
{
    [ self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView ];
    [ self.tableView reloadData ];
}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(PF_FBRequest *)request didFailWithError:(NSError *)error
{
    [ self.view showLoading:NO ];
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
    
    NSMutableDictionary* dict = [ NSMutableDictionary dictionaryWithCapacity:26 ];
    
    for (NSDictionary* item in data)
    {
        NSString* name = [ item objectForKey:@"name" ];
        NSString* userId = [ item objectForKey:@"id" ];
        
        NSLog(@"%@", name);
        
        FacebookFriend* friend = [[ FacebookFriend alloc ] init ];
        friend.name = name;
        friend.userId = userId;
        
        NSRange range = [ name rangeOfString:@" " ];
        NSString* lastChar = [[ name substringToIndex:1 ] uppercaseString ];
        
        if (range.length)
        {
            lastChar = [[[ name substringFromIndex:range.location + 1 ] substringToIndex:1 ] uppercaseString ];
        }
        
        NSMutableArray* group = [ dict objectForKey:lastChar ];
        
        if (!group)
        {
            group = [ NSMutableArray array ];
            
            [ dict setValue:group forKey:lastChar ];
        }
        
        [ group addObject:friend ];
        
        [self.friends addObject:friend ];
        [ ids addObject:userId ];
    }
    
    [ self.sections removeAllObjects ];
    [ self.objects removeAllObjects ];
    
    [ self.sections addObject:@"ACTIVE PLAYERS" ];
    [ self.objects addObject:[ NSMutableArray array ]];
    
    for (NSString* key in [[ dict allKeys ] sortedArrayUsingComparator:^(id obj1, id obj2) { return [ obj1 compare:obj2 options:0 ]; } ])
    {
        [ self.sections addObject:key ];
        [ self.objects addObject:[ dict objectForKey:key ] ];
    }
    
    PFQuery* userQuery = [PFQuery queryWithClassName:@"_User"];
    userQuery.maxCacheAge = (self.forceRefresh) ? 0 : 60 * 60 * 24 * 1; // 1 day
    userQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    
    [ userQuery whereKey:@"facebookId" containedIn:ids ];
    
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objs, NSError *error)
     {
         NSMutableArray* activeFriends = [ self.objects objectAtIndex:0 ];
         
         for (PFUser* user in objs)
         {
             NSString* facebookId = [ user objectForKey:@"facebookId" ];
             
             for (FacebookFriend* friend in self.friends)
             {
                 if ([ friend.userId isEqualToString:facebookId ])
                 {
                     [ activeFriends addObject:friend ];
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
    if (!self.isLoading)
    {
        self.forceRefresh = YES;
        [[ PFFacebookUtils facebook ] requestWithGraphPath:@"me/friends" andDelegate:self ];
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
