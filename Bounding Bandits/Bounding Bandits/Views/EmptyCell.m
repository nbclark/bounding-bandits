//
//  EmptyCell.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 8/10/12.
//
//

#import "EmptyCell.h"

@implementation EmptyCell

@synthesize emptyLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.emptyLabel = [[ UILabel alloc ] initWithFrame:CGRectInset(self.bounds, 15 ,5) ];
        self.emptyLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.emptyLabel.backgroundColor = [ UIColor clearColor ];
        self.emptyLabel.textColor = [ UIColor whiteColor ];
        self.emptyLabel.font = [ UIFont boldSystemFontOfSize:17 ];
        
        [[ self contentView ] addSubview:self.emptyLabel ];
        
        self.backgroundColor = self.contentView.backgroundColor = [ UIColor clearColor ];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
