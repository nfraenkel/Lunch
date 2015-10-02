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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logInButtonPressed:(id)sender {
    NSString *email = [emailTextField text];

    // TODO - query DB to see if email in list of emails from DB
    User *newUser = [[User alloc] initWithFirst:@"Nathan" andLast:@"Fraenkel" andEmail:@"nathan.fraenkel@newscred.com"];
    
    self.singleton.user = newUser;
    
    [self performSegueWithIdentifier:@"showMainFeed" sender:self];
}
@end
