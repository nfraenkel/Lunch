//
//  ViewController.h
//  Lunch
//
//  Created by Nathan Fraenkel on 10/1/15.
//  Copyright © 2015 Lunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LunchSingleton.h"
#import "User.h"
#import "Constants.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) LunchSingleton *singleton;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)logInButtonPressed:(id)sender;
@end

