//
//  GetLoginCommand.h
//  Lunch
//
//  Created by Nathan Fraenkel on 10/1/15.
//  Copyright © 2015 Lunch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "User.h"
#import "Constants.h"

@protocol GetLoginDelegate <NSObject>
-(void)reactToLoginResponse:(User*)newUser;
-(void)reactToLoginError:(NSError*)error;
@end


@interface GetLoginCommand : NSObject {
    NSMutableData *_data;
}

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) id<GetLoginDelegate> delegate;

-(id)initWithEmail:(NSString*)newEmail;
-(void)login;

@end
