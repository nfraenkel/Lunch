//
//  FeedViewController.h
//  Lunch
//
//  Created by Nathan Fraenkel on 10/1/15.
//  Copyright © 2015 Lunch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LunchSingleton.h"
#import "GetChoicesCommand.h"
#import "JoinButton.h"
#import "Choice.h"
#import "User.h"
#import "Constants.h"

@interface FeedViewController : UIViewController <UIScrollViewDelegate, GetChoicesDelegate> {
    UIScrollView *sv;
    UITableView *tv;
    UIView *cv;
    
    NSInteger totalSize;
    CGRect screenRect;
    CGFloat screenWidth, screenHeight;
    
    BOOL confirmationScreen;
}

@property (strong, nonatomic) LunchSingleton *singleton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (strong, nonatomic) NSMutableArray *choices;

@end
