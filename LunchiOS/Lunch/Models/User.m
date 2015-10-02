//
//  User.m
//  Lunch
//
//  Created by Nathan Fraenkel on 10/1/15.
//  Copyright © 2015 Lunch. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize first, last, email, photoUrl;

-(id)initWithFirst:(NSString *)newFirst
           andLast:(NSString *)newLast
          andEmail:(NSString *)newEmail
          andPhoto:(NSString *)newPhoto
{
    self = [super init];
    if (self) {
        self.first = newFirst;
        self.last = newLast;
        self.email = newEmail;
        self.photoUrl = newPhoto;
    }
    return self;
}

@end
