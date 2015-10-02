//
//  Choice.m
//  Lunch
//
//  Created by Nathan Fraenkel on 10/1/15.
//  Copyright © 2015 Lunch. All rights reserved.
//

#import "Choice.h"

@implementation Choice

@synthesize venue, users;

-(id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        NSString *_id = [dict objectForKey:@"id"];
        NSString *name = [dict objectForKey:@"name"];
        NSString *location = [dict objectForKey:@"location"];
        NSString *distance = [dict objectForKey:@"distance"];
        NSString *type = [dict objectForKey:@"type"];
        NSString *photoUrl = [dict objectForKey:@"photo"];
        NSArray *us = [dict objectForKey:@"users"];
        
        self.venue = [[Venue alloc] initWithId:_id
                                       andName:name
                                       andType:type
                                   andDistance:distance
                                   andLocation:location
                                   andPhotoUrl:photoUrl];
        self.users = us;
        
    }
    return self;
}

@end
