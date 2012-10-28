//
//  BBFirstRunViewController.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 10/27/12.
//
//

#import "BBFirstRunViewController.h"

@interface BBFirstRunViewController ()

@property (nonatomic, assign) IBOutlet UIScrollView* scrollView;

@end

@implementation BBFirstRunViewController

@synthesize scrollView;
@synthesize delegate;

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
    // Do any additional setup after loading the view from its nib.
    
    int x = 0;
    for (int i = 1; i <= 7; ++i)
    {
        UIImageView* iv = [[ UIImageView alloc ] initWithFrame:CGRectMake(x, 0, 512, 384)];
        x+=512;
        NSString* img = [ NSString stringWithFormat:@"img/wt%d.jpg", i ];
        iv.image = [ UIImage imageNamed:[ NSString stringWithFormat:@"img/wt%d.jpg", i ]];
        
        [ self.scrollView addSubview:iv ];
    }
    
    self.scrollView.contentSize = CGSizeMake(x, 384);
}

-(IBAction)dismissTapped:(id)sender
{
    [ self dismissModalViewControllerAnimated:YES ];
    
    if (self.delegate)
    {
        self.delegate();
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
