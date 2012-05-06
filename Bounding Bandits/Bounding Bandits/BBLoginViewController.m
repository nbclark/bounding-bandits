//
//  BBLoginViewController.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 3/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBLoginViewController.h"
#import <Parse/Parse.h>

@implementation BBLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Select your game...";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark actions

-(void)request:(PF_FBRequest *)request didLoad:(id)result {
    NSDictionary *userData = (NSDictionary *)result; // The result is a dictionary
    
    NSString *name = [userData objectForKey:@"name"];
    NSString *location = [[userData objectForKey:@"location"] objectForKey:@"name"];
    NSString *gender = [userData objectForKey:@"gender"];
    NSString *birthday = [userData objectForKey:@"birthday"];
    NSString *email = [userData objectForKey:@"email"];
    //NSString *picture = [userData objectForKey:@"picture"];
    NSString *picture = [ NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", [ userData objectForKey:@"id" ]];
    
    PFUser* currentUser = [PFUser currentUser];
    
    currentUser.email = email;
    [currentUser setObject:name forKey:@"name"];
    [currentUser setObject:location forKey:@"location"];
    [currentUser setObject:gender forKey:@"gender"];
    [currentUser setObject:birthday forKey:@"birthday"];
    [currentUser setObject:picture forKey:@"profilePicture"];
    [currentUser saveInBackground];
    
    [[ NSNotificationCenter defaultCenter ] postNotificationName:@"kUserDidLogIn" object:nil ];

    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)loginFacebookClicked:(id)sender
{
    [PFFacebookUtils logInWithPermissions:[NSArray arrayWithObjects:@"email,user_birthday", nil] block:^(PFUser *user, NSError *error)
     {         
         if (!user)
         {
             NSLog(@"Uh oh. The user cancelled the Facebook login.");
             return;
         }
         else if (user.isNew)
         {
             NSLog(@"User signed up and logged in through Facebook!");
         }
         else
         {
             NSLog(@"User logged in through Facebook!");
         }
         
         NSString *requestPath = @"me/?fields=name,location,gender,birthday,relationship_status,picture,email";
         
         // Send request to facebook
         [[PFFacebookUtils facebook] requestWithGraphPath:requestPath andDelegate:self];
     }];
}

@end
