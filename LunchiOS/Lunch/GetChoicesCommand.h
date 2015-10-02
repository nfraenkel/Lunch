//
//  GetChoicesCommand.h
//  Lunch
//
//  Created by Nathan Fraenkel on 10/1/15.
//  Copyright © 2015 Lunch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Choice.h"
#import "Constants.h"

@protocol GetChoicesDelegate <NSObject>
-(void)reactToGetChoicesResponse:(NSMutableArray*)array;
-(void)reactToGetChoicesError:(NSError*)error;
@end

@interface GetChoicesCommand : NSObject <NSURLConnectionDataDelegate> {
    NSArray *collectionsFromResponse;
    NSMutableData *_data;
}

@property (nonatomic, readwrite) BOOL userIsLoggedIn;
@property (nonatomic, strong) id<GetChoicesDelegate> delegate;

-(void)fetchChoices;

@end
