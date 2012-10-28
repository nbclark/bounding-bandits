//
//  BBResultsCell.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BBResultsCell.h"
#import "UIWebView+Stylizer.h"

@interface BBResultsCell()<UIWebViewDelegate>

@property (nonatomic) BOOL isLoaded;
@property (nonatomic) BOOL showOnLoad;

@end

@implementation BBResultsCell

@synthesize moves1;
@synthesize moves2;
@synthesize roundLabel;
@synthesize replayView;
@synthesize round1;
@synthesize round2;
@synthesize replayVisible = _replayVisible;
@synthesize user1Active;
@synthesize isLoaded;
@synthesize showOnLoad;
@synthesize delegate;

+(id)cell
{
    BBResultsCell* view = [[[ NSBundle mainBundle ] loadNibNamed:@"BBResultsCell" owner:nil options:nil ] objectAtIndex:0 ];
    [ view initialize ];
    
    view.frame = CGRectMake(0,0,540,120);
    view.replayVisible = NO;
    view.selectionStyle = UITableViewCellSelectionStyleNone;
    view.user1Active = YES;
    
    return view;
}

-(void)initialize
{
    self.replayView.delegate = self;
    self.replayView.scrollView.scrollEnabled = NO;
    
    [ self.replayView stylize:NO ];
    
    NSString *urlAddress = [[NSBundle mainBundle] pathForResource:@"bb" ofType:@"html"];
    
    NSURL *url = [NSURL fileURLWithPath:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [self.replayView loadRequest:requestObj];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [ super layoutSubviews ];
    
    self.replayView.frame = CGRectMake(0,71,self.bounds.size.width + 245,self.bounds.size.width + 70 - 70);
}

-(BOOL)replayVisible
{
    return _replayVisible;
}

-(IBAction)replayClicked:(id)sender
{
    self.user1Active = sender == self.moves1;
    
    if (self.replayVisible)
    {
        [ self setReplayVisible:YES ];
    }
    else
    {
        if (self.delegate)
        {
            [ self.delegate selectCell:self ];
        }
    }
}

-(void)setReplayVisible:(BOOL)replayVisible
{
    _replayVisible = replayVisible;
    self.replayView.hidden = !replayVisible;
    
    [ self.replayView removeFromSuperview ];
    
    self.moves1.backgroundColor = self.moves2.backgroundColor = [ UIColor clearColor ];
    [ self.moves1 setTitleColor:[ UIColor blackColor ] forState:UIControlStateNormal ];
    [ self.moves1 setTitleColor:[ UIColor blackColor ] forState:UIControlStateSelected ];
    [ self.moves2 setTitleColor:[ UIColor blackColor ] forState:UIControlStateNormal ];
    [ self.moves2 setTitleColor:[ UIColor blackColor ] forState:UIControlStateSelected ];
    
    if (replayVisible)
    {
        if (self.isLoaded)
        {
            [ self addSubview:self.replayView ];
        
            CollabRound* round = (self.user1Active) ? self.round1 : self.round2;
            
            [ self.replayView stringByEvaluatingJavaScriptFromString:[ NSString stringWithFormat:@"loadGame(%d, %@, %@, %@, %f); board.replay(%@);", 2, @"false", round.state, @"false", 0.0, round.moveLog, nil ] ];
            
            if (self.user1Active)
            {
                self.moves1.backgroundColor = [ UIColor blackColor ];
                [ self.moves1 setTitleColor:[ UIColor whiteColor ] forState:UIControlStateNormal ];
                [ self.moves1 setTitleColor:[ UIColor whiteColor ] forState:UIControlStateSelected ];
            }
            else
            {
                [ self.moves2 setTitleColor:[ UIColor whiteColor ] forState:UIControlStateNormal ];
                [ self.moves2 setTitleColor:[ UIColor whiteColor ] forState:UIControlStateSelected ];
                self.moves2.backgroundColor = [ UIColor blackColor ];
            }
        }
        else
        {
            self.showOnLoad = YES;
        }
    }
    else {
    }
}

-(NSString*)formatTime:(float)totalSeconds
{
    int minutes = floor(totalSeconds / 60);
    int seconds = (int)floor(totalSeconds) % 60;
    int milliseconds = floor((seconds-(int)seconds) / 100);
    
    return [ NSString stringWithFormat:@"%02d:%02d.%02d", minutes, seconds, milliseconds ];
}

-(void)setValue:(NSUInteger)roundNumber round1:(CollabRound*)_round1 round2:(CollabRound*)_round2
{
    self.roundLabel.text = [ NSString stringWithFormat:@"Round %d", roundNumber+1 ];
    self.round1 = _round1;
    self.round2 = _round2;
    
    [ self.moves1 setTitle:@"-" forState:UIControlStateNormal ];
    [ self.moves2 setTitle:@"-" forState:UIControlStateNormal ];
    //self.time1.text = self.time2.text = @"-";

    if ([_round1 completed])
    {
        if ([_round2 completed])
        {
            [ self.moves1 setTitle:[ NSString stringWithFormat:@"%d", _round1.moves ] forState:UIControlStateNormal ];
        }
        else
        {
            [ self.moves2 setTitle:@"?" forState:UIControlStateNormal ];
        }
        //self.time1.text = [ NSString stringWithFormat:@"%@s", [ self formatTime:_round1.duration ]];
    }
    if ([_round2 completed])
    {
        [ self.moves2 setTitle:[ NSString stringWithFormat:@"%d", _round2.moves ] forState:UIControlStateNormal ];
        //self.time2.text = [ NSString stringWithFormat:@"%@s", [ self formatTime:_round2.duration ]];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.isLoaded = YES;
    
    if (self.showOnLoad)
    {
        [ self setReplayVisible:YES ];
    }
    
    self.showOnLoad = NO;
}

@end
