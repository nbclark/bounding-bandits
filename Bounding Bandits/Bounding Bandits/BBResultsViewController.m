//
//  BBResultsViewController.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBResultsViewController.h"
#import "BBResultsHeaderView.h"
#import "BBResultsCell.h"
#import "UIResponder+ActionPerforming.h"

@interface BBResultsViewController ()

@property (nonatomic, strong) UIButton* getStartedButton;

@end

@implementation BBResultsViewController

@synthesize game;
@synthesize getStartedButton;
@synthesize delegate;
@synthesize showStart;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dismiss
{
    if (self.delegate)
    {
        [ self.delegate dismissPopover ];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.getStartedButton = [ UIButton buttonWithType:UIButtonTypeCustom ];
    self.getStartedButton.titleLabel.font = [ UIFont boldSystemFontOfSize:24 ];
    
    [ self.getStartedButton setTitle:@"Start the Round!" forState:UIControlStateNormal ];
    [ self.getStartedButton setBackgroundImage:[ UIImage imageNamed:@"img/btn-newgame.png" ] forState:UIControlStateNormal ];
    
    BBResultsHeaderView* header = [ BBResultsHeaderView headerWithGame:self.game ];
    
    float height = self.showStart ? 66 : 0;
    
    self.tableView.frame = CGRectMake(0, header.bounds.size.height, self.view.frame.size.width, self.view.frame.size.height-header.bounds.size.height);
    header.frame = CGRectMake(0, height, self.view.bounds.size.width, header.bounds.size.height );
    header.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UIView* headerCont = [[ UIView alloc ] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, header.bounds.size.height + height)];
    
    [ headerCont addSubview:self.getStartedButton ];
    [ headerCont addSubview:header ];
    
    self.tableView.tableHeaderView = headerCont;
    self.getStartedButton.frame = CGRectMake(0, 0, headerCont.bounds.size.width, 66);
    self.getStartedButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [ self.getStartedButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside ];
    
    self.getStartedButton.hidden = !self.showStart;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.getStartedButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated ];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return ceil([ self.game.rounds count ] / 2.0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    BBResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [ BBResultsCell cell ];
    }
    
    int index = indexPath.row * 2;
    
    [ cell setValue:indexPath.row round1:[ CollabRound objectWithObject:[ self.game.rounds objectAtIndex:index ]] round2:[ CollabRound objectWithObject:([ self.game.rounds count ] > index + 1) ? [ self.game.rounds objectAtIndex:index + 1 ] : nil ]];
    
    return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selRow = [ tableView indexPathForSelectedRow ];

    return (selRow && selRow.row == indexPath.row) ? (70 + self.view.bounds.size.width) : 70;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBResultsCell* cell = (BBResultsCell*)[ tableView cellForRowAtIndexPath:indexPath ];
    cell.replayVisible = NO;
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBResultsCell* cell = (BBResultsCell*)[ tableView cellForRowAtIndexPath:indexPath ];
    
    [tableView beginUpdates];
    
    cell.replayVisible = !cell.replayVisible;
    
    if (!cell.replayVisible)
    {
        [ tableView deselectRowAtIndexPath:indexPath animated:NO ];
    }
    
    [tableView endUpdates];
    
    if (!cell.replayVisible)
    {
        [ tableView deselectRowAtIndexPath:indexPath animated:NO ];
    }
    else
    {
        [ tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES ];
    }
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
