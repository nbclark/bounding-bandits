//
//  BBResultsCell.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBResultsCell.h"

@implementation BBResultsCell

@synthesize moves1;
@synthesize moves2;
@synthesize time1;
@synthesize time2;
@synthesize round1;
@synthesize round2;

+(id)cell
{
    BBResultsCell* view = [[[ NSBundle mainBundle ] loadNibNamed:@"BBResultsCell" owner:nil options:nil ] objectAtIndex:0 ];
    view.frame = CGRectMake(0,0,540,120);
    
    return view;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSString*)formatTime:(float)totalSeconds
{
    int minutes = floor(totalSeconds / 60);
    int seconds = (int)floor(totalSeconds) % 60;
    int milliseconds = floor((seconds-(int)seconds) / 100);
    
    return [ NSString stringWithFormat:@"%02d:%02d.%02d", minutes, seconds, milliseconds ];
}

-(void)setValue:(CollabRound*)_round1 round2:(CollabRound*)_round2
{
    self.round1 = _round1;
    self.round2 = _round2;

    self.moves1.text = self.moves2.text = @"-";
    self.time1.text = self.time2.text = @"-";

    if (_round1)
    {
        self.moves1.text = [ NSString stringWithFormat:@"%d moves", _round1.moves ];
        self.time1.text = [ NSString stringWithFormat:@"%@s", [ self formatTime:_round1.duration ]];
    }
    if (_round2)
    {
        self.moves2.text = [ NSString stringWithFormat:@"%d moves", _round2.moves ];
        self.time2.text = [ NSString stringWithFormat:@"%@s", [ self formatTime:_round2.duration ]];
    }
}

@end
