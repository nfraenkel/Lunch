//
//  GetLoginCommand.h
//  Lunch
//
//  Created by Nathan Fraenkel on 10/1/15.
//  Copyright © 2015 Lunch. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GetLoginDelegate <NSObject>
-(void)reactToLoginResponse:(NSArray*)array;
-(void)reactToLoginError:(NSError*)error;
@end


@interface GetLoginCommand : NSObject {
    NSMutableData *_data;
}

@property (nonatomic, strong) id<GetLoginDelegate> delegate;
-(void)login;

@end
