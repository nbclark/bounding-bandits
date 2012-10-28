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
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <Twitter/Twitter.h>
#import <Social/Social.h>

#import "UIWebView+Stylizer.h"

@interface BBPeopleViewController ()<PF_EGORefreshTableHeaderDelegate,PF_FBRequestDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray* friends;
@property (nonatomic, strong) NSMutableArray* sections;
@property (nonatomic, strong) NSMutableArray* objects;
@property (nonatomic, strong) FacebookFriend* inviteFriend;
@property (nonatomic, assign) IBOutlet UITableView* tableView;
@property (nonatomic, assign) IBOutlet UIButton* randomButton;
@property (nonatomic, assign) IBOutlet UIButton* localModeButton;
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
@synthesize randomButton;
@synthesize localModeButton;
@synthesize inviteFriend;

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
    [ self loadData:NO ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.refreshHeaderView = [[ DDPullToRefreshView alloc ] init ];
    self.refreshHeaderView.delegate = self;
    self.tableView.tableHeaderView = self.refreshHeaderView;
    
    self.sections = [ NSMutableArray arrayWithCapacity:26 ];
    self.objects = [ NSMutableArray arrayWithCapacity:26 ];
    self.tableView.backgroundColor = [ UIColor clearColor ];//[ UIColor colorWithRed:0.173 green:0.18 blue:0.196 alpha:1 ];
    [[ NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(userDidLogIn) name:@"kUserDidLogIn" object:nil ];
    
    UIPanGestureRecognizer* gesture = [[ UIPanGestureRecognizer alloc ] initWithTarget:self action:@selector(handlePan:) ];
    [ self.view addGestureRecognizer:gesture ];
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

-(void)moveView:(UIView*)view fromPoint:(CGPoint)from toPoint:(CGPoint)to duration:(float)duration
{    
    CABasicAnimation * anim = [ CABasicAnimation animationWithKeyPath:@"position" ] ;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion = NO;
    anim.toValue = [ NSValue valueWithCGPoint:to ] ;
    anim.duration = 1 * duration ;
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

- (void)handlePan:(UIPanGestureRecognizer*)recognizer
{
    CGPoint translation = [recognizer translationInView:recognizer.view];
    
    float x = MAX(MIN(translation.x, (self.view.bounds.size.width+5)), 0);
    
    translation = CGPointMake(x, 0);
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {    
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        self.view.transform = CGAffineTransformMakeTranslation(translation.x, 0);
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        CGPoint pos;
        
        if (translation.x < self.view.bounds.size.width / 4)
        {
            pos = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
        }
        else
        {
            pos = CGPointMake(self.view.bounds.size.width * 1.5, self.view.bounds.size.height / 2);
        }
        
        [ self moveView:self.view fromPoint:[ self positionWithTranslationInView:self.view ] toPoint:pos duration:0.25 ];
        
        self.view.transform = CGAffineTransformIdentity;
    }
}

-(void)show
{
    CGPoint pos = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
    [ self moveView:self.view fromPoint:[ self positionWithTranslationInView:self.view ] toPoint:pos duration:0.25 ];
}

-(void)loadData:(BOOL)force
{
    BOOL willLoad = NO;
    
    if ([ BBAppDelegate sharedDelegate ].isOnline)
    {
        NSDate* lastSyncFriends = [[ BBAppDelegate sharedDelegate ] getSetting:kBB_LastSyncFBFriends ];
        
        if (([ PFFacebookUtils isLinkedWithUser:[ PFUser currentUser ]] && (force || nil == lastSyncFriends || [ lastSyncFriends timeIntervalSinceNow ] > 60 * 24 * 1))) // 1 day
        {
            willLoad = YES;
            [[ PFFacebookUtils facebook ] requestWithGraphPath:@"me/friends" andDelegate:self ];
        }
        else
        {
            [ self processFriends ];
        }
        
        lastSyncFriends = [[ BBAppDelegate sharedDelegate ] getSetting:kBB_LastSyncTWFriends ];
        
        if ([ PFTwitterUtils isLinkedWithUser:[ PFUser currentUser ]] && (YES || nil == lastSyncFriends || [ lastSyncFriends timeIntervalSinceNow ] > 60 * 24 * 1)) // 1 day
        {
            NSMutableURLRequest* request = [ NSMutableURLRequest requestWithURL:[ NSURL URLWithString:@"https://api.twitter.com/1/friends/ids.json" ]];
            [[ PFTwitterUtils twitter ] signRequest:request ];
            
            willLoad = YES;
            
            [ NSURLConnection sendAsynchronousRequest:request queue:[ NSOperationQueue currentQueue ] completionHandler:^(NSURLResponse * response, NSData * data, NSError * err) {
                
                NSString* json = [[ NSString alloc ] initWithData:data encoding:NSUTF8StringEncoding ];
                NSArray* ids = [[ json objectFromJSONString ] objectForKey:@"ids" ];
                
                NSString* idString = [ ids componentsJoinedByString:@"," ];
                
                NSMutableURLRequest* dataRequest = [ NSMutableURLRequest requestWithURL:[ NSURL URLWithString:[ NSString stringWithFormat:@"https://api.twitter.com/1/users/lookup.json?user_id=%@&include_entities=true", idString ]]];
                
                [ NSURLConnection sendAsynchronousRequest:dataRequest queue:[ NSOperationQueue currentQueue ] completionHandler:^(NSURLResponse * response, NSData * data, NSError * err) {
                    
                    NSString* json2 = [[ NSString alloc ] initWithData:data encoding:NSUTF8StringEncoding ];
                    NSArray* users = [ json2 objectFromJSONString ];
                    
                    NSMutableArray* userData = [ NSMutableArray arrayWithCapacity:[ users count ]];
                    
                    for (NSDictionary* dict in users)
                    {
                        NSDictionary* dictCopy = [ NSDictionary dictionaryWithObjectsAndKeys:[ dict objectForKey:@"name" ], @"name", [ NSString stringWithFormat:@"%d", [ dict objectForKey:@"id" ] ], @"id", [ dict objectForKey:@"profilePicture" ], @"image", nil ];
                        
                        [ userData addObject:dictCopy ];
                    }
                    
                    [[ BBAppDelegate sharedDelegate ] saveSetting:userData forKey:kBB_TWFriends ];
                    [[ BBAppDelegate sharedDelegate ] saveSetting:[ NSDate date ] forKey:kBB_LastSyncTWFriends ];

                    [ self processFriends ];
                    
                }];
            }];
        }
        else
        {
            [ self processFriends ];
        }
    }
    else
    {
        [ self.view showLoading:NO ];
    }
    
    if (!willLoad)
    {
        [ self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView ];
    }
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

-(IBAction)randomGameClicked:(id)sender
{
    PFQuery* query = [ PFUser query ];
    [ query whereKey:@"objectId" notEqualTo:[ PFUser currentUser ].objectId ];
    NSUInteger count = [ query countObjects ];
    
    NSUInteger index = MIN(((double)rand() / RAND_MAX) * count, count - 1);
    
    [ query setSkip:index ];
    [ query setLimit:1 ];
    
    NSArray* users = [ query findObjects ];
    
    if ([ users count ])
    {
        CollabGame* currentGame = [ CollabGame object ];
        currentGame.completed = NO;
        currentGame.creator = [ PFUser currentUser ];
        currentGame.activeUser = [ PFUser currentUser ];
        currentGame.users = [ NSMutableArray arrayWithObjects:[ PFUser currentUser ], [ users objectAtIndex:0 ], nil ];
        currentGame.rounds = [ NSMutableArray array ];
        
        [ self.gameDelegate selectGame:currentGame isNew:YES ];
    }
    else
    {
        UIAlertView* v = [[ UIAlertView alloc ] initWithTitle:@"No Matches Found" message:@"No matching players were found" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil ];
        
        [ v show ];
    }
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

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO send invite here
    // [ self toggleInvite:[[ self.tableView indexPathsForSelectedRows ] count ] ];
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ _tableView deselectRowAtIndexPath:indexPath animated:YES ];
    
    if (indexPath.section == 0)
    {
    }
    else
    {
        FacebookFriend* friend = [[ self.objects objectAtIndex:indexPath.section ] objectAtIndex:indexPath.row ];
        
        NSString* st = [[ friend.name lowercaseString ] hasSuffix:@"twitter" ] ? SLServiceTypeTwitter : SLServiceTypeFacebook;
        
        SLComposeViewController* vc = [ SLComposeViewController composeViewControllerForServiceType:st ];
        [ vc setInitialText:@"Check out #BoundingBandits, a fun new board game for the iPad! http://goo.gl/VvFkr" ];
        [ vc addImage:[ UIImage imageNamed:@"img/Icon-72@2x" ]];
        
        [ self presentModalViewController:vc animated:YES ];
        return;
        
        self.inviteFriend = friend;
        UIActionSheet* as = [[ UIActionSheet alloc ] initWithTitle:[ NSString stringWithFormat:@"Invite %@ to Bounding Bandits", friend.name ] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Send Invite" otherButtonTitles:@"Cancel", nil ];
        
        [ as showInView:self.view ];
    }

    FacebookFriend* friend = [((NSMutableArray*)[ self.objects objectAtIndex:indexPath.section ]) objectAtIndex:indexPath.row ];
    
    if (friend.user)
    {
        // Check here for # of active games...
        CollabGame* currentGame = [ CollabGame object ];
        currentGame.completed = NO;
        currentGame.creator = [ PFUser currentUser ];
        currentGame.activeUser = [ PFUser currentUser ];
        currentGame.users = [ NSMutableArray arrayWithObjects:[ PFUser currentUser ], friend.user, nil ];
        currentGame.rounds = [ NSMutableArray array ];
        
        [ self.gameDelegate selectGame:currentGame isNew:YES ];
    }
    else
    {
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
    // 217, 30, 64
    UIColor* startGradColor = [ UIColor colorWithRed:217/256.0 green:30/256.0 blue:64/256.0 alpha:1 ];//[ UIColor whiteColor ];
    UIColor* gradColor = [ UIColor colorWithRed:217/256.0 green:30/256.0 blue:64/256.0 alpha:1 ];//[ UIColor colorWithRed:0.839 green:0.863 blue:0.898 alpha:1 ];
    CAGradientLayer *gradient = [ CAGradientLayer layer ];
    gradient.frame = CGRectMake(0,0,600,30);
    gradient.colors = [ NSArray arrayWithObjects:(id)[startGradColor CGColor ], (id)[gradColor CGColor ], nil];
    
    UIView* backgroundView = [[ UIView alloc ] initWithFrame:CGRectMake(0, 0, 20, 30) ];
    UIView* containerView = [[ UIView alloc ] initWithFrame:CGRectMake(0, 0, 20, 31) ];
    UILabel* textView = [[ UILabel alloc ] initWithFrame:CGRectMake(6, 0, 0, 30) ];
    containerView.backgroundColor = [ UIColor blackColor ];
    
    textView.font = [ UIFont boldSystemFontOfSize:12 ];
    textView.backgroundColor = [ UIColor clearColor ];
    textView.textColor = [ UIColor colorWithWhite:1 alpha:1 ];
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
    if ([[ self sections ] count ] < 15) return nil;
    
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
        cell.backgroundColor =  [UIColor colorWithWhite:0 alpha:0.4 ];//[ UIColor colorWithRed:0.173 green:0.18 blue:0.196 alpha:1 ];
        cell.detailTextLabel.backgroundColor = [ UIColor clearColor ];
        cell.textLabel.backgroundColor = [ UIColor clearColor ];
        cell.textLabel.textColor = [ UIColor whiteColor ];
        cell.textLabel.font = [ UIFont boldSystemFontOfSize:14 ];
        cell.contentView.backgroundColor = cell.backgroundColor;
        
        UIView* spacer = [[ UIImageView alloc ] initWithImage:[ UIImage imageNamed:@"img/cell-border.png" ]];
        spacer.frame = CGRectMake(0, cell.bounds.size.height - 2, cell.bounds.size.width, 2);
        spacer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
        [ cell addSubview:spacer ];
    }
    
    FacebookFriend* friend = [((NSArray*)[ self.objects objectAtIndex:indexPath.section ]) objectAtIndex:indexPath.row ];
    
    cell.accessoryView.frame = CGRectMake(0, 0, 50, 50);
    cell.accessoryView.clipsToBounds = YES;
    cell.accessoryView.contentMode = UIViewContentModeScaleAspectFill;
    // cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    cell.textLabel.text = friend.name;
    cell.detailTextLabel.text = friend.email;
    
     ((UIImageView*)cell.accessoryView).image = nil;
    
    if ([ friend.pictureUrl hasPrefix:@"img/" ])
    {
        [((UIImageView*)cell.accessoryView) setImage:[ UIImage imageNamed:friend.pictureUrl ]];
    }
    else
    {
        [ ((UIImageView*)cell.accessoryView) loadImageWithURL:[ NSURL URLWithString:friend.pictureUrl ] defaultImage:[ UIImage imageNamed:@"img/noface.png" ] onComplete:^
         {
             //[ self performSelectorOnMainThread:@selector(refreshRow:) withObject:indexPath waitUntilDone:NO ];
         }];
    }
    
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
    
    [ self processFriends ];
}

-(void)processFriends
{
    NSArray* fbData = [[ BBAppDelegate sharedDelegate ] getSetting:kBB_FBFriends ];
    NSArray* twData = [[ BBAppDelegate sharedDelegate ] getSetting:kBB_TWFriends ];
    
    ABAddressBookRef addressBook = ABAddressBookCreate( );
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );
    CFIndex nPeople = ABAddressBookGetPersonCount( addressBook );
    NSMutableDictionary* emails = [ NSMutableDictionary dictionaryWithCapacity:nPeople ];
    
    for ( int i = 0; i < nPeople; i++ )
    {
        ABRecordRef ref = CFArrayGetValueAtIndex( allPeople, i );
        NSString* firstName = [[ NSString stringWithFormat:@"%@", ABRecordCopyValue(ref, kABPersonFirstNameProperty) ] stringByTrimmingCharactersInSet:[ NSCharacterSet whitespaceCharacterSet ]];
        NSString* lastName = [[ NSString stringWithFormat:@"%@", ABRecordCopyValue(ref, kABPersonLastNameProperty) ] stringByTrimmingCharactersInSet:[ NSCharacterSet whitespaceCharacterSet ]];
        
        ABMultiValueRef emRef = ABRecordCopyValue(ref, kABPersonEmailProperty);
        NSArray* ems = (__bridge_transfer NSArray*)ABMultiValueCopyArrayOfAllValues(emRef);
        CFRelease(emRef);
        
        for (NSString* email in ems)
        {
            [ emails setObject:email forKey:[ NSString stringWithFormat:@"%@ %@", firstName, lastName ]];
        }
    }
    
    CFRelease(allPeople);
    CFRelease(addressBook);
    
    NSMutableArray* fs = [ NSMutableArray array ];
    NSMutableArray* ids = [ NSMutableArray array ];
    
    NSMutableDictionary* dict = [ NSMutableDictionary dictionaryWithCapacity:26 ];
    
    for (NSDictionary* item in fbData)
    {
        NSString* name = [ item objectForKey:@"name" ];
        NSString* userId = [ item objectForKey:@"id" ];
        
        NSLog(@"%@", name);
        
        FacebookFriend* friend = [[ FacebookFriend alloc ] init ];
        friend.name = name;
        friend.userId = userId;
        friend.pictureUrl = [ NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", friend.userId ];
        
        /*
        NSString* email = [ emails objectForKey:name ];
        
        if (email)
        {
            friend.email = email;
            
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
        }
        */
        
        [ fs addObject:friend ];
        [ ids addObject:userId ];
    }
    
    NSMutableArray* invite = [ NSMutableArray array ];
    FacebookFriend* twitter = [[ FacebookFriend alloc ] init ];
    twitter.name = @"Invite from Twitter";
    twitter.pictureUrl = @"img/tw.png";
    [ invite addObject:twitter ];
    
    FacebookFriend* facebook = [[ FacebookFriend alloc ] init ];
    facebook.name = @"Invite from Facebook";
    facebook.pictureUrl = @"img/fb.png";
    [ invite addObject:facebook ];
    
    [ dict setValue:invite forKey:@"INVITE FRIENDS" ];
    
    for (NSDictionary* item in twData)
    {
        NSString* name = [ item objectForKey:@"name" ];
        NSString* userId = [ item objectForKey:@"id" ];
        NSString* pictureUrl = [ item objectForKey:@"profilePicture" ];
        
        NSLog(@"%@", name);
        
        FacebookFriend* friend = [[ FacebookFriend alloc ] init ];
        friend.name = name;
        friend.userId = userId;
        friend.pictureUrl = pictureUrl;
        
        /*
        NSString* email = [ emails objectForKey:name ];
        
        if (email)
        {
            friend.email = email;

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
        }
         */
        
        [ fs addObject:friend ];
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
         NSMutableArray* activeFriends = [ NSMutableArray array ];
         
         for (PFUser* user in objs)
         {
             NSString* facebookId = [ user objectForKey:@"facebookId" ];
             
             for (FacebookFriend* friend in fs)
             {
                 if ([ friend.userId isEqualToString:facebookId ])
                 {
                     [ activeFriends addObject:friend ];
                     friend.user = user;
                     break;
                 }
             }
         }
         
         [ self.objects replaceObjectAtIndex:0 withObject:activeFriends ];
         
         self.friends = fs;
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
        [ self loadData:YES ];
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

# pragma mark action sheet delegate


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    MFMailComposeViewController *picker = [[ MFMailComposeViewController alloc ] init ];
    NSString *emailBody = [ NSString stringWithFormat:@"<html>Hey %@,<p>I would like to play you in a game on Bounding Bandits!</p></html>", self.inviteFriend.name ];
    
    [ picker setToRecipients:[ NSArray arrayWithObject:self.inviteFriend.email ]];
    [ picker setSubject:@"Join me on Bounding Bandits" ];
    [ picker setMessageBody:emailBody isHTML:YES ];
    [ picker setModalPresentationStyle:UIModalPresentationFormSheet ];
    [ picker setMailComposeDelegate:self ];
    
    [ self presentModalViewController:picker animated:YES ];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [ controller dismissModalViewControllerAnimated:YES ];
}

@end
