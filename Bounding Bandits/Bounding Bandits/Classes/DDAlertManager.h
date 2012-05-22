//
//  DDAlertManager.h
//  Bounding Bandits
//
//  Created by Nicholas Clark on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DDAlertClosedBlock)(int buttonIndex) ;

@interface DDAlertManager : NSObject

+(void)alertWithTitle:(NSString *)title message:(NSString *)message closeBlock:(DDAlertClosedBlock)closeBlock cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
