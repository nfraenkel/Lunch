//
//  Choice.h
//  Lunch
//
//  Created by Nathan Fraenkel on 10/1/15.
//  Copyright © 2015 Lunch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Venue.h"

@interface Choice : NSObject

@property (strong, nonatomic) Venue *venue;
@property (strong, nonatomic) NSArray *users;

-(id)initWithDictionary:(NSDictionary *)dict;

@end
