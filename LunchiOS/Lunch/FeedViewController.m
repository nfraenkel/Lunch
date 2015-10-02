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
    
    self.singleton = [LunchSingleton sharedDataModel];
    
    UIColor *brandOrange = [UIColor colorWithRed:241.0f/255.0f green:92.0f/255.0f blue:37.0f/255.0f alpha:1.0f];
    
    // SEGMENTED CONTROL
    [self.segmentedControl addTarget:self
                              action:@selector(segmentSwitch:)
                    forControlEvents:UIControlEventValueChanged];
    
    // SCREEN SIZE
    totalSize = 0;
    screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    
    // PROFILE PIC
    NSInteger offset = 50;
    NSInteger picSize = 30;
    UIImageView *profilePhotoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - picSize - 20, offset + segmentedControl.frame.origin.y, picSize, picSize)];
    UIImage *profPic = [self imageFromURLString:self.singleton.user.photoUrl];
    [profilePhotoImageView setImage:profPic];
    profilePhotoImageView.layer.cornerRadius = 15;
    profilePhotoImageView.layer.masksToBounds = YES;
    [self.view addSubview:profilePhotoImageView];
    
    // BIG VIEW / SCROLL VIEW
    CGRect bigViewFrame = CGRectMake(0, offset + segmentedControl.frame.size.height, screenWidth, screenHeight - segmentedControl.frame.size.height - offset);
    sv = [[UIScrollView alloc] initWithFrame:bigViewFrame];
    sv.delegate = self;
    [self.view addSubview:sv];
    
    // seperator
    UIView *seperatorTop = [[UIView alloc] initWithFrame:CGRectMake(0, bigViewFrame.origin.y, screenWidth, 1)];
    [seperatorTop setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:seperatorTop];
    
    // orange top background
    CGRect orangeBGTopFrame = CGRectMake(0, 0, screenWidth, 300);
    UIView *orangeBGTop = [[UIView alloc] initWithFrame:orangeBGTopFrame];
    [orangeBGTop setBackgroundColor:brandOrange];
    [sv addSubview:orangeBGTop];
    
    // greeting label
    CGRect greetingLabelFrame = CGRectMake(0, 140, screenWidth, 40);
    UILabel *greetingLabel = [[UILabel alloc] initWithFrame:greetingLabelFrame];
    [greetingLabel setText:[NSString stringWithFormat:@"Hungry %@?", self.singleton.user.first]];
    greetingLabel.textAlignment = NSTextAlignmentCenter;
    [greetingLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:28.0f]];
    [greetingLabel setTextColor:[UIColor whiteColor]];

    // date
    CGRect lunchForFrame = CGRectMake(0, 10, screenWidth, 20);
    UILabel *lunchFor = [[UILabel alloc] initWithFrame:lunchForFrame];
    [lunchFor setText:[NSString stringWithFormat:@"Lunch for"]];
    lunchFor.textAlignment = NSTextAlignmentCenter;
    [lunchFor setTextColor:[UIColor whiteColor]];
    [lunchFor setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0f]];

    CGRect dateLabelFrame = CGRectMake(0, 32, screenWidth, 20);
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:dateLabelFrame];
    [dateLabel setText:[NSString stringWithFormat:@"Thursday, October 1"]];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [dateLabel setTextColor:[UIColor whiteColor]];
    [dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0f]];
    
    CGRect promptLabelFrame = CGRectMake(80, 220, screenWidth - 160, 50);
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:promptLabelFrame];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.numberOfLines = 2;
    [promptLabel setText:[NSString stringWithFormat:@"See where your coworkers are going for lunch"]];
    [promptLabel setTextColor:[UIColor whiteColor]];
    [promptLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0f]];
    
    NSInteger foodSize = 50;
    UIImageView *food1 = [[UIImageView alloc] initWithFrame:CGRectMake(30, 80, foodSize, foodSize)];
    [food1 setImage:[UIImage imageNamed:@"icon-food-1.png"]];
    UIImageView *food2 = [[UIImageView alloc] initWithFrame:CGRectMake(30, 200, foodSize, foodSize)];
    [food2 setImage:[UIImage imageNamed:@"icon-food-2.png"]];
    UIImageView *food3 = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2 - foodSize/2, 75, foodSize, foodSize)];
    [food3 setImage:[UIImage imageNamed:@"icon-food-3.png"]];
    UIImageView *food4 = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - 30 - foodSize, 80, foodSize, foodSize)];
    [food4 setImage:[UIImage imageNamed:@"icon-food-4.png"]];
    UIImageView *food5 = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth - 30 - foodSize, 200, foodSize, foodSize)];
    [food5 setImage:[UIImage imageNamed:@"icon-food-5.png"]];
    
    [orangeBGTop addSubview:greetingLabel];
    [orangeBGTop addSubview:lunchFor];
    [orangeBGTop addSubview:dateLabel];
    [orangeBGTop addSubview:promptLabel];
    [orangeBGTop addSubview:food1];
    [orangeBGTop addSubview:food2];
    [orangeBGTop addSubview:food3];
    [orangeBGTop addSubview:food4];
    [orangeBGTop addSubview:food5];
    
    totalSize = orangeBGTopFrame.origin.y + orangeBGTopFrame.size.height + 10;
    sv.contentSize = CGSizeMake(screenWidth, totalSize);
    
    // TABLE VIEW
    tv = [[UITableView alloc] initWithFrame:bigViewFrame];
    [tv setBackgroundColor:[UIColor blueColor]];
    tv.hidden = YES;
    
    // CONFIRMATION VIEW
    cv = [[UIView alloc] initWithFrame:bigViewFrame];
    cv.backgroundColor = [UIColor lightGrayColor];
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, screenHeight - 30 - 80, screenWidth, 40)];
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

    [self fetchChoicesForToday];
}

-(void)fetchChoicesForToday {
    GetChoicesCommand *cmd = [[GetChoicesCommand alloc] init];
    cmd.delegate = self;
    [cmd fetchChoices];
}


- (IBAction)segmentSwitch:(id)sender {
    UISegmentedControl *sc = (UISegmentedControl *) sender;
    NSInteger selectedSegment = sc.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        //toggle the correct view to be visible
        if (confirmationScreen) {
            [cv setHidden:NO];
        }
        else {
            [sv setHidden:NO];
        }
        [tv setHidden:YES];
    }
    else{
        //toggle the correct view to be visible
        if (confirmationScreen) {
            [cv setHidden:YES];
        }
        else {
            [sv setHidden:YES];
        }
        [tv setHidden:NO];
    }
}

-(void)refreshUI {
    
    for (int i = 0; i < [self.choices count]; i++) {
        Choice *ch = (Choice*)[self.choices objectAtIndex:i];
        
        NSInteger rowHeight = 120;
        CGRect rowViewFrame = CGRectMake(20, totalSize + 20, screenWidth - 40, rowHeight);
        totalSize += rowHeight;
        
        UIView *rowView = [[UIView alloc] initWithFrame:rowViewFrame];
        rowView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        rowView.layer.borderWidth = 1.0f;
        rowView.layer.cornerRadius = 5;
        rowView.layer.masksToBounds = YES;
        
        NSInteger height1 = 10;
        
        UIImage *image = [self imageFromURLString:ch.venue.photoUrl];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, height1, 40, 40)];
        [imageView setImage:image];
        imageView.layer.cornerRadius = imageView.frame.size.height/2;
        imageView.layer.masksToBounds = YES;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, height1, screenWidth - 50, 20)];
        [nameLabel setText:ch.venue.name];
        
        UILabel *subHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, height1 + 20, screenWidth - 50, 20)];
        NSString *category = ch.venue.type;
        NSString *distance = ch.venue.distance;
        [subHeaderLabel setText:[NSString stringWithFormat:@"%@ - %@ miles away", category, distance]];
        
        UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(5, rowHeight / 2, rowViewFrame.size.width - 10, 1)];
        [seperator setBackgroundColor:[UIColor lightGrayColor]];
        
        // users
        NSInteger runningX = 5;
        NSArray *users = ch.users;
        for (int i = 0; i < [users count]; i++) {
            if (i == 3) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(runningX, 60, 20, 20)];
                [imageView setTag:i];
                [imageView setImage:[UIImage imageNamed:@"default-user.png"]];
                imageView.layer.cornerRadius = imageView.frame.size.height/2;
                imageView.layer.masksToBounds = YES;
                [rowView addSubview:imageView];

                runningX += 20 + 5;
                break;
            }
            User *u = (User*)[users objectAtIndex:i];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(runningX, 80, 20, 20)];
            [imageView setTag:i];
            [imageView setImage:[self imageFromURLString:u.photoUrl]];
            imageView.layer.cornerRadius = imageView.frame.size.height/2;
            imageView.layer.masksToBounds = YES;
            [rowView addSubview:imageView];
            
            runningX += 20 + 5;
        }
        UILabel *usersGoingLabel = [[UILabel alloc] initWithFrame:CGRectMake(runningX, 80, screenWidth - runningX, 20)];
        NSString *usersText = NULL;
        switch ([users count]) {
            case 0:
                usersText = [NSString stringWithFormat:@"No users are going to %@", ch.venue.name];
                break;
            case 1:
                usersText = @" is going";
                break;
            default:
                usersText = @" are going";
                break;
        }
        [usersGoingLabel setText:usersText];
        [usersGoingLabel setTextColor:[UIColor lightGrayColor]];
        [usersGoingLabel setFont:[UIFont systemFontOfSize:10.0f]];
        [rowView addSubview:usersGoingLabel];
        
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
    confirmationScreen = YES;
}

-(void)cancelLunch:(UIButton *)sender {
    NSLog(@"CANCELLING");
    [sv setHidden:NO];
    [cv setHidden:YES];
    confirmationScreen = NO;
}

-(void)reactToGetChoicesError:(NSError *)error {
    NSLog(@"ERRORRRRRRR: %@", error);
}

-(void)reactToGetChoicesResponse:(NSMutableArray *)array {
    self.choices = array;
    [self refreshUI];
}

- (UIImage *)imageFromURLString:(NSString *)urlString {
    NSURL *imageURL = [NSURL URLWithString:urlString];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}


@end
