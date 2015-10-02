//
//  Venue.m
//  Lunch
//
//  Created by Nathan Fraenkel on 10/1/15.
//  Copyright © 2015 Lunch. All rights reserved.
//

#import "Venue.h"

@implementation Venue

@synthesize _id, name, type, location, photoUrl;

-(id)initWithId:(NSString*)newId
        andName:(NSString*)newName
        andType:(NSString*)newType
    andDistance:(NSString*)newDistance
    andLocation:(NSString*)newLocation
    andPhotoUrl:(NSString*)newPhotoUrl {
    
    self = [super init];
    if (self) {
        self._id = newId;
        self.name = newName;
        self.type = newType;
        self.distance = newDistance;
        self.location = newLocation;
        self.photoUrl = newPhotoUrl;
    }
    return self;
}

@end
