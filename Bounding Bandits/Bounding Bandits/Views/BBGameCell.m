//
//  BBGameCell.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 5/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBGameCell.h"
#import "UIImageView+DD.h"

@interface BBGameCell()

@property (nonatomic, strong) CollabGame* currentGame;
@property (nonatomic, strong) UIImageView* profileImage;
@property (nonatomic, strong) UILabel* profileLabel;
@property (nonatomic, strong) UILabel* yourScoreLabel;
@property (nonatomic, strong) UILabel* theirScoreLabel;
@property (nonatomic, strong) NSMutableArray* yourScoreDots;
@property (nonatomic, strong) NSMutableArray* theirScoreDots;
@property (nonatomic, strong) UIImageView* separator;
@property (nonatomic) BOOL isActive;
@property (nonatomic) BOOL isCompleted;

@end

@implementation BBGameCell

@synthesize currentGame;
@synthesize profileImage;
@synthesize profileLabel;
@synthesize yourScoreLabel;
@synthesize theirScoreLabel;
@synthesize yourScoreDots;
@synthesize theirScoreDots;
@synthesize separator;
@synthesize isActive;
@synthesize isCompleted;

+(id)cell
{
    return [[ BBGameCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BBGameCell" ];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.profileImage = [[ UIImageView alloc ] init ];
        self.profileLabel = [[ UILabel alloc ] init ];
        self.yourScoreLabel = [[ UILabel alloc ] init ];
        self.theirScoreLabel = [[ UILabel alloc ] init ];
        
        self.yourScoreDots = [ NSMutableArray array ];
        self.theirScoreDots = [ NSMutableArray array ];
        
        for (int row = 0; row < 2; ++row)
        {
            NSMutableArray* arr = (row == 0) ? self.yourScoreDots : self.theirScoreDots;
            
            for (int col = 0; col < 17; ++col)
            {
                UIImageView* image = [[ UIImageView alloc ] init ];
                image.contentMode = UIViewContentModeCenter;
                
                [ arr addObject:image ];
                [ self addSubview:image ];
            }
        }
        
        self.profileLabel.textColor = [ UIColor whiteColor ];
        self.profileLabel.backgroundColor = [ UIColor clearColor ];
        self.yourScoreLabel.font = self.theirScoreLabel.font = self.profileLabel.font = [ UIFont boldSystemFontOfSize:14 ];
        
        self.yourScoreLabel.textColor = [ UIColor colorWithRed:0.1835 green:0.6 blue:.0664 alpha:1 ];
        self.yourScoreLabel.backgroundColor = [ UIColor clearColor ];
        
        self.theirScoreLabel.textColor = [ UIColor colorWithRed:0.8 green:0.46 blue:0.09 alpha:1 ];
        self.theirScoreLabel.backgroundColor = [ UIColor clearColor ];
        
        [ self addSubview:self.profileImage ];
        [ self addSubview:self.profileLabel ];
        [ self addSubview:self.yourScoreLabel ];
        [ self addSubview:self.theirScoreLabel ];
        
        self.selectedBackgroundView = [[ UIView alloc ] init ];
        self.selectedBackgroundView.backgroundColor = [ UIColor colorWithWhite:0 alpha:1 ];
        
        self.backgroundView = [[ UIImageView alloc ] initWithImage:[ UIImage imageNamed:@"img/cell-gradient.png" ]];
        self.separator = [[ UIImageView alloc ] initWithImage:[ UIImage imageNamed:@"img/cell-border.png" ]];
        
        [ self addSubview:self.separator ];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [ super layoutSubviews ];
    
    float height = self.bounds.size.height;
    float width = self.bounds.size.width;
    
    self.profileImage.frame = CGRectMake(0,0,height,height);
    self.profileLabel.frame = CGRectMake(height+5,0,width/2-height-10, height);
    
    float yOff = 5;
    
    self.yourScoreLabel.frame = CGRectMake(width/2, yOff, 20, height / 2 - yOff);
    self.theirScoreLabel.frame = CGRectMake(width/2, height/2, 20, height / 2 - yOff);
    
    self.yourScoreLabel.center = CGPointMake(self.yourScoreLabel.center.x, height / 2 - 10);
    self.theirScoreLabel.center = CGPointMake(self.theirScoreLabel.center.x, height / 2 + 10);
    
    self.separator.frame = CGRectMake(0, height-2, width, 2);
    
    float y = 0;
    float startX = width / 2 + 20 + 5;
    float totalWidth = ( width - startX - 5 );
    float itemWidth = MIN(height/2,totalWidth / 17);
    float imageHeight = ((UIImageView*)[ self.yourScoreDots objectAtIndex:0 ]).image.size.height;
    float yPad = (height / 2 - imageHeight) / 2;
    
    for (int row = 0; row < 2; ++row)
    {
        float x = startX;
        NSMutableArray* arr = (row == 0) ? self.yourScoreDots : self.theirScoreDots;
        
        float yDiff = (row == 0) ? -10 : 10;
        
        for (int col = 0; col < 17; ++col)
        {
            UIImageView* image = [ arr objectAtIndex:col ];
            image.frame = CGRectMake(x,y+yDiff,itemWidth,height / 2 - yOff);
            image.center = CGPointMake(image.center.x, height / 2 + yDiff);
            
            x += itemWidth;
        }
        
        y += height / 2;
    }
}

-(void)setSelected:(BOOL)selected
{
    return;
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    self.backgroundView.hidden = !self.isActive || highlighted;
}

-(void)setValue:(CollabGame*)game asActive:(BOOL)asActive asCompleted:(BOOL)asCompleted
{
    self.backgroundView.hidden = !asActive;
    self.isActive = asActive;
    self.isCompleted = asCompleted;
    
    static NSArray* yourDots = nil;
    static NSArray* theirDots = nil;
    
    if (!yourDots)
    {
        yourDots = [ NSArray arrayWithObjects:[ UIImage imageNamed:@"img/dot-black.png" ], [ UIImage imageNamed:@"img/dot-green.png" ], nil];
        theirDots = [ NSArray arrayWithObjects:[ UIImage imageNamed:@"img/dot-black.png" ], [ UIImage imageNamed:@"img/dot-orange.png" ], nil];
    }
    
    PFUser* otherUser = [ game otherUser ];
    [ self.profileImage loadImageWithURL:[ NSURL URLWithString:[ otherUser objectForKey:@"profilePicture" ]] onComplete:nil ];
    self.profileLabel.text = [ otherUser objectForKey:@"name" ];
    
    self.yourScoreLabel.text = @"1";
    self.theirScoreLabel.text = @"10";
    
    int yourScore = 0;
    int theirScore = 0;
    
    for (int row = 0; row < 2; ++row)
    {
        NSMutableArray* arr = (row == 0) ? self.yourScoreDots : self.theirScoreDots;
        NSArray* dots = (row == 0) ? yourDots : theirDots;
        PFUser* user = (row == 0) ? [ PFUser currentUser ] : otherUser;
        
        for (int col = 0; col < 17; ++col)
        {
            BOOL didWin = [ game didUser:user winRound:col ];
            int index = didWin ? 1 : 0;
            
            UIImageView* image = [ arr objectAtIndex:col ];
            image.alpha = asCompleted ? 0.5 : 1;
            
            [ image setImage:[ dots objectAtIndex:index ]];
            
            if (row == 0 && didWin)
            {
                yourScore++;
            }
            else if (row == 1 && didWin)
            {
                theirScore++;
            }
        }
    }
    
    self.yourScoreLabel.text = [ NSString stringWithFormat:@"%d", yourScore ];
    self.theirScoreLabel.text = [ NSString stringWithFormat:@"%d", theirScore ];
}

@end
