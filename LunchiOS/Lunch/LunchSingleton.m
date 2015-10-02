//
//  LunchSingleton.m
//  Lunch
//
//  Created by Nathan Fraenkel on 10/1/15.
//  Copyright © 2015 Lunch. All rights reserved.
//

#import "LunchSingleton.h"

@implementation LunchSingleton

@synthesize user, otherUsers, currentVenue;

static LunchSingleton *sharedDataModel = nil;

+ (LunchSingleton *) sharedDataModel {
    @synchronized(self){
        if (sharedDataModel == nil){
            sharedDataModel = [[LunchSingleton alloc] init];
        }
    }
    return sharedDataModel;
}

-(BOOL)isLoggedIn {
    return self.user;
}

@end
