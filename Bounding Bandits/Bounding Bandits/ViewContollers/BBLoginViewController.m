//
//  BBLoginViewController.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBLoginViewController.h"
#import "BBSignUpViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "JSONKit.h"

@interface BBLoginViewController ()<PF_FBRequestDelegate>
@end

@implementation BBLoginViewController

-(id)init
{
    if ((self = [ super init ]))
    {
        //self.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton | PFLogInFieldsPasswordForgotten | PFLogInFieldsFacebook | PFLogInFieldsTwitter;
        self.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton | PFLogInFieldsPasswordForgotten | PFLogInFieldsFacebook | PFLogInFieldsTwitter;
        
        self.delegate = self;
    }
    
    return self;
}

-(void)signUpTapped:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromLeft;
    transition.delegate = self;
    
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [ self.navigationController pushViewController:self.signUpController animated:NO ];
}

-(void)viewDidLoad
{
    [ super viewDidLoad ];
    
    self.view.backgroundColor = [ UIColor clearColor ];
    self.logInView.usernameField.backgroundColor = [ UIColor colorWithWhite:1 alpha:0.2 ];
    self.logInView.passwordField.backgroundColor = [ UIColor colorWithWhite:1 alpha:0.2 ];
    
    self.logInView.usernameField.textColor = [ UIColor blackColor ];
    self.logInView.passwordField.textColor = [ UIColor blackColor ];
    
    self.logInView.usernameField.placeholder = @"username";
    self.signUpController = [[ BBSignUpViewController alloc ] init ];
    
    [ self.logInView.signUpButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents ];
    [ self.logInView.signUpButton addTarget:self action:@selector(signUpTapped:) forControlEvents:UIControlEventTouchUpInside ];
    //self.signUpController.modalPresentationStyle = UIModalPresentationFormSheet;
    //self.signUpController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    UIImage* img = [ UIImage imageNamed:@"img/bg-login.png" ];
    UIImage* logo = [ UIImage imageNamed:@"img/logo-login.png" ];
    
    UIImageView* imageView = [[ UIImageView alloc ] initWithImage:img];
    imageView.frame = CGRectMake(0,self.view.bounds.size.height - img.size.height,img.size.width, img.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    UIImageView* logoView = [[ UIImageView alloc ] initWithImage:logo];
    logoView.frame = CGRectMake(0,0,logo.size.width, logo.size.height + 30);
    logoView.contentMode = UIViewContentModeTop;
    
    self.logInView.logo = logoView;
    
    [ self.view insertSubview:imageView atIndex:0 ];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

/*! @name Responding to Actions */
/// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    PFUser* currentUser = [PFUser currentUser];
    
    if (![[ currentUser objectForKey:@"premium" ] boolValue ])
    {
        [currentUser setObject:[ NSNumber numberWithBool:NO ] forKey:@"premium"];
    }
    
    [currentUser setObject:[ NSNumber numberWithBool:YES ] forKey:@"receiveNotifications"];
    
    if ([ PFFacebookUtils isLinkedWithUser:user ])
    {
        NSString *requestPath = @"me/?fields=name,location,gender,birthday,relationship_status,picture,email";
        
        // Send request to facebook
        [[PFFacebookUtils facebook] requestWithGraphPath:requestPath andDelegate:self];
    }
    else if ([ PFTwitterUtils isLinkedWithUser:user ])
    {
        // Send request to facebook
        NSMutableURLRequest* request = [ NSMutableURLRequest requestWithURL:[ NSURL URLWithString:@"https://api.twitter.com/1/account/verify_credentials.json" ]];
        [[ PFTwitterUtils twitter ] signRequest:request ];
        
        [ NSURLConnection sendAsynchronousRequest:request queue:[ NSOperationQueue currentQueue ] completionHandler:^(NSURLResponse * response, NSData * data, NSError * err) {
            
            NSString* json = [[ NSString alloc ] initWithData:data encoding:NSUTF8StringEncoding ];
            
            NSDictionary* userData = [ json objectFromJSONString ];
            
            NSString *name = [userData objectForKey:@"name"];
            NSString *description = [userData objectForKey:@"description"];
            NSString *location = [userData objectForKey:@"location"];
            NSString *twitterId = [userData objectForKey:@"id"];
            //NSString *picture = [userData objectForKey:@"picture"];
            NSString *picture = [ userData objectForKey:@"profile_image_url" ];
            NSString* screenName = [ userData objectForKey:@"screen_name" ];
            
            /*picture = [ NSString stringWithFormat:@"https://api.twitter.com/1/users/profile_image?screen_name=%@&size=original",  screenName ];*/
            
            PFUser* currentUser = [PFUser currentUser];
            
            [currentUser setObject:name forKey:@"name"];
            [currentUser setObject:location forKey:@"location"];
            [currentUser setObject:twitterId forKey:@"twitterId"];
            [currentUser setObject:screenName forKey:@"twitterSN"];
            [currentUser setObject:picture forKey:@"profilePicture"];
            [currentUser saveInBackground];
            
            [ self performSelectorOnMainThread:@selector(dismiss) withObject:nil waitUntilDone:NO ];
        }];
    }
}

-(void)dismiss
{
    [[ NSNotificationCenter defaultCenter ] postNotificationName:@"kUserDidLogIn" object:nil ];
    
    [ self.navigationController.view removeFromSuperview ];
    [ self.navigationController removeFromParentViewController ];
}

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
    [currentUser setObject:[ userData objectForKey:@"id" ] forKey:@"facebookId"];
    [currentUser saveInBackground];
    
    [ self performSelectorOnMainThread:@selector(dismiss) withObject:nil waitUntilDone:NO ];
}

@end
