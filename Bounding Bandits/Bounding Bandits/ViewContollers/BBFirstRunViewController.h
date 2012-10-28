//
//  BBFirstRunViewController.h
//  Bounding Bandits
//
//  Created by Nicholas Clark on 10/27/12.
//
//

#import <UIKit/UIKit.h>

typedef void (^VoidBlock)() ;

@interface BBFirstRunViewController : UIViewController

@property (nonatomic, strong) VoidBlock delegate;

@end
