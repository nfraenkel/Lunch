//
//  User.m
//  Lunch
//
//  Created by Nathan Fraenkel on 10/1/15.
//  Copyright © 2015 Lunch. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize first, last, email;

-(id)initWithFirst:(NSString *)newFirst andLast:(NSString *)newLast andEmail:(NSString *)newEmail {
    self = [super init];
    if (self) {
        self.first = newFirst;
        self.last = newLast;
        self.email = newEmail;
    }
    return self;
}

@end
