//
//  FacebookFriend.h
//  Bounding Bandits
//
//  Created by Nicholas Clark on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Parse/Parse.h>

@interface FacebookFriend : NSObject

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* userId;
@property (nonatomic, copy) NSString* pictureUrl;
@property (nonatomic, copy) NSString* email;
@property (nonatomic, strong) PFUser* user;

-(id)initWithId:(NSString*)userId name:(NSString*)name;

@end
