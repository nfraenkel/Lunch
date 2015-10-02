//
//  JoinButton.h
//  Lunch
//
//  Created by Nathan Fraenkel on 10/1/15.
//  Copyright © 2015 Lunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venue.h"

@interface JoinButton : UIButton

@property (strong, nonatomic) Venue *venue;
@property (strong, nonatomic) NSArray *otherUsers;

@end
