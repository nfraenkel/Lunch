//
//  Venue.h
//  Lunch
//
//  Created by Nathan Fraenkel on 10/1/15.
//  Copyright © 2015 Lunch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Venue : NSObject

@property (strong, nonatomic) NSString *_id, *name, *type, *distance, *location, *photoUrl;

-(id)initWithId:(NSString*)newId
        andName:(NSString*)newName
        andType:(NSString*)newType
    andDistance:(NSString*)newDistance
    andLocation:(NSString*)newLocation
    andPhotoUrl:(NSString*)newPhotoUrl;

@end
