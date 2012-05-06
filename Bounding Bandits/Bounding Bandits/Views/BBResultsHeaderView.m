//
//  BBResultsHeaderView.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBResultsHeaderView.h"
#import "UIImageView+DD.h"

@implementation BBResultsHeaderView

@synthesize profileImage1;
@synthesize profileImage2;
@synthesize score1;
@synthesize score2;
@synthesize game;

+(id)headerWithGame:(CollabGame*)game
{
    BBResultsHeaderView* view = [[[ NSBundle mainBundle ] loadNibNamed:@"BBResultsHeaderView" owner:nil options:nil ] objectAtIndex:0 ];
    view.game = game;
    view.frame = CGRectMake(0,0,540,120);
    
    NSMutableDictionary* scores = [ view.game scoresForUsers ];
    PFUser* user1 = [ view.game.users objectAtIndex:0 ];
    PFUser* user2 = [ view.game.users objectAtIndex:1 ];
    
    //[ view.profileImage1 loadImageWithURL:[ NSURL URLWithString:[ user1 objectForKey:@"profilePicture" ]] onComplete:nil ];
    //[ view.profileImage2 loadImageWithURL:[ NSURL URLWithString:[ user2 objectForKey:@"profilePicture" ]] onComplete:nil ];
    
    NSString* user1Id = user1.objectId;
    NSString* user2Id = user2.objectId;
    
    NSString* score1 = [ NSString stringWithFormat:@"%d", [[ scores objectForKey:user1Id] intValue ]];
    NSString* score2= [ NSString stringWithFormat:@"%d", [[ scores objectForKey:user2Id] intValue ]];
    view.score1.text = score1;
    view.score2.text = score2;
    
    view.backgroundColor = [ UIColor colorWithRed:0.173 green:0.18 blue:0.196 alpha:1 ];
    
    return view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
