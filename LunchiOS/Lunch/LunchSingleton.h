//
//  LunchSingleton.h
//  Lunch
//
//  Created by Nathan Fraenkel on 10/1/15.
//  Copyright © 2015 Lunch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface LunchSingleton : NSObject

@property (nonatomic, strong) User *user;

+ (LunchSingleton *) sharedDataModel;

-(BOOL)isLoggedIn;


@end
