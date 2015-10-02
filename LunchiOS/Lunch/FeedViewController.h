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
#import "GetHistoryCommand.h"
#import "JoinChoiceCommand.h"
#import "DeleteJoinCommand.h"
#import "JoinButton.h"
#import "Choice.h"
#import "User.h"
#import "Constants.h"

@interface FeedViewController : UIViewController <UIScrollViewDelegate, GetChoicesDelegate, GetHistoryDelegate, JoinChoiceDelegate, DeleteJoinDelegate, UITableViewDataSource, UITableViewDelegate> {
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

@property (strong, nonatomic) NSMutableArray *choices, *history;

@end
