//
//  ViewController.m
//  Lunch
//
//  Created by Nathan Fraenkel on 10/1/15.
//  Copyright © 2015 Lunch. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize singleton, emailTextField, passwordTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.singleton = [LunchSingleton sharedDataModel];
    
    self.emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    self.letsGoButton.layer.cornerRadius = 5;
    self.letsGoButton.layer.masksToBounds = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logInButtonPressed:(id)sender {
    NSString *email = [emailTextField text];

    // TODO - query DB to see if email in list of emails from DB
    GetLoginCommand *cmd = [[GetLoginCommand alloc] initWithEmail:email];
    cmd.delegate = self;
    [cmd login];
}

-(void)reactToLoginError:(NSError *)error {
    NSLog(@"ERRROORRRRRRR: %@", error);
}

-(void)reactToLoginResponse:(User *)newUser {
    self.singleton.user = newUser;

    [self performSegueWithIdentifier:@"showMainFeed" sender:self];
}

@end
