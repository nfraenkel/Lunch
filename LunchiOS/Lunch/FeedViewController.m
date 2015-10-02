//
//  FeedViewController.m
//  Lunch
//
//  Created by Nathan Fraenkel on 10/1/15.
//  Copyright © 2015 Lunch. All rights reserved.
//

#import "FeedViewController.h"

@interface FeedViewController ()

@end

@implementation FeedViewController

@synthesize singleton, segmentedControl, choices;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self fetchChoicesForToday];
    
    self.singleton = [LunchSingleton sharedDataModel];
    
    // SEGMENTED CONTROL
    [self.segmentedControl addTarget:self
                              action:@selector(segmentSwitch:)
                    forControlEvents:UIControlEventValueChanged];
    
    // SCREEN SIZE
    NSInteger totalSize = 0;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CGRect bigViewFrame = CGRectMake(0, 25 + segmentedControl.frame.size.height, screenWidth, screenHeight - segmentedControl.frame.size.height - 25);
    sv = [[UIScrollView alloc] initWithFrame:bigViewFrame];
    sv.delegate = self;
    [self.view addSubview:sv];
    
    // greeting label
    CGRect greetingLabelFrame = CGRectMake(0, 160, screenWidth, 30);
    UILabel *greetingLabel = [[UILabel alloc] initWithFrame:greetingLabelFrame];
    [greetingLabel setText:[NSString stringWithFormat:@"Hungry %@?", self.singleton.user.first]];
    greetingLabel.textAlignment = NSTextAlignmentCenter;
    
    CGRect dateLabelFrame = CGRectMake(0, 220, screenWidth, 30);
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:dateLabelFrame];
    [dateLabel setText:[NSString stringWithFormat:@"Thursday, October 1"]];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    
    CGRect promptLabelFrame = CGRectMake(80, 280, screenWidth - 160, 50);
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:promptLabelFrame];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.numberOfLines = 2;
    [promptLabel setText:[NSString stringWithFormat:@"See where your coworkers are going for lunch"]];
    
    [sv addSubview:greetingLabel];
    [sv addSubview:dateLabel];
    [sv addSubview:promptLabel];
    
    totalSize = promptLabel.frame.origin.y + promptLabel.frame.size.height + 20;
    sv.contentSize = CGSizeMake(screenWidth, totalSize);
    
    self.choices = [NSMutableArray arrayWithObjects:@"Dos Toros", @"Spreads", @"Dig Inn", @"SweetGreen", @"Fresh & Co", @"Essen", nil];
    
    for (int i = 0; i < [self.choices count]; i++) {
        NSString *choice = [self.choices objectAtIndex:i];
        
        NSInteger rowHeight = 120;
        CGRect rowViewFrame = CGRectMake(20, totalSize + 20, screenWidth - 40, rowHeight);
        totalSize += rowHeight;
        
        UIView *rowView = [[UIView alloc] initWithFrame:rowViewFrame];
        rowView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        rowView.layer.borderWidth = 1.0f;
        rowView.layer.cornerRadius = 5;
        rowView.layer.masksToBounds = YES;
        
        NSInteger height1 = 10;
        
        UIImage *image = [self imageFromURLString:@"http://static1.squarespace.com/static/522a1382e4b0b4c6531b9166/55f3c8abe4b044a1a33db975/55f3c967e4b044a1a33dbabc/1442040168004/U1_logo_DosToros.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, height1, 40, 40)];
        [imageView setImage:image];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, height1, screenWidth - 50, 20)];
        [nameLabel setText:choice];
        
        UILabel *subHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, height1 + 20, screenWidth - 50, 20)];
        NSString *category = @"Mexican";
        NSString *distance = @"2.9 miles away";
        [subHeaderLabel setText:[NSString stringWithFormat:@"%@ -- %@", category, distance]];
        
        UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(5, rowHeight / 2, rowViewFrame.size.width - 10, 1)];
        [seperator setBackgroundColor:[UIColor lightGrayColor]];
        
        CGRect buttonFrame = CGRectMake(rowViewFrame.size.width - 60, 75, 40, 30);
        JoinButton *joinButton = [[JoinButton alloc] initWithFrame:buttonFrame];
        joinButton.venue = NULL;
        joinButton.otherUsers = NULL;
        [joinButton setTitle:@"Join" forState:UIControlStateNormal];
        [joinButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [joinButton.titleLabel setFont:[joinButton.titleLabel.font fontWithSize: 10.0f]];
        joinButton.layer.borderColor = [UIColor orangeColor].CGColor;
        joinButton.layer.borderWidth = 1.0f;
        joinButton.layer.cornerRadius = 5;
        joinButton.layer.masksToBounds = YES;
        [joinButton addTarget:self
                   action:@selector(joinLunch:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [rowView addSubview:imageView];
        [rowView addSubview:nameLabel];
        [rowView addSubview:subHeaderLabel];
        [rowView addSubview:seperator];
        [rowView addSubview:joinButton];
        
        [sv addSubview:rowView];
        
        totalSize += 30;
        sv.contentSize = CGSizeMake(screenWidth, totalSize);
    }
    
    
    // TABLE VIEW
    tv = [[UITableView alloc] initWithFrame:bigViewFrame];
    [tv setBackgroundColor:[UIColor blueColor]];
    tv.hidden = YES;
    
    // CONFIRMATION VIEW
    cv = [[UIView alloc] initWithFrame:bigViewFrame];
    cv.backgroundColor = [UIColor redColor];
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, screenHeight - 30, screenWidth, 30)];
    [cancelButton setTitle:@"go somewhere else?" forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor orangeColor]];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self
                     action:@selector(cancelLunch:)
           forControlEvents:UIControlEventTouchUpInside];
    [cv addSubview:cancelButton];
    cv.hidden = YES;
    
    [self.view addSubview:tv];
    [self.view addSubview:cv];

}

-(void)fetchChoicesForToday {
        GetChoicesCommand *cmd = [[GetChoicesCommand alloc] init];
        [cmd fetchChoices];
}


- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *sc = (UISegmentedControl *) sender;
    NSInteger selectedSegment = sc.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        //toggle the correct view to be visible
        [sv setHidden:NO];
        [tv setHidden:YES];
    }
    else{
        //toggle the correct view to be visible
        [sv setHidden:YES];
        [tv setHidden:NO];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)joinLunch:(UIButton *)sender {
    NSLog(@"sender: %@", sender);
//    [self performSegueWithIdentifier:@"showConfirmation" sender:self];
    [sv setHidden:YES];
    [cv setHidden:NO];
}

-(void)cancelLunch:(UIButton *)sender {
    NSLog(@"CANCELLING");
    [sv setHidden:NO];
    [cv setHidden:YES];
}

-(void)reactToGetChoicesError:(NSError *)error {
    NSLog(@"ERRORRRRRRR: %@", error);
}

-(void)reactToGetChoicesResponse:(NSArray *)array {
    NSLog(@"IN HERE!!!!! %@", array);
    self.choices = [NSMutableArray arrayWithArray:array];
}

- (UIImage *)imageFromURLString:(NSString *)urlString
{
    NSURL *imageURL = [NSURL URLWithString:@"http://example.com/demo.jpg"];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}


@end
