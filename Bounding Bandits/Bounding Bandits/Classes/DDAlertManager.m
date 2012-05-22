//
//  DDAlertManager.m
//  Bounding Bandits
//
//  Created by Nicholas Clark on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DDAlertManager.h"

@interface DDAlertManager()<UIAlertViewDelegate>

@property (nonatomic, strong) DDAlertClosedBlock closedBlock;

@end

@implementation DDAlertManager

@synthesize closedBlock;

+(void)alertWithTitle:(NSString *)title message:(NSString *)message closeBlock:(DDAlertClosedBlock)closeBlock cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    static DDAlertManager* manager = nil;

    if (!manager) manager = [[ DDAlertManager alloc ] init ];

    manager.closedBlock = closeBlock;

    UIAlertView* view = [[ UIAlertView alloc ] initWithTitle:title message:message delegate:manager cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil ];

    [ view performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO ];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.closedBlock(buttonIndex);
}


- (void)willPresentAlertView:(UIAlertView *)alertView  // before animation and showing view
{
    //
}
- (void)didPresentAlertView:(UIAlertView *)alertView  // after animation
{
    //
}

-(void)dealloc
{
    sleep(9);
}

@end
