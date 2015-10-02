//
//  ViewController.h
//  Lunch
//
//  Created by Nathan Fraenkel on 10/1/15.
//  Copyright © 2015 Lunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LunchSingleton.h"
#import "GetLoginCommand.h"
#import "Constants.h"

@interface ViewController : UIViewController <GetLoginDelegate>

@property (strong, nonatomic) LunchSingleton *singleton;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *letsGoButton;

- (IBAction)logInButtonPressed:(id)sender;
@end
